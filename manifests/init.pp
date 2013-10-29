# = Class: kolab
#
# This is the main kolab class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# See README for usage patterns.
#
class kolab (
    $disable = false,
    $absent = false,
    $version = '3.0',
    $firewall = true
  ) inherits kolab::params {
    
#  include php  # TODO but dont have this one yet
  include apache

  if any2bool($firewall) {
    firewall { 'kolab-apt-repo-smarty':
      destination    => 'de.archive.ubuntu.com',
      destination_v6 => 'de.archive.ubuntu.com',
      protocol       => tcp,
      port           => 80,
      direction      => 'output',
    }

    firewall { 'kolab-apt-repo':
      destination    => 'obs.kolabsys.com',
      destination_v6 => 'obs.kolabsys.com',
      protocol       => tcp,
      port           => 82,
      direction      => 'output',
    }
  }

  include iptables
  Service[ 'iptables' ] -> Exec['aptget_update']

# Smarty3
  apt::repository { 'smarty3':
    url        => 'http://de.archive.ubuntu.com/ubuntu/',
    distro     => 'raring',
    repository => 'universe',
  }

  package { 'smarty3':
#    before => Package['kolab']
  }

  apt::pin { 'smarty3':
    package => 'smarty3',
    type    => 'release',
    release => 'raring',
    priority => 800,
#    before  => Package['kolab'],
  }

# Kolab
  apt::repository { 'kolab':
    url         => "http://obs.kolabsys.com:82/Kolab:/3.1/Ubuntu_12.04/",
    distro      => './',
    repository  => '',
  }

  apt::repository { 'kolab-updates':
    url         => "http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/Ubuntu_12.04/",
    distro      => './',
    repository  => '',
  }

  package { ['exim4', 'exim4-base', 'exim4-config', 'exim4-daemon-light']:
    ensure => absent,
  }
  
#  # Packages are temporarily unsigned
#  file { "/etc/apt/apt.conf.d/99auth":
#    owner     => root,
#    group     => root,
#    content   => "APT::Get::AllowUnauthenticated yes;",
#    mode      => 644,
#    before    => Exec['aptget_update']
#  }

  #Add repositories for Kolab
#  apt::pin { 'kolab-pin':
#    priority        => 501,
#    origin          => 'mirror.kolabsys.com',
#    package         => '*',
#  }



#  package { ['kolabd', 'kolabadmin', 'kolab-webadmin', 'php-kolab-filter',
#             'php-kolab-freebusy', 'ldap-account-manager', 'kolab-cyrus-imapd',
#             'kolab-cyrus-admin' ]:
#    ensure  => installed,
#    require => [ Exec['aptget_update'], Package[$apache::package],
#                 Package['exim4'], Package['exim4-base'],
#                 Package['exim4-config'], Package['exim4-daemon-light']]
#  }
#
#  apache::vhost { 'kolab':
#    template => 'kolab/apache2.conf.erb',
#    require  => Package['kolabadmin'],
#  }

}
