class kolab::dependencies (
  $version = $kolab::version,
) {

  

#
#  #Dependency for webadmin
#  package { ['cyrus-imapd', 'python-dateutil', 'libmozldap-0d', 'mozldap-tools', 'php5-cgi', 'php5-cli']:
#    ensure => installed,
#  }
#  ->
#  file {'/var/lib/imap': 
#    ensure => link,
#    target => '/var/lib/cyrus',
#    replace => false,
#  }
#  ->
#  file {'/var/spool/imap': 
#    ensure => link,
#    target => '/var/spool/cyrus',
#    replace => false,
#  }
#  ->
#  file {'/usr/lib/imap': 
#    ensure => link,
#    target => '/usr/lib/cyrus',
#    replace => false,
#  }
#
#  #Some other dependencies
#  file {'/etc/php5/mods-available/':
#    ensure => 'directory',
#    owner => 'root',
#    group => 'root',
#    require => Package['apache2', 'php5']
#  }
#
#  package {'clamav-freshclam':
#    notify => Exec['freshclam']
#  }
#
#  exec {'freshclam': }
#
#  package {'clamav-daemon':
#    require => Package['clamav-freshclam']
#  }
#
#  #Remove some (possible) unsupported files
#  file {[ '/var/lib/dpkg/info/php-kolab.postrm',
#          '/var/lib/dpkg/info/php-kolab.postinst',
#          '/var/lib/dpkg/info/php-kolabformat.postrm',
#          '/var/lib/dpkg/info/php-kolabformat.postinst',
#        ]: 
#    ensure => absent,
#  }
#
#  file { '/etc/php5/conf.d/kolabformat.ini':
#    ensure => link,
#    target => '/usr/share/php5/kolab/kolabformat.ini',
#    require => File['/etc/php5/mods-available/']
#  }
#
#  file { '/etc/php5/conf.d/kolab.ini':
#    ensure => link,
#    target => '/usr/share/php5/kolab/kolab.ini',
#    require => File['/etc/php5/mods-available/']
#  }
#  ->
#    exec { 'smarty-3':
#    command => 'wget http://nl.archive.ubuntu.com/ubuntu/pool/universe/s/smarty3/smarty3_3.1.10-2_all.deb \
#                && dpkg -i smarty3_3.1.10-2_all.deb \
#                && rm -f smarty3_3.1.10-2_all.deb \
#                && sudo apt-get update',
#    onlyif  => "test \"`dpkg -s smarty | grep 'Version' | cut -c 10-`\" != \"3.1.10\"",
#    require => Package['php5', 'php5-cgi', 'php5-cli']
#  }

}