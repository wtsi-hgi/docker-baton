# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = "docker-baton"
  config.vm.box_check_update = false
  config.ssh.insert_key = false

  config.vm.box = "ubuntu/trusty64"
  config.vm.provision "docker"
  config.vm.provision "shell", inline: "apt-get install git"
  config.vm.provision "shell", path: "scripts/install-testing-framework.sh", args: "/usr/local"

  config.vm.synced_folder ".", "/docker-baton"
end
