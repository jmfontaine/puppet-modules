define line($file, $line, $ensure = "present") {
    case $ensure {
        default : { err ( "unknown ensure value ${ensure}" ) }
        present: {
            exec { "echo '${line}' >> '${file}'":
                unless => "grep -qFx '${line}' '${file}'"
            }
        }
        absent: {
            exec { "grep -vFx '${line}' '${file}' | tee '${file}' > /dev/null 2>&1":
              onlyif => "grep -qFx '${line}' '${file}'"
            }
        }
        uncomment: {
            exec { "sed -i -e'/${line}/s/#\+//' ‘${file}’” :
                onlyif => "grep '${line}' '${file}' | grep '^#' | wc -l"
            }
        }
        comment: {
            exec { "sed -i -e'/${line}/s/\(.\+\)$/#\1/' ‘${file}’" :
                onlyif => "test `grep '${line}' '${file}' | grep -v '^#' | wc -l` -ne 0"
            }
        }
    }
}
