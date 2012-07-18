class lamp ($workingdirectory, $mysqlpwd) {
  Package { ensure => "installed" }

  package { "apache2": }
  package { "php5":
    require => Package["apache2"]
  }
  package { "php5-mcrypt":
    require => Package["php5"]
  }
  package { "php5-mysql":
    require => Package["mysql-server"]
  }
  package { "php5-gd":
    require => Package["mysql-server"]
  }
  package { "php-db":
    require => Package["mysql-server"]
  }
  package { "mysql-server": }
  exec { "mysqlpasswd":
    command => "/usr/bin/mysqladmin -u root password ${mysqlpwd}",
    notify => [Service["mysql"]],
    subscribe   => Package["mysql-server"],
    refreshonly => true,
  }
  package { "libapache2-mod-php5" :
    require => [Package["apache2"], Package["php5"]],
  }
  package { "libapache2-mod-auth-mysql": 
    require => [Package["apache2"], Package["mysql-server"]],
  }
  package { "phpmyadmin": 
    require => [Package["apache2"], Package["mysql-server"]],
  }
	file { "enablephpmyadmin":
		ensure => link,
		path => "/etc/apache2/conf.d/phpmyadmin.conf",
		target => "/etc/phpmyadmin/apache.conf",
		require => Package["phpmyadmin"],
		notify => Service["apache2"],
	}

  service { "apache2":
    ensure => "running",
    enable => "true",
    require => Package["apache2"],
  }

  # this only to allow override
	file { "defaultsite":
		ensure => present,
		path => "/etc/apache2/sites-available/default",
		source => "${workingdirectory}/default",
		mode => 0644,
    require => Package["apache2"],
		notify => Service["apache2"],
	}

  service { "mysql":
    ensure => "running",
    enable => "true",
    require => Package["mysql-server"],
  }

  exec { "enablephp":
		notify => Service["apache2"],
		command => "/usr/sbin/a2enmod php5",
    require => [Package["apache2"], Package["php5"], Package["libapache2-mod-php5"]],
 	}

  exec { "enablerewrite":
		notify => Service["apache2"],
		command => "/usr/sbin/a2enmod rewrite",
    require => [Package["apache2"], Package["php5"], Package["libapache2-mod-php5"]],
 	}
  
	exec { "userdir":
		notify => Service["apache2"],
		command => "/usr/sbin/a2enmod userdir",
    require => [Package["apache2"], Package["mysql-server"], Package["libapache2-mod-auth-mysql"]],
	}  
}