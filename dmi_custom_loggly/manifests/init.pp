class dmi_sd_loggly(
                  $customer = $customer,
                  $mainconfigs = ["haproxy.conf", "emitter.conf", "nginx-clb.conf", "pending.conf", "test.conf", "dls.conf"],
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
  $mainconfigs.each |String $configfile| {
  file { "/home/ec2-user/cloudmi/loggly/modules/${configfile}":
    content => template("dmi_sd_loggly/${configfile}.erb"),
    owner   => ec2-user,
    group   => ec2-user,
    mode    => '0644',
    require => File['/home/ec2-user/cloudmi/loggly/modules'],
  }
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
