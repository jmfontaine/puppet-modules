class mysql (
    $config_mode    = "0644",
    $config_owner   = "root",
    $config_group   = "root",
    $service_enable = true,
    $service_ensure = running,
    $phpmyadmin     = false,
    ) {

    include apache

    package { "mysql":
        ensure => present,
        name   => "mysql-server",
    }

    service { "mysql":
        ensure    => $mysql::service_ensure,
        name      => "mysql",
        enable    => $mysql::service_enable,
        require   => Package["mysql"],
        hasstatus => true,
        pattern   => "mysql",
    }

    # phpMyAdmin
    if true == $mysql::phpmyadmin {
        $phpmyadmin_ensure             = present
        $phpmyadmin_apache_conf_ensure = link
    } else {
        $phpmyadmin_ensure             = absent
        $phpmyadmin_apache_conf_ensure = absent
    }

    package { "phpmyadmin":
        ensure => $phpmyadmin_ensure,
        notify => Service["apache"],
    }
    file { "phpmyadmin.apache.conf":
        ensure  => $phpmyadmin_apache_conf_ensure,
        name    => "/etc/apache2/conf.d/phpmyadmin.conf",
        target  => "/etc/phpmyadmin/apache.conf",
        require => Package["phpmyadmin"],
        notify  => Service["apache"],
    }
    if present == $phpmyadmin_ensure {

    }
}
