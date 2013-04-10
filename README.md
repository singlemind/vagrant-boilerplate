vagrant-boilerplate
===================

VAGRANT SETUP WITH PUPPET AND RVM

Here's a quick start guide for using Vagrant to quickly bootstrap a VirtualBox virtual machine with and Puppet and RVM! 
<cut>

CHECK OUT THE GISTFLOW: http://gistflow.com/posts/777-vagrant-setup-with-puppet-and-rvm

Download & install Vagrant (currently using Vagrant v1.1.4): http://downloads.vagrantup.com/tags/v1.1.4

Download & install virtual box: https://www.virtualbox.org/wiki/Downloads

Here's a short overview of the commands involved in getting Vagrant going. 

~~~bash
$ vagrant box add precise64 http://files.vagrantup.com/precise64.box
$ git clone git://github.com/singlemind/vagrant-boilerplate.git
~~~


**Directory structure should look like this:**
~~~
├── Vagrantfile
└── puppet
    ├── manifests
    │   ├── appserver.pp
    │   ├── rvm.pp
    │   ├── users.pp
    └── modules
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

