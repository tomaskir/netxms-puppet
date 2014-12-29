netxms-puppet
=============
This is a Puppet module for NetXMS.<br>
Please note this module is fairly basic, and was tested only on Ubuntu Server 12.04.

#### TL;DR documentation
If you want to install just the Agent on a node:
```puppet
node 'foo.bar.local' {
  # add netxms apt sources
  class { 'apt::netxms_repo': }

  # install netxms agent
  class { 'netxms::agent':
    nxagentd_masters    => 'netxms.server.local',
    nxagentd_access_pwd => 'nxagentSharedSecret',
  }
}
```
If you want to install both Agent and Server on a node:
```puppet
node 'netxms.server.local' {
  # add netxms apt sources
  class { 'apt::netxms_repo': }

  # install netxms agent
  class { 'netxms::agent':
    nxagentd_masters    => '127.0.0.1, netxms.server.local',
    nxagentd_access_pwd => 'nxagentSharedSecret',
  }

  # install netxms server
  class { 'netxms::server':
    netxmsd_db_drv   => 'mysql',
    netxmsd_db_srv   => 'mysql.server.local',
    netxmsd_db_name  => 'netxms_db',
    netxmsd_db_login => 'netxms',
    netxmsd_db_pwd   => 'netxms',
  }
}
```
#### Full documentation
