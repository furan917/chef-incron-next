service 'incrond' do
  action :nothing
end

incron_next_user 'baduser' do
  action :deny
end
