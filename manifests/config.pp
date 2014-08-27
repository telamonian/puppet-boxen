# Public: Set up necessary Boxen configuration
#
# Usage:
#
#   include boxen::config

class boxen::config (
  $home = undef,
  $bindir = undef,
  $cachedir = undef,
  $configdir = undef,
  $datadir = undef,
  $envdir = undef,
  $homebrewdir = undef,
  $logdir = undef,
  $repodir = undef,
  $reponame = undef,
  $socketdir = undef,
  $srcdir = undef,
  $login = undef,
  $repo_url_template = undef,
) {
  validate_string(
    $home,
    $bindir,
    $cachedir,
    $configdir,
    $datadir,
    $envdir,
    $homebrewdir,
    $logdir,
    $repodir,
    $reponame,
    $socketdir,
    $srcdir,
    $login,
    $repo_url_template,
  )

  #fail("$home,$bindir,$cachedir,$configdir,$datadir,$envdir,$homebrewdir,$logdir,$repodir,$reponame,$socketdir,$srcdir,$login,$repo_url_template")
  
  file { [$home,
          $srcdir,
          $bindir,
          $cachedir,
          $configdir,
          $datadir,
          $envdir,
          $logdir,
          $socketdir]:
    ensure => directory,
    links  => follow
  }
  
  # take care of paths and directories that exist in Darwin but not in Debian
  if $::osfamily == 'Debian'
  {
    file {"/Users":
      ensure => directory,
      links  => follow,
      owner  => root
    }
    file {"/Users/${::boxen_user}":
      ensure  => 'link',
      target  => "/home/${::boxen_user}",
      owner   => $::boxen_user,
      require => [ File["/Users"] ],
    }
    file {"/var/db":
      ensure => directory,
      links  => follow,
      owner  => root
    }
  }
  
  file { "${home}/README.md":
    source => 'puppet:///modules/boxen/README.md'
  }

  file { "${home}/env.sh":
    content => template('boxen/env.sh.erb'),
    mode    => '0755',
  }

  file { ["${envdir}/config.sh", "${envdir}/gh_creds.sh"]:
    ensure => absent,
  }

  group { 'puppet':
    ensure => present
  }

  $puppet_data_dirs = [
    "${home}/data/puppet",
    "${home}/data/puppet/graphs"
  ]

  file { $puppet_data_dirs:
    ensure => directory,
    owner  => $::boxen_user
  }
  
 
}
