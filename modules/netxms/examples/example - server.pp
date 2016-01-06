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
