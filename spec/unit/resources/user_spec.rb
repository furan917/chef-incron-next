require 'spec_helper'

describe 'incron_next_user' do
  before do
    stub_command(/rpm -qa | grep -q '^rpmforge-release-[0-9\.-]'/).and_return(true)
  end

  context 'when allowing a user' do
    override_attributes['incron']['allowed_users'] = ['root']
    override_attributes['incron']['reload_method'] = :restart

    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['incron_next_user']).converge('incron_spec::user_simple')
    end

    it 'should create /etc/incron.allow with testuser' do
      expect(chef_run).to render_file('/etc/incron.allow').with_content(/testuser/)
    end

    it 'should create /etc/incron.allow with root' do
      expect(chef_run).to render_file('/etc/incron.allow').with_content(/root/)
    end

    it 'should create the allow file template' do
      expect(chef_run).to create_template('/etc/incron.allow')
    end
  end

  context 'when denying a user' do
    override_attributes['incron']['denied_users'] = []
    override_attributes['incron']['reload_method'] = :restart

    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['incron_next_user']).converge('incron_spec::user_deny')
    end

    it 'should create /etc/incron.deny with baduser' do
      expect(chef_run).to render_file('/etc/incron.deny').with_content(/baduser/)
    end

    it 'should create the deny file template' do
      expect(chef_run).to create_template('/etc/incron.deny')
    end
  end
end
