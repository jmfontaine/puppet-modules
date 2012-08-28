class apache (
    $config_mode       = "0644",
    $config_owner      = "root",
    $config_group      = "root",
    $config_template   = "",
    $service_enable    = true,
    $service_ensure    = running,
    $conf_dir          = "/etc/apache2",
    $log_dir           = "/var/log/apache2",
    ) {

    $config_content = $apache::config_template ? {
        ""      => undef,
        default => template($apache::config_template),
    }

    package { "apache":
        ensure => "present",
        name   => "apache2",
    }

    file { "apache.config":
        ensure  => "present",
        path    => "/etc/apache2/apache2.conf",
        mode    => $apache::config_mode,
        owner   => $apache::config_owner,
        group   => $apache::config_group,
        require => Package["apache"],
        notify  => Service["apache"],
        content => $apache::config_content,
    }

    service { "apache":
        ensure    => $apache::service_ensure,
        name      => "apache2",
        enable    => $apache::service_enable,
        require   => Package["apache"],
        hasstatus => true,
        pattern   => "apache2",
    }
}
