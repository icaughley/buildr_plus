#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module BuildrPlus
  module CiExtension
    module ProjectExtension
      include Extension

      first_time do
        task 'ci:common_setup' do
          Buildr.repositories.release_to[:url] = ENV['UPLOAD_REPO']
          Buildr.repositories.release_to[:username] = ENV['UPLOAD_USER']
          Buildr.repositories.release_to[:password] = ENV['UPLOAD_PASSWORD']
          ENV['TEST'] = 'all' unless ENV['TEST']
        end

        dbt_present = Object.const_defined?('Dbt')
        base_directory = File.dirname(Buildr.application.buildfile.to_s)
        ci_config_exist = ::File.exist?(File.expand_path("#{base_directory}/config/ci-database.yml"))
        ci_import_config_exist = ::File.exist?(File.expand_path("#{base_directory}/config/ci-import-database.yml"))

        task 'ci:test_configure' do
          if dbt_present
            Dbt::Config.environment = 'test'
            Dbt.repository.load_configuration_data

            Dbt.database_keys.each do |database_key|
              database = Dbt.database_for_key(database_key)
              next unless database.enable_rake_integration? || database.packaged?
              prefix = Dbt::Config.default_database?(database_key) ? '' : "#{database_key}."
              jdbc_url = Dbt.configuration_for_key(database_key).build_jdbc_url(:credentials_inline => true)
              Buildr.projects.each do |project|
                project.test.options[:properties].merge!("#{prefix}test.db.url" => jdbc_url)
              end
            end
          end
        end

        if ci_import_config_exist
          desc 'Setup test environment for testing import process'
          task 'ci:import:setup' => %w(ci:common_setup) do
            Dbt::Config.config_filename = 'config/ci-import-database.yml'
            task('ci:test_configure').invoke
          end
        end

        desc 'Setup test environment'
        task 'ci:setup' => %w(ci:common_setup) do
          if dbt_present && ci_config_exist
            if !BuildrPlus::DbConfig.is_multi_database_project? || BuildrPlus::DbConfig.mssql?
              Dbt::Config.config_filename = 'config/ci-database.yml'
            elsif BuildrPlus::DbConfig.is_multi_database_project? || BuildrPlus::DbConfig.pgsql?
              # Assume that a multi database project defaults to sql server and has second yml for pg
              Dbt::Config.config_filename = 'config/ci-pg-database.yml'
            end
            task('ci:test_configure').invoke
          end
        end

        task 'ci:no_test_setup' => %w(ci:setup) do
          ENV['TEST'] = 'no'
        end

        if dbt_present && (ci_config_exist || ci_import_config_exist)
          desc 'Test the import process'
          task 'ci:import' => %W(ci#{ci_import_config_exist ? ':import' : ''}:setup clean dbt:create_by_import dbt:verify_constraints dbt:drop)
        end

        desc 'Publish artifacts to repository'
        task 'ci:publish' => %w(ci:setup publish)

        desc 'Publish artifacts to repository'
        task 'ci:upload' => %w(ci:setup upload_published)

        commit_actions = %w(ci:setup clean)
        package_actions = %w(ci:setup clean)
        package_no_test_actions = %w(ci:no_test_setup clean)

        if Object.const_defined?('Domgen')
          commit_actions << 'domgen:all'
          package_actions << 'domgen:all'
          package_no_test_actions << 'domgen:all'
        end

        database_drops = []

        if Object.const_defined?('Dbt')
          Dbt.database_keys.each do |database_key|
            database = Dbt.database_for_key(database_key)
            next unless database.enable_rake_integration? || database.packaged?
            prefix = Dbt::Config.default_database?(database_key) ? '' : ":#{database_key}"

            commit_actions << "dbt#{prefix}:create"
            package_actions << "dbt#{prefix}:create"
            database_drops << "dbt#{prefix}:drop"
          end
        end

        task 'ci:source_code_analysis'

        commit_actions << 'ci:source_code_analysis'

        package_actions << 'test'
        package_no_test_actions << 'test'

        package_actions << 'package'
        package_no_test_actions << 'package'

        commit_actions.concat(database_drops)
        package_actions.concat(database_drops)

        package_actions << 'ci:upload'
        package_no_test_actions << 'ci:upload'

        desc 'Perform pre-commit checks and source code analysis'
        task 'ci:commit' => commit_actions

        desc 'Build the package(s) and run tests'
        task 'ci:package' => package_actions

        desc 'Build the package(s) but do not run tests'
        task 'ci:package_no_tests' => package_no_test_actions
      end

      after_define do |project|
        project.task(':ci:source_code_analysis') do
          task("#{project.name}:jdepend:html").invoke if project.jdepend.enabled?
          if project.findbugs.enabled?
            task("#{project.name}:findbugs:xml").invoke
            task("#{project.name}:findbugs:html").invoke
          end
          if project.pmd.enabled?
            task("#{project.name}:pmd:rule:html").invoke
            task("#{project.name}:pmd:rule:xml").invoke
          end
          task("#{project.name}:checkstyle:xml").invoke if project.checkstyle.enabled?
        end
      end
    end
  end
end

class Buildr::Project
  include BuildrPlus::CiExtension::ProjectExtension
end