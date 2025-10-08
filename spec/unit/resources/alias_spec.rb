require 'spec_helper'

describe 'resource aliases for backward compatibility' do
  before do
    stub_command(/rpm -qa | grep -q '^rpmforge-release-[0-9\.-]'/).and_return(true)
  end

  context 'using incron_user alias' do
    override_attributes['incron']['allowed_users'] = ['root']
    override_attributes['incron']['reload_method'] = :restart

    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: %w(incron_user incron_next_user)).converge('incron_spec::alias_test')
    end

    it 'should allow the alias to work' do
      expect(chef_run).to render_file('/etc/incron.allow').with_content(/aliasuser/)
    end
  end

  context 'using incron_d alias' do
    override_attributes['incron']['reload_method'] = :restart

    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: %w(incron_d incron_next_d)).converge('incron_spec::alias_test')
    end

    it 'should allow the alias to work' do
      expect(chef_run).to render_file('/etc/incron.d/alias_watch').with_content(%r{/tmp IN_CREATE /bin/true})
    end
  end
end
