class dmi_sd_nginx(

       	$monitoring_domain = $monitoring_domain,
       	$upstream_services = $upstream_services,
       	$name_server = $name_server,
       	$upstream_servers = $upstream_servers,
        $sd_services = $sd_services,
)

{
        exec { "Creating dhparam.pem":
                command => "openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048; chmod 400 /etc/ssl/certs/dhparam.pem",
                path => "/usr/local/bin/:/bin/:/usr/bin/",
                unless => "/usr/bin/test -f /etc/ssl/certs/dhparam.pem",
        }


        file { '/usr/local/nginx/conf/nginx.conf':
                content => template('dmi_sd_nginx/nginx.conf.erb'),
                owner   => root,
                group   => root,
                mode    => '0644',
        }


$mainconfigs = ["common-endpoints.conf", "api-lb", "services.conf"]
$mainconfigs.each |String $mainconfig| {

       	file { "/usr/local/nginx/conf/dmi/{configfile}":
       		content => template("dmi_sd_nginx/${commonconfig}-.erb"),
       		owner   => root,
       		group   => root,
       		mode    => '0644',
       	}

}

$commonconfigs = ["file-cache.conf", "gzip.conf", "rate-limit-zones.conf", "ssl.conf", "tcp-opt.conf", "proxy.conf" ]
$commonconfigs.each |String $commonconfig| {

        file { "/usr/local/nginx/conf/dmi/common/${commonconfig}":
                content => template("dmi_sd_nginx/${commonconfig}"-.erb"),
                owner   => root,
                group   => root,
                mode    => '0644',
        }
}

$upstreamconfigs = ["analytics-servers.conf", "bid-agent-servers.conf", "portal-be-servers.conf"]
$upstreamconfigs.each |String $upstreamconfig| {

        file { "/usr/local/nginx/conf/dmi/upstream/${upstreamconfig}":
                content => template("dmi_sd_nginx/${upstreamconfig}"-.erb"),
                owner   => root,
                group   => root,
                mode    => '0644',
        }
}
$serviceconfigs = ["analytics-servers.conf", "bid-agent-servers.conf", "portal-be-servers.conf"]
$serviceconfigs.each |String $serviceconfig| {

        file { "/usr/local/nginx/conf/dmi/services/${serviceconfig}":
                content => template("dmi_sd_nginx/${serviceconfig}"-.erb"),
                owner   => root,
                group   => root,
                mode    => '0644',
        }
}
}
