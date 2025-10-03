service 'incrond' do
  action :nothing
end

# Test backward compatibility aliases
incron_user 'aliasuser' do
  action :allow
end

incron_d 'alias_watch' do
  path '/tmp'
  mask 'IN_CREATE'
  command '/bin/true'
end
