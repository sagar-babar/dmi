node 'nginx1a1.tbr-cm.datami.com'	{

	class { 'dmi_datadog':
            deployment => 'tbr',
            server_type => 'nginx',
            region => 'saopaulo',
            server_index => '1a1',
            role => 'load-balancer',
            service => 'nginx',
    }

	class { 'supervisord':
			install_pip => true,
			log_path => "/logs/supervisord",
			log_file => "supervisord.log",
			logfile_maxbytes => 20,
			logfile_backups => 10,
			loglevel => info,
	}

	exec { "supervisord_symlink":
			command => "ln -s /usr/local/bin/supervisord /usr/bin/supervisord",
			path	=> "/usr/local/bin/:/bin/:/usr/bin/",
			unless	=> "/usr/bin/test -f /usr/bin/supervisord"
	}

	exec { "supervisorctl_symlink":
			command => "ln -s /usr/local/bin/supervisorctl /usr/bin/supervisorctl",
			path	=> "/usr/local/bin/:/bin/:/usr/bin/",
			unless => "/usr/bin/test -f /usr/bin/supervisorctl"
	}

	supervisord::program { 'nginx':
		command  => '/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf',
		directory => '/usr/local/nginx',
		autostart => true,
		autorestart => true,
		startsecs => '10',
		startretries => '50',
		exitcodes => '0',
		stopsignal => 'INT',
		stopwaitsecs => '60',
		stopasgroup => false,
		killasgroup => false,
		user => 'root',
		redirect_stderr => false,
		stdout_logfile => '/logs/nginx-service-out.log',
		stderr_logfile => '/logs/nginx-service-err.log'
	}

/*	supervisord::program { 'loggly':
		command  => '/opt/td-agent/embedded/bin/ruby /usr/sbin/td-agent -c /home/ec2-user/cloudmi/loggly/td-agent.conf --group ec2-user --log /logs/td-agent/td-agent-loggly.log',
		directory => '/home/ec2-user',
		autostart => true,
		autorestart => true,
		startsecs => '10',
		startretries => '50',
		exitcodes => '0',
		stopsignal => 'INT',
		stopwaitsecs => '30',
		stopasgroup => true,
		killasgroup => true,
		user => 'root',
		redirect_stderr => false,
		stdout_logfile => '/logs/loggly-service-out.log',
		stderr_logfile => '/logs/loggly-service-err.log'
	}
*/
	include nginxdotfiles
	#include nginx
	include dmi_sd_logrotate
	include dmi_sd_third_party_repos
	include dmi_enable_puppetagent
	include dmi_os_perf_tools

	class { 'dmi_sd_loggly':
            customer => 'tbr',
    }

        class { 'dmi_sd_nginx':

                        monitoring_domain => 'local-monitoring.internal.datami.com',
                        name_server => '10.8.0.2',
                        #upstream_servers => ['aacmi', 'isp', 'dns', 'das', 'kibana', 'uram', 'oms'],
                        upstream_servers => ['aacmi', 'isp', 'dns', 'das', 'oms'],
                        #sd_services => ['aacmi', 'isp', 'dns', 'das', 'kibana', 'uram', 'oms'],
                        sd_services => ['aacmi', 'isp', 'dns', 'das', 'oms'],
                        portal_operators => ['tbr'],
                        #disallow_aacmi_auth => 'true',
                        aacmi_auth_tomcat_servers => ['10.8.51.20','10.8.61.20'],
                        aacmi_tomcat_servers => ['10.8.51.23','10.8.61.23'],
                        das_tomcat_servers => ['10.8.51.21','10.8.61.21'],
                        #is_kibana => true,
                        #kibana_servers => ['10.8.51.60'],
                        #is_uram => true,
                        #uram_servers => ['10.8.51.30','10.8.61.30'],
                        portal_servers => ['10.8.51.10','10.8.61.10'],
                        dns_servers => ['10.8.0.40','10.8.1.40','10.8.0.41','10.8.1.41'],
                        isp_servers => ['10.8.0.40','10.8.1.40','10.8.0.41','10.8.1.41'],
                }

}
