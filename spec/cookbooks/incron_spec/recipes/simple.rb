include_recipe 'incron-next'

incron_next_d 'notify_home_changes' do
  path '/home'
  mask 'IN_MODIFY'
  command '/usr/local/bin/abcd'
end
