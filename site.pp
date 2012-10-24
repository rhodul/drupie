define drupie::site ($sitename = $title, $custommodulesdir, $customthemesdir, $customlibsdir = undef, $drupalversion = undef, $downloadcontribmodules = undef, $installcontribmodules = undef, $downloadcontribthemes = undef, $installcontribthemes = undef, $defaultcontribtheme = undef, $disablemodules = undef) {
	# do we have a version?
	$drupal = 'drupal'
	if $drupalversion != undef {
		$drupal = "drupal-${drupalversion}"
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
    require => Exec["getdrupal${sitename}"],
	}
	file { "removedrupaltmp{sitename}":
		ensure => absent,
		force => true,
		path => "/tmp/drupal/",
    require => File["movedrupal${sitename}"],
	}
		
	file { "makefileswritable${sitename}":
		ensure => directory,
		path => "/var/www/${sitename}/sites/default/files",
		mode => 0777,
		recurse => true,
    require => File["movedrupal${sitename}"],
	}
	
	# create site
	if $mysqlpwd != undef {
		exec { "installsite${sitename}":
			path => ['/usr/bin/php', '/usr/bin/', '/bin/', '/bin/bash'],
			command => "drush -y site-install standard --account-name=admin --account-pass=admin --db-su=root --db-su-pw=${mysqlpwd} --db-url=mysql://${sitename}:`openssl rand -base64 16`@localhost/${sitename}",
			cwd => "/var/www/${sitename}/",
			creates => '/var/www/${sitename}/sites/default/settings.php',
			timeout => 0,
			require => File["movedrupal${sitename}"],
		}
	} else {
		# dummy command just to have this resource for later when we install
		# contributed modules
		exec { "installsite${sitename}":
			path => ['/usr/bin/', '/bin/'],
			command => "echo ''",
		}
	}

	# create a link(s) in Drupal to target
	file { "moduleslink${sitename}":
		ensure => link,
		path => "/var/www/${sitename}/sites/all/modules/${sitename}",
		target => "${custommodulesdir}/",
    require => File["movedrupal${sitename}"],
	}
	file { "themeslink${sitename}":
		ensure => link,
		path => "/var/www/${sitename}/sites/all/themes/${sitename}",
		target => "${customthemesdir}/",
    require => File["movedrupal${sitename}"],
	}
	if $customlibsdir != undef {
		file { "libslink${sitename}":
			ensure => link,
			path => "/var/www/${sitename}/sites/all/libs/",
			target => "${customlibsdir}/",
      require => File["movedrupal${sitename}"],
		}
	}
	
	# install each of the contributed modules
	if $downloadcontribmodules != undef and $installcontribmodules != undef {
		$dwlds = split($downloadcontribmodules, ' ')
		drupie::contribmodule{$dwlds:
			sitename => $sitename,
			landingdir => 'modules',
      require => Exec["installsite${sitename}"],
      before => Exec["installmodule${sitename}"],
		}
		exec { "installmodule${sitename}":
			path => ['/usr/bin/php', '/usr/bin/', '/bin/', '/bin/bash'],
			command => "drush -y en ${installcontribmodules}",
			cwd => "/var/www/${sitename}/",
			timeout => 0,
		}
	}
	
	# install each of the contributed themes
	if $downloadcontribthemes != undef {
		$dwldst = split($downloadcontribthemes, ' ')
		drupie::contribmodule{$dwldst:
			sitename => $sitename,
			landingdir => 'themes',
      require => Exec["installsite${sitename}"],
      before => Exec["installtheme${sitename}"],
		}
		if $installcontribthemes != undef {
			exec { "installtheme${sitename}":
				path => ['/usr/bin/php', '/usr/bin/', '/bin/', '/bin/bash'],
				command => "drush -y en ${installcontribthemes}",
				cwd => "/var/www/${sitename}/",
				timeout => 0,
			}
			if $defaultcontribtheme != undef {
				exec { "defaultheme${sitename}":
					path => ['/usr/bin/php', '/usr/bin/', '/bin/', '/bin/bash'],
					command => "drush -y vset theme_default ${defaultcontribtheme}",
					cwd => "/var/www/${sitename}/",
					timeout => 0,
		      require => Exec["installtheme${sitename}"],
				}
			}
		}
	}
	
	# disable unwanted modules
	if $disablemodules != undef {
		exec { "disablemodules${sitename}":
			path => ['/usr/bin/php', '/usr/bin/', '/bin/', '/bin/bash'],
			command => "drush -y dis ${disablemodules}",
			cwd => "/var/www/${sitename}/",
			timeout => 0,
			require => Exec["installsite${sitename}"],
		}
	}
	
}
