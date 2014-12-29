class netxms::agent (
	$ensure = 'installed',
	$nxagentd_masters,
	$nxagentd_access_pwd,
	$nxagentd_logfile = '/var/log/nxagentd.log',
	$nxagentd_proxy_agent = 'no',
	$nxagentd_proxy_snmp = 'no',
	$repo_class = 'apt::netxms_repo',
)
{
	# install packages
	package { 'netxms-base':
		require			=> Class["$repo_class"],
		ensure			=> $ensure,
		install_options	=> '--force-yes',
	}
	
	package { 'netxms-agent':
		require			=> Package['netxms-base'],
		ensure			=> $ensure,
		install_options	=> '--force-yes',
	}
	
	# config files
	file { '/etc/nxagentd.conf':
		require	=> Package['netxms-agent'],
		content	=> template('netxms/nxagentd.conf.erb'),
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0644',
		notify	=> Service['nxagentd'],
	}
	
	# services
	service { 'nxagentd':
		require	=> File['/etc/nxagentd.conf'],
		ensure	=> 'running',
	}
}
