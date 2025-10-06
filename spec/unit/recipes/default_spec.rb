require 'spec_helper'

describe 'incron-next::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04').converge(described_recipe) }

  before do
    stub_command(/rpm -qa | grep -q '^rpmforge-release-[0-9\.-]'/).and_return(true)
    stub_command('systemctl list-unit-files | grep -q "incron.*masked"').and_return(false)
  end

  it 'builds incron-next from source' do
    expect(chef_run).to include_recipe('incron-next::install')
  end

  context 'in a redhat-based platform' do
    let(:chef_run) { ChefSpec::SoloRunner.new(:platform => 'ubuntu', :version => '24.04').converge(described_recipe) }

    it 'does not include the yum-repoforge recipe' do
      expect(chef_run).not_to include_recipe('yum-repoforge')
    end

  end

  it 'enables the service' do
    expect(chef_run).to enable_service('incrond')
  end

  it 'starts the service' do
    expect(chef_run).to start_service('incrond')
  end

end
