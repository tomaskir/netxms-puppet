class netxms::server (
	$ensure = 'installed',
	$netxmsd_db_drv,
	$netxmsd_db_srv,
	$netxmsd_db_name,
	$netxmsd_db_login,
	$netxmsd_db_pwd,
	$netxmsd_log_failed_sql = 'yes',
	$netxmsd_logfile = '/var/log/netxmsd.log',
)
{
	# check if $netxmsd_db_drv specified correctly
	if ($netxmsd_db_drv != 'mysql' and $netxmsd_db_drv != 'odbc' and $netxmsd_db_drv != 'oracle' and $netxmsd_db_drv != 'pgsql' and $netxmsd_db_drv != 'sqlite') {
		fail('Error: $netxmsd_db_drv invalid! Supported options: [\'mysql\', \'odbc\', \'oracle\', \'pgsql\', \'sqlite\']')
	}

	# install packages
	package { 'netxms-server':
		require			=> Class['netxms::agent'],
		ensure			=> $ensure,
		install_options	=> '--force-yes',
	}
	
	# install additional DB drivers if required
	if ($netxmsd_db_drv != 'sqlite') {
		package { "netxms-server-${netxmsd_db_drv}":
			require			=> Package['netxms-server'],
			ensure			=> $ensure,
			install_options	=> '--force-yes',
			notify			=> Service['netxmsd'],
		}
	}
	
	# config file
	file { '/etc/netxmsd.conf':
		require	=> Package["netxms-server"],
		content	=> template('netxms/netxmsd.conf.erb'),
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0644',
		notify	=> Service['netxmsd'],
	}
	
	# services
	service { 'netxmsd':
		require	=> Service['nxagentd'],
		ensure	=> 'running',
	}
}
