class myclass {
	package { 'vim-enhanced':
	  ensure => present,
	  before => Package['curl'],
	}
	package { 'curl':
	  ensure => present,
	  before => Package['git'],
	}
	package { 'git':
	  ensure => present,
	  require => Package['curl'],
	}
	user { 'monitor':
	       ensure => 'present',
	       home => '/home/monitor',
	       shell => '/bin/bash',
	       managehome => true,
        }
	file { '/home/monitor/scripts':
   	       ensure => 'directory',
	       owner => 'monitor',
	       group => 'monitor',
	       require => User['monitor'],
  	}
	file { '/home/monitor/src':
               ensure => 'directory',
               owner => 'monitor',
               group => 'monitor',
               require => User['monitor'],
        }
	exec { 'wget https://raw.githubusercontent.com/wenbri28/test2/master/memory_check':
	  cwd     => '/home/monitor/scripts',
	  creates => '/home/monitor/scripts/memory_check',
	  path    => '/usr/bin',
          require => File['/home/monitor/scripts'],
	  unless => '/bin/ls /home/monitor/scripts/memory_check'
	}
	exec { 'ln -s /home/monitor/scripts/memory_check /home/monitor/src/my_memory_check':
	  path    => '/bin',
          require => [ File['/home/monitor/scripts'], File['/home/monitor/src'] ],
	  unless => '/bin/ls /home/monitor/src/my_memory_check'
        }
	cron { 'memory':
	  command => '/bin/bash /home/monitor/src/my_memory_check -w 60 -c 90 -e root@localhost',
	  user    => 'root',
	  hour    => '*',
	  minute  => '*/10',
	  require => Exec['ln -s /home/monitor/scripts/memory_check /home/monitor/src/my_memory_check'],
	}
	file {'/etc/localtime': 
	  ensure => link, 
	  target => "/usr/share/zoneinfo/Asia/Manila",
	}
}
