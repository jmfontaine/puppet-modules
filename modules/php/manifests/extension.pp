define php::extension (
    $prefix   = "php5-",
    $ensure   = "present",
    ) {

    include php

    package { "php.extension.${name}":
        ensure  => $ensure,
        name    => "${prefix}${name}",
        notify  => Service["apache"],
        require => Package['php.apache'],
    }
}
