class drush {
	# get drush and untar
	exec { "getdrush":
		path => ['/usr/bin/', '/bin/'],
		command => "wget http://ftp.drupal.org/files/projects/drush-7.x-5.4.tar.gz; tar -xf drush-7.x-5.4.tar.gz -C /tmp; rm drush-7.x-5.4.tar.gz",
		creates => '/tmp/drush/',
    timeout => 0,
	}
}
