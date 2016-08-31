class dmi_datadog(

		$deployment = $deployment,
		$server_type = $server_type,
		$region = $region,
		$server_index = $server_index,
		$kafka_instance = $kafka_instance,
		$redis_passphrase = $redis_passphrase,
		$zoo_instance = $zoo_instance,
		$role = $role,
		$service = $service,
		$replSetName = $replSetName,

)

{

	exec { "Creating symlink for /var/log/datadog":
		command => "ln -s /logs/datadog /var/log/datadog",
		path => "/usr/local/bin/:/bin/:/usr/bin/",
		unless => "/usr/bin/test -L /var/log/datadog"
	}

	exec { "Creating logs-td-agent directories":
		command => "mkdir /logs/td-agent /logs/devops /home/ec2-user/.devops; chown -R ec2-user:ec2-user /logs/td-agent /logs/devops;chown -R ec2-user:ec2-user /home/ec2-user",
		path => "/usr/local/bin/:/bin/:/usr/bin/",
		unless => "/usr/bin/test -d /logs/td-agent"
	}

	exec { "Creating supervisord puppet and datadog directories":
		command => "mkdir /logs/supervisord /logs/datadog /logs/puppet; chmod -R 755 /logs/supervisord",
		path => "/usr/local/bin/:/bin/:/usr/bin/",
		unless => "/usr/bin/test -d /logs/datadog"
	}

	file { '/etc/dd-agent/datadog.conf':
		content => template('dmi_datadog/datadog.conf.erb'),
		mode => '0640',
		owner => 'dd-agent',
		group => 'root',
	}

	file { '/etc/dd-agent/supervisor.conf':
		content => template('dmi_datadog/supervisor.conf.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}

	file { '/etc/dd-agent/conf.d/supervisord.yaml':
		content => template('dmi_datadog/supervisord.yaml.erb'),
		mode => '0640',
		owner => 'dd-agent',
		group => 'root',
	}

	file { '/etc/dd-agent/conf.d/disk.yaml':
		content => template('dmi_datadog/disk.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}

	file { '/etc/dd-agent/conf.d/network.yaml':
		content => template('dmi_datadog/network.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}

	file { '/etc/dd-agent/conf.d/ntp.yaml':
		content => template('dmi_datadog/ntp.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}

	file { '/etc/dd-agent/conf.d/dmi-devops.yaml':
		content => template('dmi_datadog/dmi-devops.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}

	file { '/etc/dd-agent/checks.d/dmi-devops.py':
		content => template('dmi_datadog/dmi-devops.py.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}

if $server_type == 'uram' {

	file { '/etc/dd-agent/conf.d/process.yaml':
		content => template('dmi_datadog/process-uram.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}

}

elsif $server_type == 'gdisc' {

	file { '/etc/dd-agent/conf.d/process.yaml':
		content => template('dmi_datadog/process-discovery.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}

}

else {

		file { '/etc/dd-agent/conf.d/process.yaml':
		content => template('dmi_datadog/process.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',

	}

}

if $server_type == 'sni' {

		file { '/etc/dd-agent/conf.d/redisdb.yaml':
		content => template('dmi_datadog/redisdb.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}

	file { '/etc/dd-agent/conf.d/nginx.yaml':
		content => template('dmi_datadog/nginx.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}

	file { '/etc/dd-agent/conf.d/fluentd.yaml':
		content => template('dmi_datadog/fluentd.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}

}

if $server_type == 'login' {

	file { '/etc/dd-agent/conf.d/fluentd.yaml':
		content => template('dmi_datadog/fluentd.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}
}

if $server_type == 'logetl' {

	file { '/etc/dd-agent/conf.d/fluentd.yaml':
		content => template('dmi_datadog/fluentd.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}
}

if $server_type == 'dnsisp' {

		file { '/etc/dd-agent/conf.d/redisdb.yaml':
		content => template('dmi_datadog/redisdb.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}
}

if $server_type == 'nginx' {

	file { '/etc/dd-agent/conf.d/nginx.yaml':
		content => template('dmi_datadog/nginx.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}
}

if $server_type == 'gnginx' {

	file { '/etc/dd-agent/conf.d/nginx.yaml':
		content => template('dmi_datadog/nginx.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}
}

if $server_type == 'omsportal' {

	file { '/etc/dd-agent/conf.d/nginx.yaml':
		content => template('dmi_datadog/portal-nginx.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}
}

if $server_type == 'tomcat' {

	file { '/etc/dd-agent/conf.d/tomcat.yaml':
		content => template('dmi_datadog/tomcat.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}

	file { '/etc/dd-agent/conf.d/fluentd.yaml':
		content => template('dmi_datadog/fluentd.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}
}

if $server_type == 'authidredis' {

	file { '/etc/dd-agent/conf.d/redisdb.yaml':
		content => template('dmi_datadog/redisdb.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}
}

if $server_type == 'gdiscredis' {

	file { '/etc/dd-agent/conf.d/redisdb.yaml':
		content => template('dmi_datadog/redisdb.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}
}

if $server_type == 'gisp' {

	file { '/etc/dd-agent/conf.d/redisdb.yaml':
		content => template('dmi_datadog/redisdb.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}
}

if $server_type == 'dasdb' {

	file { '/etc/dd-agent/conf.d/mongo.yaml':
		content => template('dmi_datadog/mongo.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}
}

if $server_type == 'authiddb' {

	file { '/etc/dd-agent/conf.d/mongo.yaml':
		content => template('dmi_datadog/mongo.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}
}

if $server_type == 'zk' {

	file { '/etc/dd-agent/conf.d/zk.yaml':
		content => template('dmi_datadog/zk.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}
}

if $server_type == 'kafka' {

	file { '/etc/dd-agent/conf.d/kafka.yaml':
		content => template('dmi_datadog/kafka.yaml.erb'),
		mode => '0644',
		owner => 'dd-agent',
		group => 'root',
	}
}

}
