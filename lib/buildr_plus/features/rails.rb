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
  class RailsConfig
    class << self
      def is_rails_app?
        base_directory = File.dirname(Buildr.application.buildfile.to_s)
        File.exist?("#{base_directory}/config/environment.rb")
      end

      attr_writer :warble

      def warble?
        @warble.nil? ? true : !!@warble
      end

      attr_writer :additional_warble_excludes

      def additional_warble_excludes
        @additional_warble_excludes ||= []
      end

      attr_accessor :warble_package
    end
  end
end

if BuildrPlus::RailsConfig.is_rails_app?
  module BuildrPlus
    module RailsExtension
      module ProjectExtension
        include Extension
        BuildrPlus::ExtensionRegistry.register(self)
        first_time do
          base_directory = File.dirname(Buildr.application.buildfile.to_s)

          task 'db:driver:download' do
            a = Buildr.artifact(BuildrPlus::Libs.jtds[0])
            a.invoke
            destination = "#{base_directory}/vendor/jars/jtds-#{a.version}.jar"
            mkdir_p File.dirname(destination)
            cp a.to_s, destination
          end

          desc 'Copy the plugin assets to public directory'
          task 'assets:copy_plugin_assets' => %w(db:driver:download) do
            # Running a script is sufficient to copy all plugin assets across
            ruby_command = Buildr::Util.win_os? ? 'jruby' : 'ruby'
            sh "bundle exec #{ruby_command} #{base_directory}/script/runner 'exit'"
          end

          task 'assets:copy_plugin_assets' => %w(domgen:all) if Object.const_defined?('Domgen')

          code_dirs = %w(app config vendor lib)
          code_dirs << 'generated' if Object.const_defined?('Domgen')

          excludes =
            %w(
                config/database.yml
                config/ci-database.yml
                config/ci-import-database.yml
                config/config.properties
                config/config.example.properties
                config/database.example.yml
                config/prod-broker.yml
                config/prod-database.yml
                config/deploy.sh
                config/setup.sh
                config/environments/development.rb
                config/environments/test.rb
                vendor/tools
                vendor/tools/**/*
                vendor/docs
                vendor/docs/**/*
            )
          excludes.concat(BuildrPlus::RailsConfig.additional_warble_excludes)
          excludes.concat(BuildrPlus::SassConfig.sass_paths.collect { |p| [p, "#{p}/**/*"] }.flatten) if Object.const_defined?('Sass')

          warbler_config = Warbler::Config.new do |config|
            config.dirs = code_dirs
            config.jar_name = "#{base_directory}/target/warbled_project"
            config.excludes = excludes
          end
          Warbler::Task.new('warble_package', warbler_config)

          task('warble_package:create_dir') do
            mkdir_p File.dirname(warbler_config.jar_name)
          end

          task('warble_package').enhance(%w(warble_package:create_dir))
          task('warble_package').enhance(%w(domgen:all)) if Object.const_defined?('Domgen')
          task('warble_package').enhance(%w(assets:precompile)) if Object.const_defined?('Sass')

          BuildrPlus::RailsConfig.warble_package = file("#{warbler_config.jar_name}.war" => %w(warble_package))
        end

        after_define do |project|
          if project.ipr?
            base_directory = File.dirname(Buildr.application.buildfile.to_s)

            project.package(:war).tap do |war|
              war.merge BuildrPlus::RailsConfig.warble_package
              war.include 'config/prod-database.yml', :as => 'WEB-INF/config/database.yml' if File.exist?("#{base_directory}/config/prod-database.yml")
            end

            %w(log tmp).each do |path|
              project.clean { rm_rf(Dir["#{project._(path)}/[^.]*"]) }
            end
          end
        end
      end
    end
  end
end