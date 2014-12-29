class apt::netxms_repo {
	file { '/etc/apt/sources.list.d/netxms.list':
		source	=> 'puppet:///modules/apt/netxms.list',
		mode	=> '0644',
	}
}
