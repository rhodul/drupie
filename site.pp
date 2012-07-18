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
}