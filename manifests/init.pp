class pe_puppetserver_statusproxy (
  Enum['present', 'absent'] $ensure = present,
  Integer                   $port   = 8124,
) {

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'status-proxy-service' :
    ensure    => $ensure,
    container => 'puppetserver',
    namespace => 'puppetlabs.trapperkeeper.services.status.status-proxy-service',
    service   => 'status-proxy-service',
    notify    => Service['pe-puppetserver'],
    require   => [
      Package['pe-puppetserver'],
      File['/etc/puppetlabs/puppetserver/conf.d/status-proxy.conf'],
    ],
  }

  file { '/etc/puppetlabs/puppetserver/conf.d/status-proxy.conf':
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('pe_puppetserver_statusproxy/status-proxy.conf.epp', {
      'certname' => $::clientcert,
      'port'     => $port,
    }),
  }

}
