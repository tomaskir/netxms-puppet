netxms-puppet
=============
This is a Puppet module for NetXMS.<br>
Please note this module was tested only on Ubuntu Server 14.04.

#### TL;DR documentation
If you want to install just the Agent on a node:
```puppet
node 'foo.bar.local' {
  # add netxms apt repo
  class { 'apt::netxms_repo':
  }

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
  class { 'apt::netxms_repo':
  }

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
##### Modules
1) 'apt' module - 'apt::netxms_repo' class<br>
----This class adds the NetXMS Aptitude repo into /etc/apt/sources.list.d/netxms.list

2) 'netxms' module - 'netxms::agent' and 'netxms::server' classes<br>
----These classes actually install and configure NetXMS components

Both modules should be places in your .../modules/ directory.

##### Dependency chain
Class['apt::netxms_repo'] -> Class['netxms::agent'] -> Class['netxms::server']

##### Class attributes:
```puppet
class { 'apt::netxms_repo':
  release => 'beta',  # optional - defaults to 'main' - chooses which netxms apt repo to use
}
```
```puppet
class { 'netxms::agent':
  ensure               => 'installed',              # optional - defaults to 'installed'
  nxagentd_masters     => 'netxms.server.local',    # required - list of masters, if installed on server, dont forget '127.0.0.1, netxms.server.local'
  nxagentd_access_pwd  => 'nxagentSharedSecret',    # required - agent access secret
  nxagentd_logfile     => '/var/log/nxagentd',      # optional - defaults to '/var/log/nxagentd.log'
  nxagentd_proxy_agent => 'no',                     # optional - defaults to 'no'
  nxagentd_proxy_snmp  => 'no',                     # optional - defaults to 'no'
  nxagentd_file_store  => '/var/nxagentd',          # optional - defaults to '/var/nxagentd' - this is the location of the nxagentd FileStore
  f_owner              => 'root',                   # optional - defaults to 'root' - set owner of the config file and FileStore
  f_group              => 'root',                   # optional - defaults to 'root' - set group of the config file and FileStore
  f_mode               => '0600',                   # optional - defaults to '0600' - set security of the config file
  d_mode               => '0700',                   # optional - defaults to '0700' - set security of the FileStore
  repo_class           => 'apt::netxms_repo',       # optional - defaults to 'apt::netxms_repo' - can be used to set which class defines the repo for netxms packages
}
```
```puppet
class { 'netxms::server':
  ensure                 => 'installed',            # optional - defaults to 'installed'
  netxmsd_db_drv         => 'mysql',                # required - one of ['mysql', 'odbc', 'oracle', 'pgsql', 'sqlite3']
  netxmsd_db_srv         => 'mysql.server.local',   # required - db server ip/fqdn
  netxmsd_db_name        => 'netxms_db',            # required - db name
  netxmsd_db_login       => 'netxms',               # required - db login
  netxmsd_db_pwd         => 'netxms',               # required - db password
  netxmsd_log_failed_sql => 'yes',                  # optional, defaults to 'yes'
  netxmsd_logfile        => '/var/log/netxmsd',     # optional, defaults to '/var/log/netxmsd.log'
  f_owner                => 'root',                 # optional - defaults to 'root' - set owner of the config file
  f_group                => 'root',                 # optional - defaults to 'root' - set group of the config file
  f_mode                 => '0600',                 # optional - defaults to '0600' - set security of the config file
}
```

##### Notes:
1) Please note that deploying NetXMS Server using Puppet doesnt initialize the DB.<br>
----You still have to manually run "nxdbmng init".<br>

#### Final words:
If you find any issues with this module, or have any feedback, please let me know!
