class netxms::server (
  $ensure                 = 'installed',
  $netxmsd_db_drv,
  $netxmsd_db_srv,
  $netxmsd_db_name,
  $netxmsd_db_login,
  $netxmsd_db_pwd,
  $netxmsd_log_failed_sql = 'yes',
  $netxmsd_logfile        = '/var/log/netxmsd',
  $f_owner                = 'root',
  $f_group                = 'root',
  $f_mode                 = '0600',
)
{
  # check if $netxmsd_db_drv specified correctly
  if ($netxmsd_db_drv != 'mysql' and $netxmsd_db_drv != 'odbc' and $netxmsd_db_drv != 'oracle' and $netxmsd_db_drv != 'pgsql' and $netxmsd_db_drv != 'sqlite3') {
    fail('Error: $netxmsd_db_drv invalid! Supported options: [\'mysql\', \'odbc\', \'oracle\', \'pgsql\', \'sqlite3\']')
  }

  # install DB drivers
  package { "netxms-dbdrv-${netxmsd_db_drv}":
    require         => Class['netxms::agent'],
    ensure          => $ensure,
    notify          => Service['netxmsd'],
  }

  # install server
  package { 'netxms-server':
    require         => Package["netxms-dbdrv-${netxmsd_db_drv}"],
    ensure          => $ensure,
  }

  # config file
  file { '/etc/netxmsd.conf':
    require => Package['netxms-server'],
    content => template('netxms/netxmsd.conf.erb'),
    owner   => $f_owner,
    group   => $f_group,
    mode    => $f_mode,
    notify  => Service['netxmsd'],
  }

  # service
  service { 'netxmsd':
    require => Service['nxagentd'],
    ensure  => 'running',
  }
}
