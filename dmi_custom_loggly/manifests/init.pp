class dmi_sd_loggly(
                  $customer = $customer,
)
{
  file {'/home/ec2-user/cloudmi/loggly':
    ensure => directory,
  }
  file {'/home/ec2-user/cloudmi/loggly/modules':
    ensure     => directory,
    #force      => true,
    owner      => 'ec2-user',
    group      => 'ec2-user',
    mode       => '0775'
    require    => File['/home/ec2-user/cloudmi/loggly'],
  }
  file { '/home/ec2-user/cloudmi/loggly/td-agent.conf':
		content     => template('dmi_sd_loggly/td-agent.conf.erb'),
		mode        => '0644',
		owner       => 'ec2-user',
		group       => 'ec2-user',
    require     => File['/home/ec2-user/cloudmi/loggly/modules'],
	}

	file { '/home/ec2-user/cloudmi/loggly/modules/haproxy.conf':
		content     => template('dmi_sd_loggly/haproxy.conf.erb'),
		mode        => '0644',
		owner       => 'ec2-user',
		group       => 'ec2-user',
    require     => File['/home/ec2-user/cloudmi/loggly/modules'],
	}

	file { '/home/ec2-user/cloudmi/loggly/modules/emitter.conf':
		content     => template('dmi_sd_loggly/emitter.conf.erb'),
		mode        => '0644',
		owner       => 'ec2-user',
		group       => 'ec2-user',
    require     => File['/home/ec2-user/cloudmi/loggly/modules'],
	}

	file { '/home/ec2-user/cloudmi/loggly/modules/nginx-clb.conf':
		content     => template('dmi_sd_loggly/nginx-clb.conf.erb'),
		mode        => '0644',
		owner       => 'ec2-user',
		group       => 'ec2-user',
    require     => File['/home/ec2-user/cloudmi/loggly/modules'],
	}

	file { '/home/ec2-user/cloudmi/loggly/modules/pending.conf':
		content     => template('dmi_sd_loggly/pending.conf.erb'),
		mode        => '0644',
		owner       => 'ec2-user',
		group       => 'ec2-user',
    require     => File['/home/ec2-user/cloudmi/loggly/modules'],
	}

	file { '/home/ec2-user/cloudmi/loggly/modules/test.conf':
		content     => template('dmi_sd_loggly/test.conf.erb'),
		mode        => '0644',
		owner       => 'ec2-user',
		group       => 'ec2-user',
    require     => File['/home/ec2-user/cloudmi/loggly/modules'],
	}

	file { '/home/ec2-user/cloudmi/loggly/modules/dls.conf':
		content     => template('dmi_sd_loggly/dls.conf.erb'),
		mode        => '0644',
		owner       => 'ec2-user',
		group       => 'ec2-user',
    require     => File['/home/ec2-user/cloudmi/loggly/modules'],
	}

  class { 'supervisord':
                        install_pip => true,
                        log_path => "/logs/supervisord",
                        log_file => "supervisord.log",
                        logfile_maxbytes => 20,
                        logfile_backups => 10,
                        loglevel => info,
        }
  file { 'supervisord_symlink':
    path          => '/usr/local/bin/supervisord',
    ensure        => 'link',
    #  force         => true,
    target        => '/usr/bin/supervisord',
  }
  file { 'supervisorctl_symlink':
    path          => '/usr/local/bin/supervisorctl',
    ensure        => 'link',
    #  force         => true,
    target        => '/usr/bin/supervisorctl',
  }

  supervisord::program { 'loggly':
    command         => '/opt/td-agent/embedded/bin/ruby /usr/sbin/td-agent -c /home/ec2-user/cloudmi/loggly/td-agent.conf --group ec2-user --log /logs/td-agent/td-agent-loggly.log',
    directory       => '/home/ec2-user',
    autostart       => true,
    autorestart     => true,
    startsecs       => '10',
    startretries    => '50',
    exitcodes       => '0',
    stopsignal      => 'INT',
    stopwaitsecs    => '30',
    stopasgroup     => true,
    killasgroup     => true,
    user            => 'root',
    redirect_stderr => false,
    stdout_logfile  => '/logs/loggly-service-out.log',
    stderr_logfile  => '/logs/loggly-service-err.log',
    require         => File['/home/ec2-user/cloudmi/loggly/td-agent.conf'],
  }
}
