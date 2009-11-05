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
        @current_resource = Chef::Resource::Mdadm.new(@new_resource.name)
        @current_resource.name(@new_resource.name)
        Chef::Log.debug("Checking for ufw rule #{@current_resource.name}")

        command = "ufw status"
        rule_list = []
        status = popen4(command) do |pid, stdin, stdout, stderr|
          stdout.each do |line|
            unless line == "\n"
              line.downcase!
              rule_list << line.split
            end
          end
        end
        rule_list.shift
        rule_list.shift
        rule_list.shift

        exists = false
        rule_list.each do |entry|
          if entry == rule
            exists = true
          end
        end
        @current_resource.exists(exists)
      end

      def build_rule(dest_port, dest_addr, src_port, src_addr, protocol, type)
        rule = []

        if protocol
          rule = [dest_addr, "#{dest_port}/#{protocol}", type, src_addr, "#{src_port}/#{protocol}"]
        else
          rule = [dest_addr, dest_port, type, src_addr, src_port]
        end

        rule.delete(nil)
        rule.delete("/tcp")
        rule.delete("/udp")

        rule
      end

      def build_cmd(dest_port, dest_addr, src_port, src_addr, protocol, action, type)
        ufw = "ufw"

        if action == :delete
          ufw = "ufw delete"
        end

        if dest_port && src_addr == "anywhere"
          # example: ufw allow 9090
          command = "#{ufw} #{type} #{dest_port}"
        end

        if dest_port != "anywhere" && src_addr != "anywhere"
          # example: ufw allow from 192.168.0.0/16 to any port 9090
          command = "#{ufw} #{type} from #{src_addr} to any port #{dest_port}"
        end

        if dest_port == "anywhere" && src_addr != "anywhere"
          # example: ufw allow from 1.1.1.1
          command = "#{ufw} #{type} from #{src_addr}"
        end

        if dest_port && protocol && src_addr == "anywhere"
          # example: ufw allow 9090/tcp
          command = "#{ufw} #{type} #{dest_port}/#{protocol}"
        end

        if dest_port == "anywhere" && protocol && src_addr != "anywhere"
          # example: ufw allow proto tcp from 1.1.1.1
          command = "#{ufw} #{type} proto #{protocol} from #{src_addr}"
        end

        if dest_port != "anywhere" && protocol && src_addr != "anywhere"
          # example: ufw allow proto tcp from 1.1.1.1 to any port 9090
          command = "#{ufw} #{type} proto #{protocol} from #{src_addr} to any port #{dest_port}"
        end

        if dest_port && protocol && src_port && src_addr != "anywhere"
          # example: ufw allow proto tcp from 192.168.0.0/16 port 7809 to any port 9090
          command = "#{ufw} #{type} proto #{protocol} from #{src_addr} port #{src_port} to any port #{dest_port}"
        end

        if dest_port && dest_addr && src_port && src_addr && protocol
          # example: ufw allow proto tcp from 192.168.0.0/16 port 7809 to 1.1.1.1 port 9090
          command = "#{ufw} #{type} proto #{protocol} from #{src_addr} port #{src_port} to #{dest_addr} port #{dest_port}"
        end

        command
      end

      def action_create
        unless @current_resource.exists
          rule = build_rule(@new_resource.dest_port, @new_resource.dest_addr, @new_resource.src_port, @new_resource.src_addr, @new_resource.protocol, @new_resource.type)
          command = build_cmd(@new_resource.dest_port, @new_resource.dest_addr, @new_resource.src_port, @new_resource.src_addr, @new_resource.protocol, @new_resource.action, @new_resource.type)
          run_command(:command => command)
          Chef::Log.debug("created ufw rule (#{@new_resource.name})")
        else
          Chef::Log.debug("ufw rule already exists (#{@new_resource.name})")
        end
      end

      def action_delete
        if @current_resource.exists
          rule = build_rule(@new_resource.dest_port, @new_resource.dest_addr, @new_resource.src_port, @new_resource.src_addr, @new_resource.protocol, @new_resource.type)
          command = build_cmd(@new_resource.dest_port, @new_resource.dest_addr, @new_resource.src_port, @new_resource.src_addr, @new_resource.protocol, @new_resource.action, @new_resource.type)
          run_command(:command => command)
          Chef::Log.debug("deleted ufw rule (#{@new_resource.name})")
        else
          Chef::Log.debug("ufw rule doesn't exist (#{@new_resource.name})")
        end
      end

    end
  end
end
