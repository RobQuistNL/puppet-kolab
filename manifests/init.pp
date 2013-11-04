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
      destination    => 'mirror.kolabsys.com',
      destination_v6 => 'mirror.kolabsys.com',
      protocol       => tcp,
      port           => 80,
      direction      => 'output',
    }
  }

  include iptables
  Service[ 'iptables' ] -> Exec['aptget_update']

  package { 'php5': }

  # https://issues.kolab.org/show_bug.cgi?id=1763
  file { '/etc/php5/mods-available':
    ensure  => 'link',
    target  => '/etc/php5/conf.d',
    require => Package['php5'],
    before  => Package['kolab']
  }

  file { '/usr/local/bin/php5enmod':
    ensure  => 'link',
    target  => '/bin/true',
    before  => Package['kolab']
  }

  apt::repository { 'kolab-ubuntu':
    url        => 'http://mirror.kolabsys.com/pub/ubuntu/kolab-3.0/',
    distro     => 'precise',
    repository => 'development',
  }

  #  https://issues.kolab.org/show_bug.cgi?id=1922
  apt::repository { 'kolab-debian':
    url        => 'http://mirror.kolabsys.com/pub/debian/kolab-3.0/',
    distro     => 'wheezy',
    repository => 'development',
  }

  package { ['exim4', 'exim4-base', 'exim4-config', 'exim4-daemon-light',
             'manpages' #  manpages_3.44-1_all.deb (--unpack):  trying to overwrite 
                        #'/usr/share/man/man1/getent.1.gz', which is also in package 
                        # libc-bin 2.15-0ubuntu10.5
  ]:
    ensure => absent,
    before => Package['kolab']
  }

  package { 'kolab':
    ensure => '3.*'
  }
  
  package { 'kolab-webadmin':
    ensure => '3.*'
  }

#  apache::vhost { 'kolab':
#    template => 'kolab/apache2.conf.erb',
#    require  => Package['kolabadmin'],
#  }

}
