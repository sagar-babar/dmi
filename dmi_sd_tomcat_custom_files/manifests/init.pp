class dmi_sd_tomcat_custom_files(

		$deployment = $deployment,
		$hard_ulimit = $hard_ulimit,
		$soft_ulimit = $soft_ulimit,
		$executor_max_threads = $executor_max_threads,
		$executor_minSpareThreads = $executor_minSpareThreads,
		$connector_max_threads = $connector_max_threads,
		$connector_acceptCount = $connector_acceptCount,
		$max_perm_size = $max_perm_size,
		$min_heap_size = $min_heap_size,
		$max_heap_size = $max_heap_size,
)

{

	file { '/usr/share/tomcat7/conf/logging.properties':
		content => template('dmi_sd_tomcat_custom_files/logging.properties.erb'),
		mode => '0644',
		owner => 'ec2-user',
		group => 'ec2-user',
	}

	file { '/usr/share/tomcat7/conf/server.xml':
		content => template('dmi_sd_tomcat_custom_files/server.xml.erb'),
		mode => '0644',
		owner => 'ec2-user',
		group => 'ec2-user',
	}

	file { '/usr/share/tomcat7/bin/catalina.sh':
		content => template('dmi_sd_tomcat_custom_files/catalina.sh.erb'),
		mode => '0755',
		owner => 'root',
		group => 'root',
	}

	file { '/usr/share/tomcat7/bin/setenv.sh':
		content => template('dmi_sd_tomcat_custom_files/setenv.sh.erb'),
		mode => '0755',
		owner => 'ec2-user',
		group => 'ec2-user',
	}

	file { '/usr/share/tomcat7/bin/tomcat-service-wrapper.sh':
		content => template('dmi_sd_tomcat_custom_files/tomcat-service-wrapper.sh.erb'),
		mode => '0755',
		owner => 'ec2-user',
		group => 'ec2-user',
	}

}

