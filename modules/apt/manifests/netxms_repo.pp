class apt::netxms_repo (
	$release = 'main',
)
{
	file { '/etc/apt/sources.list.d/netxms.list':
		content	=> template('apt/netxms.list.erb'),
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0644',
		notify	=> Exec['netxms - add repo key']
	}
	
	exec { 'netxms - add repo key':
		refreshonly	=> true,
		command		=> "/usr/bin/wget -q -O - http://packages.netxms.org/netxms.gpg | sudo apt-key add -",
		notify		=> Exec['netxms - apt-get update']
	}
	
	exec { 'netxms - apt-get update':
		refreshonly	=> true,
		command		=> "/usr/bin/apt-get update",
	}
}
