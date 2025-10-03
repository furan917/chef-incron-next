name             'incron-next'
maintainer       'Francis Gallagher'
maintainer_email 'francis@akoova.com'
license          'MIT'
description      'Installs and configures incron-next, fork of incron'
version          '0.3.5'

recipe 'incron-next', 'Install incron package and starts the service'

depends 'yum'
depends 'yum-repoforge'

supports 'centos'
supports 'debian'
supports 'scientific'
supports 'ubuntu'
