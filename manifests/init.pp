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
    $firewall = true,
  ) inherits kolab::params {

  if (any2bool($firewall)) {
    firewall::rule { 'kolab-apt-repo':
      destination => '178.209.35.107', # mirror.kolabsys.com:80
      protocol    => tcp,
      port        => 80,
      direction   => 'output',
    }
  
    include iptables
    Service[ 'iptables' ] -> Exec['aptget_update']
  }

  # Packages are temporarily unsigned
  file { "/etc/apt/apt.conf.d/99auth": #since we can't really add --force-yes to the apt-get install.       
    owner     => root,
    group     => root,
    content   => "APT::Get::AllowUnauthenticated yes;",
    mode      => 644,
    before    => Exec['aptget_update']
  }


  #Add repositories for Kolab
  apt::pin { 'kolab-pin':
    priority        => 501,
    origin          => 'mirror.kolabsys.com',
    package         => '*',
  }

  apt::repository { 'kolab':
    url         => "http://mirror.kolabsys.com/pub/ubuntu/kolab-${version}/",
    distro      => 'precise',
    repository  => 'release updates',
  }
  
  package { ['exim4', 'exim4-base', 'exim4-config', 'exim4-daemon-light']:
    ensure => absent,
  }

  package { ['kolabd', 'kolabadmin', 'kolab-webadmin', 'php-kolab-filter',
             'php-kolab-freebusy', 'ldap-account-manager', 'kolab-cyrus-imapd',
             'kolab-cyrus-admin' ]:
    ensure  => installed,
    require => [ Exec['aptget_update'], Package['exim4'], Package['exim4-base'],
                 Package['exim4-config'], Package['exim4-daemon-light']]
  }


  #exec {'setup-kolab': 
  #  require => Package['kolab-webadmin']
  #}

#  File ['/etc/apt/apt.conf.d/99auth'] -> Package ['kolab']
#  Package ['kolab-webadmin'] -> Exec ['rm /etc/apt/apt.conf.d/99auth']

}
