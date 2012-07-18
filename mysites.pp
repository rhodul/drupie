# this is the only file you need to edit to configure
# your own sites
site {"site1":
  targetdir => "/home/rhodul/mysite1",
  mysqlpwd => $mysqlpwd,
  contribmodules => ['ctools', 'services'],
}

site {"site2":
  targetdir => "/home/rhodul/mysite2",
  mysqlpwd => $mysqlpwd,
#  contribmodules => ['ctools', 'services'],
}

site {"site3":
  targetdir => "/home/rhodul/mysite3",
  mysqlpwd => $mysqlpwd,
  contribmodules => ['ctools'],
}
