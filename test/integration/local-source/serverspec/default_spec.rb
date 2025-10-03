require 'spec_helper'

describe 'incron-next::default' do
  describe service('incron'), :if => os[:family] == 'ubuntu' do
    it { should be_enabled }
    it { should be_running }
  end
  describe service('incrond'), :if => os[:family] == 'redhat' do
    it { should be_enabled }
    it { should be_running }
  end
end
