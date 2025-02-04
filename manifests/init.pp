# @summary A module to manage apparmor
# @param local_overrides A hash of local overrides for the apparmor class
class apparmor (
  Hash[String, Apparmor::Local_override] $local_overrides = {},
) {
  ensure_packages(['apparmor', 'apparmor-profiles', 'apparmor-utils'])
  service { 'apparmor':
    ensure  => running,
    enable  => true,
    require => Package['apparmor'],
  }
  $local_overrides.each |$profile, $config| {
    $content = $config['content_type'] ? {
      'array'    => { 'content' => "${config['content'].join(",\n")}," },
      'source'   => { 'source'  => $config['content'] },
      'string'   => { 'content' => $config['content'] },
      'template' => { 'content' => template($config['content']) },
    }
    file { "/etc/apparmor.d/local/${profile}":
      ensure  => file,
      require => Package['apparmor'],
      notify  => Service['apparmor'],
      *       => $content,
    }
  }
}
