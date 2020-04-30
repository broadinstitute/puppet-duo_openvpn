# @summary Download, build, and install the duo_openvpn OpenVPN plugin
#
# @example
#  include duo_openvpn
# @example
#  class { 'duo_openvpn':
#    install_path => '/usr/local/duo',
#    version      => '2.0',
#  }
#
# @param [Array] default_packages
#   An array of packages to require (Default: curl, gcc, make)
# @param [Stdlib::Absolutepath] download_path
#   The directory to which the tar file for duo_openvpn will be downloaded (Default: /tmp)
# @param [Stdlib::HTTPSUrl] download_url
#   (optional) The URL from which duo_openvpn will be downloaded (Default: auto-generated from version)
# @param [Stdlib::Absolutepath] extract_path
#   The path where the downloaded tar file will be extracted (Default: /opt/duo_openvpn)
# @param [String] group
#   The group ownership on the install path directory (Default: root)
# @param [Stdlib::Absolutepath] install_path
#   The location where the built plugin will be installed (Default: /opt/duo)
# @param [String] install_path_mode
#   The directory mode (permissions) on the install path directory (Default: 0755)
# @param [String] owner
#   The owner on the install path directory (Default: root)
# @param [String] version
#   The version of the duo_openvpn plugin to install (Default: 2.4)
#
class duo_openvpn (
  Array $default_packages,
  Stdlib::Absolutepath $download_path,
  Optional[Stdlib::HTTPSUrl] $download_url,
  Stdlib::Absolutepath $extract_path,
  String $group,
  Stdlib::Absolutepath $install_path,
  String $install_path_mode,
  Boolean $manage_packages,
  String $owner,
  String $version,
) {

  if ($download_url and $download_url != '') {
    $archive_url = $download_url
  } else {
    $archive_url = "https://github.com/duosecurity/duo_openvpn/archive/${version}.tar.gz"
  }

  if $manage_packages {
    package { $default_packages:
      ensure => 'present',
    }
  }

  file { 'duo_openvpn_extract_path':
    ensure => 'directory',
    backup => false,
    group  => $group,
    mode   => '0700',
    owner  => $owner,
    path   => $extract_path,
  }

  file { 'duo_openvpn_install_path':
    ensure => 'directory',
    backup => false,
    group  => $group,
    mode   => $install_path_mode,
    owner  => $owner,
    path   => $install_path,
  }

  # All package installations happen before we use archive
  Package<| |> -> Archive<| |>

  archive { "${download_path}/duo_openvpn-${version}.tar.gz":
    creates      => "${extract_path}/duo_openvpn-${version}",
    extract      => true,
    extract_path => $extract_path,
    notify       => Exec['duo_openvpn_build'],
    require      => File['duo_openvpn_extract_path'],
    source       => $archive_url,
  }

  exec { 'duo_openvpn_build':
    command     => 'make',
    cwd         => "${extract_path}/duo_openvpn-${version}",
    path        => '/usr/sbin:/usr/bin:/sbin:/bin',
    refreshonly => true,
    notify      => Exec['duo_openvpn_install'],
  }

  exec { 'duo_openvpn_install':
    command     => "make PREFIX=${install_path} install",
    cwd         => "${extract_path}/duo_openvpn-${version}",
    path        => '/usr/sbin:/usr/bin:/sbin:/bin',
    refreshonly => true,
    require     => File['duo_openvpn_install_path'],
  }
}
