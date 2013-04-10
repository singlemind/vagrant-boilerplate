vagrant-boilerplate
===================

VAGRANT SETUP WITH PUPPET AND RVM

Here's a quick start guide for using Vagrant to quickly bootstrap a VirtualBox virtual machine with and Puppet and RVM! 
<cut>
Download & install Vagrant (currently using Vagrant v1.1.4): http://downloads.vagrantup.com/tags/v1.1.4

Download & install virtual box: https://www.virtualbox.org/wiki/Downloads

Here's a short overview of the commands involved in getting Vagrant going. 

~~~bash
$ mkdir vagrant-test
$ vagrant init
$ vagrant box add precise64 http://files.vagrantup.com/precise64.box
~~~

Now create the directories and config files required for Puppet.

~~~bash
$ mkdir puppet; mkdir puppet/manifests; mkdir puppet/modules
$ touch puppet/manifests/appserver.pp; touch puppet/manifests/rvm.pp; touch puppet/manifests/users.pp
~~~

**Directory structure**
~~~
├── Vagrantfile
└── puppet
    ├── manifests
    │   ├── appserver.pp
    │   ├── rvm.pp
    │   ├── users.pp
    └── modules
~~~


**Vagrantfile**
~~~ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  # base box and URL where to get it if not present
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # make sure our apt sources are up to date...
  config.vm.provision :shell, :inline => "apt-get update --fix-missing"

  # config for the appserver box, same name as .pp file.
  config.vm.define "appserver" do |app|
    # do not show a VirtualBox window 
    app.vm.boot_mode = :headless
    #app.vm.network :hostonly, "66.66.66.10"
    # bridge the VM on the host's eth0 interface
    # if eth0 does not exist then Vagrant will 
    # prompt you to select an actual interface.
    app.vm.network :bridged, :bridge => "eth0"
    #Puppet gets grumpy if the hostname is not a FQDN...
    app.vm.host_name = "appserver00.local"

    app.vm.provision :puppet do |puppet|

      # change fqdn to give to change the vm virtual host
      puppet.facter = { 
        "fqdn" => "appserver00.local", 
      }

      puppet.module_path = "puppet/modules"
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "appserver.pp"
    end
  end

end
~~~

And now the Puppet config files:


**appserver.pp**
~~~ruby
#puppet essential... 
group { 'puppet': ensure => 'present' }

#global path def.
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] } 

class app {

  exec { "update_package_list":
    user    => "vagrant",
    command => "/usr/bin/sudo /usr/bin/apt-get update",
  }

  package {
    [ "ntp", "git-core" ] :
      ensure => present
  }

  rvm::install {
    #for user
    'edward' : ;
  }

}

require users
require rvm
require app
~~~

**rvm.pp**
~~~ruby
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
~~~

**users.pp**
~~~bash
class users {

  user { "edward":
    ensure 	=> "present",
    shell 	=> "/bin/bash",
    managehome 	=> true,
  }

}	
~~~

*NOW THE WONDERFUL ONE-LINER*
~~~bash
$ vagrant up
~~~

**A simple list of vagrant commands:**

`vagrant up <boxname>` start the given box. If the box has not been initialized and created, this will download the basebox as required, bootstrap it and run the provisioner. Running vagrant up when the box is already running is a NOOP and has no effect.

`vagrant halt <boxname>` stop the given box. Has no effect if the box is not running. May require an invocation using the --force flag (vagrant halt --force <boxname>) if the box crashed, locked up or cannot be accessed via vagrant ssh
vagrant reload <boxname> stop and start the given box. Runs the provisioner.

`vagrant provision <boxname>` Runs the provisioner.

`vagrant destroy <boxname>` destroys the given box. This is useful if for some reason the box has been damaged or to free diskspace. Running vagrant up after running vagrant destroy bootstraps a new box.

`vagrant ssh <boxname>` open an ssh connection to the given box.


#virtualbox #puppet #vagrant 
