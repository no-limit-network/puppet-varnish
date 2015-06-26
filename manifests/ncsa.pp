class varnish::ncsa (
  $enable = true,
  $varnishncsa_daemon_opts = undef,
) {

  file { '/etc/default/varnishncsa':
    ensure  => 'present',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('varnish/varnishncsa-default.erb'),
    notify  => Service['varnishncsa'],
  }


  $service_ensure = $enable ? {
    true => 'running',
    default => 'stopped',
  }

  if "${::operatingsystemmajrelease}" > 6 {
  file { '/usr/lib/systemd/system/varnishncsa.service':
    ensure  => 'present',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('varnish/varnishncsa-systemd.erb'),
    notify  => Service['varnishncsa'],
  }
  } 
  service { 'varnishncsa':
    ensure    => $service_ensure,
    enable    => $enable,
    require   => Service['varnish'],
    subscribe => File['/etc/default/varnishncsa'],
  }

}
