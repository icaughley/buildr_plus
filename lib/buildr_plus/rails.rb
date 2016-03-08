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

require 'buildr_plus'

require 'warbler'

# Addons present in all of the "standard" projects
require 'buildr/single_intermediate_layout'
require 'buildr/git_auto_version'
require 'buildr/top_level_generate_dir'

require 'buildr_plus/features/db'
require 'buildr_plus/features/product_version'
require 'buildr_plus/features/libs'
require 'buildr_plus/features/repositories'
require 'buildr_plus/features/rails'
require 'buildr_plus/features/sass'

# Enable features if the corresponding libraries are loaded
require 'buildr_plus/features/dbt'
require 'buildr_plus/features/domgen'
require 'buildr_plus/features/dialect_mapping'
require 'buildr_plus/features/rptman'
require 'buildr_plus/features/itest'

# Ci must be at the end as it relies on other features being loaded
require 'buildr_plus/features/ci'

BuildrPlus::ExtensionRegistry.auto_activate!