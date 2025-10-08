require 'spec_helper'

describe 'incron-next::install' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04').converge(described_recipe) }

  context 'when using remote source (default)' do
    it 'installs build dependencies' do
      expect(chef_run).to install_package('build-essential')
      expect(chef_run).to install_package('make')
      expect(chef_run).to install_package('g++')
    end

    it 'downloads incron-next tarball from GitHub' do
      expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/incron-next-0.5.17.tar.gz")
        .with(source: 'https://github.com/dpvpro/incron-next/archive/refs/tags/0.5.17.tar.gz')
    end

    it 'extracts the tarball' do
      expect(chef_run).to run_bash('extract_incron_next')
    end

    it 'builds and installs incron-next' do
      expect(chef_run).to run_bash('build_incron_next')
    end
  end

  context 'when using local source' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04') do |node|
        node.normal['incron']['use_local_source'] = true
        node.normal['incron']['version'] = '0.5.12'
      end.converge(described_recipe)
    end

    it 'uses cookbook file instead of remote download' do
      expect(chef_run).to create_cookbook_file("#{Chef::Config[:file_cache_path]}/incron-next-0.5.12.tar.gz")
        .with(source: 'incron-next-0.5.12.tar.gz')
    end

    it 'does not download from GitHub' do
      expect(chef_run).not_to create_remote_file("#{Chef::Config[:file_cache_path]}/incron-next-0.5.12.tar.gz")
    end
  end

  context 'on RHEL platform' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'centos', version: '8').converge(described_recipe) }

    it 'installs RHEL build dependencies' do
      expect(chef_run).to install_package('gcc')
      expect(chef_run).to install_package('gcc-c++')
      expect(chef_run).to install_package('make')
    end
  end
end
