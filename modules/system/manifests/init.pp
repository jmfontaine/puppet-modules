# = Class: system
#
# This class configures/manages the system.
# Only supported on Debian-derived OSes.
#
# == Parameters:
#
# $motd:::    Message of the day displayed on login. If none defined the OS's default will be displayed.
# $packages:: An array of package names. Puppet will ensure these packages are installed. Defaults to [ "htop" ].
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class {'system':
#       motd     => "Welcome to this VM\n",
#       packages => [ "git-core", "htop" ]
#   }
#
class system ($motd = undef, $packages = undef) {

    # Define packages if none provided
    if undef == $packages {
        $installed_packages = [ "htop" ]
    } else {
        $installed_packages = $system::packages
    }

    # Create "puppet" group
    group { "puppet":
        ensure => "present",
    }

    # Define default files permissions
    File {
        owner => 0,
        group => 0,
        mode  => 0644,
    }

    # Update packages list before doing anything
    # TODO: Check if this actually work
    exec { "apt.update" :
        command => "apt-get update",
    }
    Exec["apt.update"]->Package <| |>

    # Define message of the day
    if undef != $motd {
        file { "motd":
            path    => "/etc/motd.tail",
            ensure  => present,
            content => $system::motd,
        }
    }

    # Install some useful packages
    package { "packages.useful":
        ensure => present,
        name   => $system::installed_packages,
    }
}
