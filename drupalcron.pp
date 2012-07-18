# this file exists only becuase generate() function
# gets executed during compile time (wtf) and we need
# it to obtain a cron key that was generated during
# the run of the script by installing Drupal

# setup cron
# we need to get a cron key first
$cron_key = split(generate('/tmp/drush/drush', '-r', '/var/www/', 'vget', 'cron_key'), "\"")
cron { "setupcron":
  ensure => present,
  command => "wget -O - -q -t 1 http://localhost/cron.php?cron_key=${cron_key[1]}",
  hour => '*',
  minute => '*',
  month => '*',
  monthday => '*',
  weekday => '*',
}
