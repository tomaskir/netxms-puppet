class netxms::agent (
  $ensure               = 'installed',
  $nxagentd_masters,
  $nxagentd_access_pwd,
  $nxagentd_logfile     = '/var/log/nxagentd',
  $nxagentd_proxy_agent = 'no',
  $nxagentd_proxy_snmp  = 'no',
  $nxagentd_file_store  = '/var/nxagentd',
  $f_owner              = 'root',
  $f_group              = 'root',
  $f_mode               = '0600',
  $d_mode               = '0700',
  $repo_class           = 'apt::netxms_repo',
)
{
  if ($nxagentd_masters == '' or $nxagentd_access_pwd == '') {
    alert('Alert: netxms::agent class was declared, but some attributes were passed to it as empty strings.')
  }

  # install packages
  package { 'netxms-base':
    require         => Class[$repo_class],
    ensure          => $ensure,
  }

  package { 'netxms-agent':
    require         => Package['netxms-base'],
    ensure          => $ensure,
  }

  # config file
  file { '/etc/nxagentd.conf':
    require => Package['netxms-agent'],
    content => template('netxms/nxagentd.conf.erb'),
    owner   => $f_owner,
    group   => $f_group,
    mode    => $f_mode,
    notify  => Service['nxagentd'],
  }

  # FileStore directory
  file { $nxagentd_file_store:
    require => Package['netxms-agent'],
    ensure  => 'directory',
    owner   => $f_owner,
    group   => $f_group,
    mode    => $d_mode,
    notify  => Service['nxagentd'],
  }

  # service
  service { 'nxagentd':
    ensure => 'running',
  }
}
