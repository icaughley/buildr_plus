# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with this
# work for additional information regarding copyright ownership.  The ASF
# licenses this file to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations under
# the License.

require 'buildr/gwt'

module Buildr
  module GWT
    class << self

      def version
        @version || Buildr.settings.build['gwt'] || '2.8.0'
      end

      # The specs for requirements
      def dependencies(version = nil)
        validation_deps =
          %w(javax.validation:validation-api:jar:1.0.0.GA javax.validation:validation-api:jar:sources:1.0.0.GA)
        v = version || self.version
        gwt_dev_jar = "com.google.gwt:gwt-dev:jar:#{v}"
        if v <= '2.6.1'
          [gwt_dev_jar] + validation_deps
        elsif v == '2.7.0'
          [
            gwt_dev_jar,
            'org.ow2.asm:asm:jar:5.0.3'
          ] + validation_deps
        elsif v == '2.8.0'
          %w(
              com.google.jsinterop:jsinterop-annotations:jar:1.0.1
              com.google.jsinterop:jsinterop-annotations:jar:sources:1.0.1
              org.w3c.css:sac:jar:1.3
              com.google.gwt:gwt-dev:jar:2.8.0
              com.google.gwt:gwt-user:jar:2.8.0
              com.google.code.gson:gson:jar:2.6.2
              org.ow2.asm:asm:jar:5.0.3
              org.ow2.asm:asm-util:jar:5.0.3
              org.ow2.asm:asm-tree:jar:5.0.3
              org.ow2.asm:asm-commons:jar:5.0.3
              colt:colt:jar:1.2.0
              ant:ant:jar:1.6.5
              commons-collections:commons-collections:jar:3.2.2
              commons-io:commons-io:jar:2.4
              com.ibm.icu:icu4j:jar:50.1.1
              tapestry:tapestry:jar:4.0.2
          ) + validation_deps
        else
          raise "Unknown GWT version #{v}"
        end
      end

      def gwtc_main(modules, source_artifacts, output_dir, unit_cache_dir, options = {})
        base_dependencies = self.dependencies(options[:version])
        cp = Buildr.artifacts(base_dependencies).each(&:invoke).map(&:to_s) + Buildr.artifacts(source_artifacts).each(&:invoke).map(&:to_s)
        style = options[:style] || 'OBFUSCATED' # 'PRETTY', 'DETAILED'
        log_level = options[:log_level] #  ERROR, WARN, INFO, TRACE, DEBUG, SPAM, or ALL
        workers = options[:workers] || 2

        args = []
        if log_level
          args << '-logLevel'
          args << log_level
        end
        args << '-strict'
        unless style == 'OBFUSCATED'
          args << '-style'
          args << style
        end
        args << '-localWorkers'
        args << workers
        args << '-war'
        args << output_dir
        if options[:compile_report_dir]
          args << '-compileReport'
          args << '-extra'
          args << options[:compile_report_dir]
        end

        if options[:draft_compile]
          args << '-draftCompile'
        end

        if options[:enable_closure_compiler]
          args << '-XenableClosureCompiler'
        end

        args += modules

        properties = options[:properties] ? options[:properties].dup : {}
        properties['gwt.persistentunitcache'] = 'true'
        properties['gwt.persistentunitcachedir'] = unit_cache_dir

        Java::Commands.java 'com.google.gwt.dev.Compiler', *(args + [{:classpath => cp, :properties => properties, :java_args => options[:java_args], :pathing_jar => false}])
      end

      def gwt_css2gss(filenames, options = {})
        cp = Buildr.artifacts(self.dependencies(options[:version])).each(&:invoke).map(&:to_s)
        properties = options[:properties] ? options[:properties].dup : {}
        java_args = options[:java_args] ? options[:java_args].dup : {}
        Java::Commands.java 'com.google.gwt.resources.converter.Css2Gss', *([filenames] + [{ :classpath => cp, :properties => properties, :java_args => java_args, :pathing_jar => false }])
      end
    end

    module ProjectExtension
      include Extension

      first_time do
        desc 'Run C22 to GSS converter. Set css files via environment variable CSS_FILES'
        task('css2gss') do
          raise 'Please specify css files or directory via variable CSS_FILES' unless ENV['CSS_FILES']
          Buildr::GWT.gwt_css2gss(ENV['CSS_FILES'].to_s.split(' '))
        end
      end
    end
  end
end

class Buildr::Project
  include Buildr::GWT::ProjectExtension
end
