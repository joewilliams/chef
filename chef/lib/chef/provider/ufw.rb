#
# Author:: Joe Williams (<joe@joetify.com>)
# Copyright:: Copyright (c) 2009 Joe Williams
# License:: Apache License, Version 2.0
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

require 'chef/log'
require 'chef/mixin/command'
require 'chef/provider'

class Chef
  class Provider
    class Ufw < Chef::Provider
      include Chef::Mixin::Command

      def initialize(node, new_resource)
        super(node, new_resource)
      end

      def load_current_resource
        true
      end

      def action_allow
        command = "ufw allow #{@new_resource.dest_port}"
        run_command(:command => command)
      end

      def action_deny
      end

      def action_delete
      end

    end
  end
end
