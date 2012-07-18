class drupal {
	# no need for index.html
	file { "removeindexhtml":
		ensure => absent,
		force => true,
		path => "/var/www/index.html",
	}

	# install core drupal
	exec { "getdrupal":
		path => ['/tmp/drush/', '/usr/bin/php', '/usr/bin/', '/bin/'],
		command => "drush dl drupal --destination=/tmp/ --drupal-project-rename=drupal",
		creates => '/tmp/drupal/',
    timeout => 0,
    require => Exec["getdrush"],
	}
	file { "movedrupal":
		ensure => present,
		path => "/var/www/",
		source => '/tmp/drupal/',
		recurse => true,
    require => Exec["getdrupal"],
	}

  # cleanup
	file { "removedrupaltmp":
		ensure => absent,
		force => true,
		path => "/tmp/drupal/",
    require => File["movedrupal"],
	}
}

class {'drush':}
  
class {'drupal':
  require => [Class['drush']],
}

