class apt::netxms_repo (
  $release = 'main',
)
{
  $os_name = $lsbdistid ? {
    'Ubuntu' => 'ubuntu',
    'Debian' => 'debian',
    default  => undef,
  }

  if $os_name == undef {
    fail('Unsupported OS - this module currently only supports Debian and Ubuntu!')
  }

  $os_dist = $lsbdistcodename ? {
    'trusty'  => 'trusty',
    'jessie'  => 'jessie',
    'lenny'   => 'lenny',
    'squeeze' => 'squeeze',
    default   => 'wheezy',
  }

  file { '/etc/apt/sources.list.d/netxms.list':
    content => template('apt/netxms.list.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Exec['netxms - add apt repo key']
  }

  exec { 'netxms - add apt repo key':
    require     => File['/etc/apt/sources.list.d/netxms.list'],
    command     => '/usr/bin/curl http://packages.netxms.org/netxms.gpg | /usr/bin/apt-key add -',
    refreshonly => true,
    notify      => Exec['netxms - apt-get update']
  }

  exec { 'netxms - apt-get update':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
  }
}
