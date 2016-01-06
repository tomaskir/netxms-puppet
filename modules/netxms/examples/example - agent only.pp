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
