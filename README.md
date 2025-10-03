# chef-incron-next

This is a fork of the original [chef-incron](https://github.com/dwradcliffe/chef-incron), which has been updated to install incron-next on modern systems.
The final version of incron, 5.0.12, has a few bugs such as leaving zombie processes, and hanging, which have been fixed in incron-next.
incron-next is installed as incron and built from source - can be configured via attributes for version and if local or remote source.

For backwards compatibility the resources incron_d and incron_user are aliased to incron_next_d and incron_next_user respectively.

---


Installs the incron package and starts the incrond service.

## About incron

Incron is an "inotify cron" system. It consists of a daemon and a table manipulator. You can use it a similar way as the regular cron. The difference is that the inotify cron handles filesystem events rather than time periods.

[More information about incron](http://inotify.aiken.cz/?section=incron&page=about&lang=en)

## Attributes

### `default`

* `default['incron']['allowed_users']` is an array of users allowed, defaults to `["root"]`
* `default['incron']['denied_users']` is an array of users denied, defaults to `[]`
* `default['incron']['editor']` is the editor user editing a job via command line, defaults to `vim`
* `default['incron']['service_name']` is the name of the system service, defaults to `incron` on debian and `incrond` on rhel platforms

## Recipes

### `default`

This will install the incron package and start the service.

## Resources

### `incron_d`

This resource helps you create a system incron table.

```ruby
incron_d "notify_home_changes" do
  path "/home"
  mask "IN_MODIFY"
  command "/usr/local/bin/abcd"
end
```

[More information about syntax](http://linux.die.net/man/5/incrontab)

### `incron_user`

This resource helps you manage the allow and deny list for incron.

```ruby
incron_user "root" do
  action :allow
end
```

## License, Author and Contributor(s)

License: [MIT](https://github.com/dwradcliffe/chef-incron/blob/master/LICENSE)

Author: [David Radcliffe](https://github.com/dwradcliffe)

Contributor: [Salvatore Poliandro III](https://github.com/popsikle)

