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

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe Chef::Provider::Mdadm, "initialize" do

  before(:each) do
    @node = mock("Chef::Node", :null_object => true)
    @new_resource = mock("Chef::Resource", :null_object => true)
    @provider = Chef::Provider::Mdadm.new(@node, @new_resource)
  end

  it "should return a Chef::Provider::Mdadm object" do
    provider = Chef::Provider::Mdadm.new(@node, @new_resource)
    provider.should be_a_kind_of(Chef::Provider::Mdadm)
  end

  it "should return true" do
    @provider.load_current_resource.should eql(true)
  end
end

describe Chef::Provider::Mdadm, "action_create" do
  before(:each) do
    @node = mock("Chef::Node", :null_object => true)
    @new_resource = mock("Chef::Resource::Mdadm",
    :null_object => true,
    :raid_device => "/dev/md1",
    :name => "test",
    :devices => ["/dev/sda", "/dev/sdb"],
    :chunk => 256,
    :level => 1
    )
    @current_resource = mock("Chef::Resource::Mdadm",
    :null_object => true,
    :raid_device => "/dev/md1",
    :name => "test",
    :devices => ["/dev/sda", "/dev/sdb"],
    :chunk => 256,
    :level => 1
    )
    @provider = Chef::Provider::Mdadm.new(@node, @new_resource)
    @provider.current_resource = @current_resource
    @provider.stub!(:create).and_return(true)
  end

end

describe Chef::Provider::Mdadm, "action_assemble" do
  before(:each) do
    @node = mock("Chef::Node", :null_object => true)
    @new_resource = mock("Chef::Resource::Mdadm",
    :null_object => true,
    :raid_device => "/dev/md1",
    :name => "test",
    :devices => ["/dev/sda", "/dev/sdb"],
    :chunk => 256,
    :level => 1
    )
    @current_resource = mock("Chef::Resource::Mdadm",
    :null_object => true,
    :raid_device => "/dev/md1",
    :name => "test",
    :devices => ["/dev/sda", "/dev/sdb"],
    :chunk => 256,
    :level => 1
    )
    @provider = Chef::Provider::Mdadm.new(@node, @new_resource)
    @provider.current_resource = @current_resource
    @provider.stub!(:assemble).and_return(true)
  end


end

describe Chef::Provider::Mdadm, "action_stop" do
  before(:each) do
    @node = mock("Chef::Node", :null_object => true)
    @new_resource = mock("Chef::Resource::Mdadm",
    :null_object => true,
    :raid_device => "/dev/md1",
    :name => "test",
    :devices => ["/dev/sda", "/dev/sdb"],
    :chunk => 256,
    :level => 1
    )
    @current_resource = mock("Chef::Resource::Mdadm",
    :null_object => true,
    :raid_device => "/dev/md1",
    :name => "test",
    :devices => ["/dev/sda", "/dev/sdb"],
    :chunk => 256,
    :level => 1
    )
    @provider = Chef::Provider::Mdadm.new(@node, @new_resource)
    @provider.current_resource = @current_resource
    @provider.stub!(:stop).and_return(true)
  end


end
