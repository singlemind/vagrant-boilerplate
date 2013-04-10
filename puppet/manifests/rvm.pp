class rvm {
  # Requirements needed for building rubies and friends
  package {
    ['curl', 'bison', 'openssl', 'libssl-dev', 'libreadline5', 'libreadline-dev',
    'libcurl4-openssl-dev', 'libyaml-dev', 'libsqlite3-dev', 'sqlite3', 
    'libxml2-dev', 'libxslt1-dev', 'libgdbm-dev', 'libncurses5-dev', 
    'libtool', 'libffi-dev'] :
      ensure => present
  }

  #this is usually in the ubuntu repos...
  if (!defined(Package['build-essential'])) {
    package {
      'build-essential' :
        ensure => present;
    }
  }

  #some flavors of linux are different...
  if (!defined(Package['autoconf'])) {
    package {
      'autoconf' :
        ensure => present;
    }
  }
}

define rvm::install() {
  exec {
    "download rvm for ${name}" :
      creates => "/home/${name}/.rvm/scripts/rvm",
      cwd     => "/home/${name}",
      command => 'curl -L get.rvm.io -o install-rvm.sh',
      user    => $name,
      path    => ['/bin', '/usr/bin'],
      notify  => Exec["install rvm for ${name}"],
      require => User[$name];

    "install rvm for ${name}" :
      creates     => "/home/${name}/.rvm/scripts/rvm",
      command     => 'bash -s stable < install-rvm.sh',
      cwd         => "/home/${name}",
      user        => $name,
      environment => ["HOME=/home/${name}"],
      provider    => shell,
      logoutput   => on_failure,
      refreshonly => true,
      path        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
      #timeout     => "1000",
      require     => User[$name];

  }
}