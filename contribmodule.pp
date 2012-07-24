define drupie::contribmodule ($modulename = $title, $sitename, $landingdir) {
	exec { "getmodule${title}${sitename}":
		path => ['/usr/bin/php', '/usr/bin/', '/bin/', '/bin/bash'],
		command => "drush dl ${modulename}",
		cwd => "/var/www/${sitename}/sites/all/${landingdir}/",
		creates => '/var/www/${sitename}/sites/all/${landingdir}/${modulename}',
    timeout => 0,
	}
}