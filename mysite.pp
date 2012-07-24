# this is the only file you need to edit to configure
# your own site;
# make one copy for each site and stick it in your git for future
drupie::site {"site1":
  # if this is not set, the latest release of Drupal is installed
  #drupalversion => '7.14',

  # pointers to custom module/theme/libs directories
  # (these should point inside your own git repo)
  custommodulesdir => "/home/rhodul/mysite1/modules",
  customthemesdir => "/home/rhodul/mysite1/themes",
  #customlibsdir => "/home/rhodul/mysite1/libs",
  
  # the list of contributed modules to be downloaded;
  # these must be module names - e.g. Chaos Tools
  # module name is 'ctools';
  # if the name is plain 'ctools' the latest version
  # will be installed;
  # the name can dictate the exact version like so:
  # 'services-6.x-3.1';
  # the list is simple space delimited string
  downloadcontribmodules => 'ctools services',
  # the list of contributed modules to be installed;
  # these must be module names - e.g. Chaos Tools
  # module name is 'ctools';
  # the list is simple space delimited string;
  # the reason for separation is that one downloaded
  # contributed code may have multiple modules, like
  # services, for example, brings and xmlrpc_server;
  installcontribmodules => 'ctools services xmlrpc_server',

  # themese; same rules as for modules
  downloadcontribthemes => 'fusion',
  # separation of download and install is because
  # to be able to inherit from a theme it must be present
  # but doesn't have to be installed
  installcontribthemes => 'fusion_starter',
  defaultcontribtheme => 'fusion_starter',
}
