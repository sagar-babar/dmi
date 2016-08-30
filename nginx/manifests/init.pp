class nginx{
	file {'/root/modules':
		ensure 		=> 'directory',
		owner 		=> 'root',
		mode 		=> '0775',
	}->
	file {'/logs/nginx':
		ensure 		=> 'directory',
		owner 		=> 'root',
		mode 		=> '0775',
	}->
$binaries = ["echo-nginx-module-0.58.tar.gz", "headers-more-nginx-module-0.261.tar.gz", "ngx_devel_kit-master.zip", "ngx_http_redis-0.3.7.tar.gz", "ngx_http_substitutions_filter_module-0.6.4.zip", "redis2-nginx-module-0.12.zip", "set-misc-nginx-module-0.29.zip", "zlib-1.2.8.tar.gz", "nginx-1.8.0.tar.gz", ""]

$binaries.each |String $binary| {
file {"/root/modules/$binary":
  ensure => file,
  source => "puppet:///modules/profile/${docs_filename}",
}->
archive { "/root/modules/$binary":
  path          => $docs_gz_path,
  extract       => true,
  extract_path  => '/root/modules',
  require       => [ File["/root/modules/$binary"] ],
}
	exec { "Configuring nginx module from source":
		command => "sh /root/modules/nginx-1.8.0/configure --with-http_gunzip_module --with-http_secure_link_module --with-http_ssl_module --with-http_sub_module --with-zlib=/root/modules/zlib-1.2.8 --with-debug --add-module=/root/modules/ngx_devel_kit-master --add-module=/root/modules/headers-more-nginx-module-0.261 --add-module=/root/modules/ngx_http_redis-0.3.7 --add-module=/root/modules/redis2-nginx-module-0.12 --add-module=/root/modules/ngx_http_substitutions_filter_module-0.6.4 --add-module=/root/modules/set-misc-nginx-module-0.29 --add-module=/root/modules/echo-nginx-module-0.58 --with-http_stub_status_module; make -j2; sudo make install",
		path => "/usr/local/bin/:/bin/:/usr/bin/",
		cwd => "/root/modules/nginx-1.8.0",
		unless => "/usr/bin/test -f /root/modules/nginx-1.8.0.tar.gz"
	}

	file {'/usr/local/nginx/conf/dmi':
		ensure 		=> 'directory',
		owner 		=> 'root',
	}->
	file { 'log-sym-link':
		path => '/usr/local/nginx/logs',
     	ensure => 'link',
     	target => '/logs/nginx',
}  	
}
