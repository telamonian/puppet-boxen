# Private: Ensure we can run Boxen, launchctl, and fdesetup without sudo prompt

class boxen::sudoers {
  
  $chown = $osfamily ? {
    'Darwin' => '/usr/sbin/chown',
    default  => '/bin/chown',
  }
  
  sudoers { 'boxen':
    users    => $::boxen_user,
    hosts    => 'ALL',
    commands => [
      '(ALL) NOPASSWD : /bin/mkdir -p /tmp/puppet',
      "/bin/mkdir -p ${::boxen_home}",
      "${chown} ${::boxen_user}\\:${boxen::config::group} ${::boxen_home}",
      "${boxen::config::repodir}/bin/puppet",
      '/bin/rm -f /tmp/boxen.log'
    ],
    type     => 'user_spec',
  }
  
  if $osfamily=='Darwin' {
    sudoers { 'fdesetup':
      users    => $::boxen_user,
      hosts    => 'ALL',
      commands => [
        '(ALL) NOPASSWD : /usr/bin/fdesetup status',
        '/usr/bin/fdesetup list',
      ],
      type     => 'user_spec',
    }
  
    sudoers { 'launchctl':
      users    => $::boxen_user,
      hosts    => 'ALL',
      commands => [
        '(ALL) NOPASSWD : /bin/launchctl load',
        '/bin/launchctl unload',
      ],
      type     => 'user_spec',
    } 
  }
}
