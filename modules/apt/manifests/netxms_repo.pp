class apt::netxms_repo {
	file { '/etc/apt/sources.list.d/netxms.list':
		source	=> 'puppet:///modules/apt/netxms.list',
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0644',
		notify	=> Exec['netxms - apt-get update']
	}
	
	exec { 'netxms - apt-get update':
		refreshonly	=> true,
		command		=> "/usr/bin/apt-get update",
	}
}
