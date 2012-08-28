define apache::module (
    $ensure   = "present",
    $template = "",
    ) {

    include apache

    if "" != $template {
        file { "${apache::conf_dir}/modules-available/${name}.conf":
            ensure  => present,
            content => template($template),
            mode    => $apache::config_mode,
            owner   => $apache::config_owner,
            group   => $apache::config_group,
            require => Package["apache"],
            notify  => Service["apache"],
        }
    }

    case $ensure {
        "present": {
            exec { "a2enmod ${name}":
                unless  => "/bin/sh -c '[ -L ${apache::config_dir}/mods-enabled/${name}.load ] && [ ${apache::config_dir}/mods-enabled/${name}.load -ef ${apache::config_dir}/mods-available/${name}.load ]'",
                notify  => Service["apache"],
                require => Package["apache"],
            }
        }
        "absent": {
            exec { "a2dismod ${name}":
                onlyif  => "/bin/sh -c '[ -L ${apache::config_dir}/mods-enabled/${name}.load ] && [ ${apache::config_dir}/mods-enabled/${name}.load -ef ${apache::config_dir}/mods-available/${name}.load ]'",
                notify  => Service["apache"],
                require => Package["apache"],
            }
        }
        default: {
        }
    }
}
