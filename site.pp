define site ($sitename = $title, $targetdir, $mysqlpwd, $contribmodules = undef) {
	include drush
	include drupal

	# create a link in Drupal to target
	file { "sitelink${sitename}":
		ensure => link,
		path => "/var/www/sites/${sitename}/",
		target => "${targetdir}/",
		require => Class["drupal"],
	}

	# create site
	exec { "installsite${sitename}":
		path => ['/tmp/drush/', '/usr/bin/php', '/usr/bin/', '/bin/'],
		command => "drush -l ${sitename} -y site-install standard --account-name=admin --account-pass=admin --db-su=root --db-su-pw=${mysqlpwd} --db-url=mysql://${sitename}:`openssl rand -base64 16`@localhost/${sitename}",
		cwd => "/var/www/",
		creates => '/var/www/sites/${sitename}/settings.php',
    timeout => 0,
    require => File["sitelink${sitename}"],
	}
	file { "makefileswritable${sitename}":
		ensure => directory,
		path => "/var/www/sites/${sitename}/files",
		mode => 0777,
		recurse => true,
    require => Exec["installsite${sitename}"],
	}
	
}