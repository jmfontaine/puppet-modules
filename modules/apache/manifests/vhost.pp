define apache::vhost (
    $document_root_path,
    $port           = "80",
    $template       = "apache/vhost.erb",
    $server_aliases = "",
    $priority       = "50",
    ) {

    include apache

    $server_name = $name
    $log_dir     = $apache::log_dir
    $vhost_dir   = "${apache::conf_dir}/sites-enabled"

    file { "${vhost_dir}/${priority}-${server_name}.conf":
        ensure  => present,
        content => template($template),
        mode    => $apache::config_mode,
        owner   => $apache::config_owner,
        group   => $apache::config_group,
        require => Package["apache"],
        notify  => Service["apache"],
    }
}
