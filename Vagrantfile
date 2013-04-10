# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  # base box and URL where to get it if not present
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # make sure our apt sources are up to date...
  config.vm.provision :shell, :inline => "apt-get update --fix-missing"

  # config for the appserver box
  config.vm.define "appserver" do |app|
    # do not show a VirtualBox window 
    app.vm.boot_mode = :headless
    #app.vm.network :hostonly, "66.66.66.10"
    # bridge the VM on the host's eth0 interface
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
