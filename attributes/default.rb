default['incron']['allowed_users'] = ['root']
default['incron']['denied_users'] = []
default['incron']['editor'] = 'vim'

# incron-next installation
default['incron']['version'] = '0.5.17'
default['incron']['use_local_source'] = false
default['incron']['source_url'] = "https://github.com/dpvpro/incron-next/archive/refs/tags/#{node['incron']['version']}.tar.gz"
default['incron']['install_prefix'] = '/usr/local'
default['incron']['build_dependencies'] = case node['platform_family']
                                          when 'debian'
                                            ['build-essential', 'make', 'g++']
                                          when 'rhel', 'amazon'
                                            ['gcc', 'gcc-c++', 'make']
                                          when 'suse'
                                            ['gcc', 'gcc-c++', 'make']
                                          else
                                            %w(gcc make)
                                          end

default['incron']['reload_method'] = if (platform_family?('rhel') && node['platform_version'].to_f < 7.0) ||
                                        (platform?('amazon') && node['platform_version'].to_i < 2) ||
                                        (platform?('ubuntu') && node['platform_version'].to_f < 16.04) ||
                                        (platform?('debian') && node['platform_version'].to_f < 8.0) ||
                                        (platform_family?('suse') && node['platform_version'].to_f < 12.0)
                                       :reload
                                     else
                                       :restart
                                     end

default['incron']['service_name'] = if platform_family?('debian')
                                      'incron'
                                    else
                                      'incrond'
                                    end
