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
  module SourceCodeAnalysisExtension
    module ProjectExtension
      include Extension

      before_define do |project|
        if project.ipr?
          project.jdepend.enabled = true
          project.findbugs.enabled = true
          project.pmd.enabled = true
        end
      end
    end
  end
end

class Buildr::Project
  include BuildrPlus::SourceCodeAnalysisExtension::ProjectExtension
end