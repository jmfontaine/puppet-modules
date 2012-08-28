class php (
    $apache          = true,
    $cli             = true,
    $dotdeb          = false,
    $config_dir      = "/etc/php5/conf.d",
    $config_mode     = "0644",
    $config_owner    = "root",
    $config_group    = "root",
    $template        = "php/php.ini.erb",
    $version         = "5.3",
    $config          = {
       "date.timezone"   => "Europe/Paris",
       "error_reporting" => "E_ALL",
       "display_errors"  => "On",
       "log_errors"      => "Off",
    },

    # PHP settings
    $error_reporting = "E_ALL|E_STRICT",
    $display_errors  = "true",
    $log_errors      = "false",
    $timezone        = "Europe/Paris",
    ) {

    include system

    # Dotdeb
    if true == $dotdeb {
        $dotdeb_version = $php::version ? {
            "5.3"   => "squeeze",
            "5.4"   => "squeeze-php54",
            default => undef,
        }
        file { "php.dotdeb.apt.list":
            path    => "/etc/apt/sources.list.d/dotdeb.list",
            ensure  => "file",
            content => template("php/dotdeb.list.erb"),
            mode    => $php::config_mode,
            owner   => $php::config_owner,
            group   => $php::config_group,
        }
        exec { "php.dotdeb.apt.key" :
            command => "wget -O- http://www.dotdeb.org/dotdeb.gpg | apt-key add -",
            unless  => "apt-key list | grep dotdeb",
            require => File["php.dotdeb.apt.list"],
            notify  => Exec["apt.update"],
        }
    } else {
        file { "php.dotdeb.apt.list":
            path    => "/etc/apt/sources.list.d/dotdeb.list",
            ensure  => "absent",
        }
        exec { "php.dotdeb.apt.key" :
            command => "apt-key del 89DF5277",
            unless  => "apt-key list | grep -v dotdeb",
            require => File["php.dotdeb.apt.list"],
            notify  => Exec["apt.update"],
        }
    }

    if true == $apache {
        package { "php.apache":
            ensure => present,
            name   => "libapache2-mod-php5",
        }

        file { "php.conf.apache":
            ensure  => "present",
            path    => "/etc/php5/apache2/php.ini",
            mode    => $php::config_mode,
            owner   => $php::config_owner,
            group   => $php::config_group,
            require => Package["php.apache"],
            content => template($php::template),
        }
    }

    if true == $cli {
        package { "php.cli":
            ensure => present,
            name   => "php5-cli",
        }

        file { "php.conf.cli":
            ensure  => "present",
            path    => "/etc/php5/cli/php.ini",
            mode    => $php::config_mode,
            owner   => $php::config_owner,
            group   => $php::config_group,
            require => Package["php.cli"],
            content => template($php::template),
        }
    }
}
