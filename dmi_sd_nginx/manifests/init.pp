class dmi_sd_nginx(

       	$monitoring_domain = $monitoring_domain,
       	$upstream_services = $upstream_services,
       	$name_server = $name_server,

       	$portal_operators = $portal_operators,
       	$dns_operators = $dns_operators,
       	$sd_services = $sd_services,
       	$upstream_servers = $upstream_servers,
       	$customers = $customers,

       	$customer1 = $customer1,
       	$customer2 = $customer2,
       	$multiple_portal_accounts = $multiple_portal_accounts,
       	$multiple_dns_accounts = $multiple_dns_accounts,
       	$multiple_isp_accounts = $multiple_isp_accounts,

        $disallow_aacmi_auth = $disallow_aacmi_auth,
        $is_uram = $is_uram,
        $is_kibana = $is_kibana,

       	$aacmi_tomcat_servers = $aacmi_tomcat_servers,
       	$aacmi_auth_tomcat_servers = $aacmi_auth_tomcat_servers,
       	$das_tomcat_servers = $das_tomcat_servers,
       	$isp_servers = $isp_servers,
        $dns_servers = $dns_servers,
        $tomcat_servers = $tomcat_servers,
        $kibana_servers = $kibana_servers,
        $uram_servers = $uram_servers,
       	$portal_servers = $portal_servers,
        $customer1_portal_servers = $customer1_portal_servers,
       	$customer2_portal_servers = $customer2_portal_servers,
       	$customer1_dns_servers = $customer1_dns_servers,
       	$customer2_dns_servers = $customer2_dns_servers,
       	$customer1_isp_servers = $customer1_isp_servers,
       	$customer2_isp_servers = $customer2_isp_servers

)

{
        exec { "Creating dhparam.pem":
                command => "openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048; chmod 400 /etc/ssl/certs/dhparam.pem",
                path => "/usr/local/bin/:/bin/:/usr/bin/",
                unless => "/usr/bin/test -f /etc/ssl/certs/dhparam.pem",
        }

        file { '/usr/local/nginx/conf/nginx.conf':
                content => template('dmi_sd_nginx/nginx.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

       	file { '/usr/local/nginx/conf/dmi/common-endpoints.conf':
       		content => template('dmi_sd_nginx/common-endpoints.conf.erb'),
       		owner   => ec2-user,
       		group   => ec2-user,
       		mode    => '0644',
       	}

       	file { '/usr/local/nginx/conf/dmi/api-lb.conf':
       		content => template('dmi_sd_nginx/api-lb.conf.erb'),
       		owner   => ec2-user,
       		group   => ec2-user,
       		mode    => '0644',
       	}

        file { '/usr/local/nginx/conf/dmi/services.conf':
                content => template('dmi_sd_nginx/services.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

if $multiple_isp_accounts == 'true' {

        file { '/usr/local/nginx/conf/dmi/upstream/isp-servers.conf':
                content => template('dmi_sd_nginx/multi-isp-servers.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }
}
else {

        file { '/usr/local/nginx/conf/dmi/upstream/isp-servers.conf':
                content => template('dmi_sd_nginx/isp-servers.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }
}

if $multiple_dns_accounts == 'true' {

        file { '/usr/local/nginx/conf/dmi/upstream/dns-servers.conf':
                content => template('dmi_sd_nginx/multi-dns-servers.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }
}
else {

        file { '/usr/local/nginx/conf/dmi/upstream/dns-servers.conf':
                content => template('dmi_sd_nginx/dns-servers.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }
}

        file { '/usr/local/nginx/conf/dmi/upstream/das-servers.conf':
                content => template('dmi_sd_nginx/das-servers.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

        file { '/usr/local/nginx/conf/dmi/upstream/aacmi-servers.conf':
                content => template('dmi_sd_nginx/aacmi-servers.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

if $is_kibana == 'true' {

        file { '/usr/local/nginx/conf/dmi/upstream/kibana-servers.conf':
                content => template('dmi_sd_nginx/kibana-servers.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

        file { '/usr/local/nginx/conf/dmi/services/kibana.conf':
                content => template('dmi_sd_nginx/kibana.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

}

if $is_uram == 'true' {

        file { '/usr/local/nginx/conf/dmi/upstream/uram-servers.conf':
                content => template('dmi_sd_nginx/uram-servers.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

        file { '/usr/local/nginx/conf/dmi/services/uram.conf':
                content => template('dmi_sd_nginx/uram.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

}

if $multiple_portal_accounts == 'true' {

        file { '/usr/local/nginx/conf/dmi/upstream/oms-servers.conf':
                content => template('dmi_sd_nginx/multi-oms-servers.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }
}
else {

       	file { '/usr/local/nginx/conf/dmi/upstream/oms-servers.conf':
                content => template('dmi_sd_nginx/oms-servers.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }
}

if $disallow_aacmi_auth == 'true' {

        file { '/usr/local/nginx/conf/dmi/services/aacmi.conf':
                content => template('dmi_sd_nginx/disallow_auth_traffic_aacmi.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }
}
else {

        file { '/usr/local/nginx/conf/dmi/services/aacmi.conf':
                content => template('dmi_sd_nginx/aacmi.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }
}

        file { '/usr/local/nginx/conf/dmi/services/das.conf':
                content => template('dmi_sd_nginx/das.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

        file { '/usr/local/nginx/conf/dmi/services/isp.conf':
                content => template('dmi_sd_nginx/isp.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

        file { '/usr/local/nginx/conf/dmi/services/dns.conf':
                content => template('dmi_sd_nginx/dns.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

        file { '/usr/local/nginx/conf/dmi/services/oms.conf':
                content => template('dmi_sd_nginx/oms.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

        file { '/usr/local/nginx/conf/dmi/common/file-cache.conf':
                content => template('dmi_sd_nginx/file-cache.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

      file { '/usr/local/nginx/conf/dmi/common/gzip.conf':
       		content => template('dmi_sd_nginx/gzip.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

        file { '/usr/local/nginx/conf/dmi/common/rate-limit-zones.conf':
       		content => template('dmi_sd_nginx/rate-limit-zones.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

        file { '/usr/local/nginx/conf/dmi/common/ssl.conf':
       		content => template('dmi_sd_nginx/ssl.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

        file { '/usr/local/nginx/conf/dmi/common/tcp-opt.conf':
       		content => template('dmi_sd_nginx/tcp-opt.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }

        file { '/usr/local/nginx/conf/dmi/common/proxy.conf':
       		content => template('dmi_sd_nginx/proxy.conf.erb'),
                owner   => ec2-user,
                group   => ec2-user,
                mode    => '0644',
        }
}
