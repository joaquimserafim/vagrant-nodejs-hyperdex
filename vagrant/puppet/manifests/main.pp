class apt_update {
    exec { "aptGetUpdate":
        command => "sudo apt-get update",
        path => ["/bin", "/usr/bin"]
    }
}

class othertools {
    package { "git":
        ensure => latest,
        require => Exec["aptGetUpdate"]
    }

    package { "vim-common":
        ensure => latest,
        require => Exec["aptGetUpdate"]
    }

    package { "curl":
        ensure => present,
        require => Exec["aptGetUpdate"]
    }

    package { "htop":
        ensure => present,
        require => Exec["aptGetUpdate"]
    }

    package { "g++":
        ensure => present,
        require => Exec["aptGetUpdate"]
    }
}

class nodejs {
  exec { "git_clone_n":
    command => "git clone https://github.com/visionmedia/n.git /home/vagrant/n",
    path => ["/bin", "/usr/bin"],
    require => [Exec["aptGetUpdate"], Package["git"], Package["curl"], Package["g++"]]
  }

  exec { "install_n":
    command => "make install",
    path => ["/bin", "/usr/bin"],
    cwd => "/home/vagrant/n",
    require => Exec["git_clone_n"]
  }

  exec { "install_node":
    command => "n stable",
    path => ["/bin", "/usr/bin", "/usr/local/bin"],
    require => [Exec["git_clone_n"], Exec["install_n"]]
  }
}

class hyperDex {
  exec { "hyperDex_keys":
    command => "wget -O - http://ubuntu.hyperdex.org/hyperdex.gpg.key | sudo apt-key add -",
    path    => ["/bin", "/usr/bin"],
  }

  exec { "hyperDex_list":
    path    => ["/bin", "/usr/bin"],
    command => "sudo wget -O /etc/apt/sources.list.d/hyperdex.list http://ubuntu.hyperdex.org/trusty.list",
    require => Exec["hyperDex_keys"]
  }

  exec { "aptGetUpdate_1":
    command => "sudo apt-get update",
    path    => ["/bin", "/usr/bin"],
    require => Exec["hyperDex_list"]
  }
  
  package { "hyperdex":
    ensure  => latest,
    require => Exec["aptGetUpdate_1"]
  }
}

include apt_update
include othertools
include nodejs
include hyperDex
