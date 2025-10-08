describe 'incron-next::default' do
  # Service tests with clear descriptions
  if os.debian?
    describe service('incron') do
      it { should be_enabled }
      it { should be_running }
    end

    describe 'systemd service file for Debian' do
      subject { file('/etc/systemd/system/incron.service') }
      it { should exist }
      it { should be_file }
      it { should be_mode 0644 }
    end
  elsif os.redhat?
    describe service('incrond') do
      it { should be_enabled }
      it { should be_running }
    end

    describe 'systemd service file for RHEL' do
      subject { file('/etc/systemd/system/incrond.service') }
      it { should exist }
      it { should be_file }
      it { should be_mode 0644 }
    end
  end

  describe 'incron configuration file' do
    subject { file('/etc/incron.conf') }
    it { should exist }
    it { should be_file }
    it { should be_mode 0644 }
  end

  describe 'incrond daemon binary' do
    subject { file('/usr/local/sbin/incrond') }
    it { should exist }
    it { should be_file }
    it { should be_executable }
  end

  describe 'incrontab user command' do
    subject { file('/usr/local/bin/incrontab') }
    it { should exist }
    it { should be_file }
    it { should be_executable }
  end
end
