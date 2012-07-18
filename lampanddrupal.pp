class {'lamp':
  workingdirectory => $workingdirectory,
  mysqlpwd => $mysqlpwd,
}

class {'drush':}
  
class {'drupal':
  require => [Class['lamp'], Class['drush']],
}

