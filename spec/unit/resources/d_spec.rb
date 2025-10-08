require 'spec_helper'

describe 'incron_next_d' do

  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['incron_next_d']).converge('incron_spec::simple') }

  before do
    stub_command(/rpm -qa | grep -q '^rpmforge-release-[0-9\.-]'/).and_return(true)
  end

  it 'should render fragment' do
    expect(chef_run).to render_file('/etc/incron.d/notify_home_changes').with_content('/home IN_MODIFY /usr/local/bin/abcd')
  end

  it 'should reload incrond' do
    expect(chef_run.template('/etc/incron.d/notify_home_changes')).to notify('service[incrond]').to(:restart)
  end

  context 'on an el 7 system' do
    let(:chef_run) { ChefSpec::SoloRunner.new(:platform => 'ubuntu', :version => '24.04', step_into: ['incron_next_d']).converge('incron_spec::simple') }

    it 'should restart incrond' do
      expect(chef_run.template('/etc/incron.d/notify_home_changes')).to notify('service[incrond]').to(:restart)
    end
  end

end
