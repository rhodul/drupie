define site ($sitename = $title, $custommodulesdir, $customthemesdir, $customlibsdir = undef, $drupalversion = undef) {
	# do we have a version?
	$drupal = 'drupal'
	if $drupalversion != undef {
		$drupal = "drupal-${drupalversion}"
	}

	# create a subdir for the site
	file { "sitedir${sitename}":
		ensure => directory,
		path => "/var/www/${sitename}/",
	}

	# ensure drupal core
	exec { "getdrupal${sitename}":
		path => ['/usr/bin/php', '/usr/bin/', '/bin/'],
		command => "drush dl ${drupal} --destination=/tmp/ --drupal-project-rename=drupal",
		creates => '/tmp/drupal/',
    timeout => 0,
	}
	file { "movedrupal${sitename}":
		ensure => present,
		path => "/var/www/${sitename}/",
		source => '/tmp/drupal/',
		recurse => true,
    require => [File["sitedir${sitename}"], Exec["getdrupal${sitename}"]],
	}
	file { "removedrupaltmp{sitename}":
		ensure => absent,
		force => true,
		path => "/tmp/drupal/",
    require => File["movedrupal"],
	}
	
	# create site
	exec { "installsite${sitename}":
		path => ['/usr/bin/php', '/usr/bin/', '/bin/'],
		#TODO: use `read "What's your MySql root pwd:`
		#     ?run interactive/verbose??
		command => "read -p 'Type MySql root password:' MYSQL_PWD; drush -y site-install standard --account-name=admin --account-pass=admin --db-su=root --db-su-pw=$MYSQL_PWD --db-url=mysql://${sitename}:`openssl rand -base64 16`@localhost/${sitename}",
		cwd => "/var/www/${sitename}/",
		creates => '/var/www/${sitename}/sites/default/settings.php',
    timeout => 0,
    require => File["movedrupal${sitename}"],
	}
	file { "makefileswritable${sitename}":
		ensure => directory,
		path => "/var/www/${sitename}/sites/default/files",
		mode => 0777,
		recurse => true,
    require => Exec["installsite${sitename}"],
	}

	# create a link(s) in Drupal to target
	file { "moduleslink${sitename}":
		ensure => link,
		path => "/var/www/${sitename}/sites/all/modules/${sitename}",
		target => "${custommodulesdir}/",
    require => Exec["installsite${sitename}"],
	}
	file { "themeslink${sitename}":
		ensure => link,
		path => "/var/www/${sitename}/sites/all/themes/${sitename}",
		target => "${customthemesdir}/",
    require => Exec["installsite${sitename}"],
	}
	if $customlibsdir != undef {
		file { "libslink${sitename}":
			ensure => link,
			path => "/var/www/${sitename}/sites/all/libs/",
			target => "${customlibsdir}/",
			require => Exec["installsite${sitename}"],
		}
	}
	
}