service 'incrond' do
  action :nothing
end

incron_next_user 'testuser' do
  action :allow
end
