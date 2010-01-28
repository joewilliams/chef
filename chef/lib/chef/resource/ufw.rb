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

require 'chef/resource'

class Chef
  class Resource
    class Ufw < Chef::Resource

      def initialize(name, collection=nil, node=nil)
        super(name, collection, node)
        @resource_name = :ufw

        @dest_port = nil
        @dest_addr = nil
        @src_port = nil
        @src_addr = "anywhere"
        @protocol = nil
        @type = "allow"
        @exists = false

        @action = :create
        @allowed_actions.push(:create, :delete)
      end

      def dest_port(arg=nil)
        set_or_return(
          :dest_port,
          arg,
          :kind_of => [ Integer ]
        )
      end

      def dest_addr(arg=nil)
        set_or_return(
          :dest_addr,
          arg,
          :kind_of => [ String ]
        )
      end

      def src_port(arg=nil)
        set_or_return(
          :src_port,
          arg,
          :kind_of => [ Integer ]
        )
      end

      def src_addr(arg=nil)
        set_or_return(
          :src_addr,
          arg,
          :kind_of => [ String ]
        )
      end

      def protocol(arg=nil)
        set_or_return(
          :protocol,
          arg,
          :kind_of => [ String ]
        )
      end

      def type(arg=nil)
        set_or_return(
          :type,
          arg,
          :kind_of => [ String ]
        )
      end

      def exists(arg=nil)
        set_or_return(
          :exists,
          arg,
          :kind_of => [ TrueClass, FalseClass ]
        )
      end

    end
  end
end