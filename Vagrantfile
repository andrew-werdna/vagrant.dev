# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	# All Vagrant configuration is done here. The most common configuration
	# options are documented and commented below. For a complete reference,
	# please see the online documentation at vagrantup.com.

	############
	# Base box #
	############

	# Every Vagrant virtual environment requires a box to build off of.
	# The url is from where the 'config.vm.box' box will be fetched if it
	# doesn't already exist on the user's system.

	# This must be a Centos 6 box for the setup to work
	config.vm.box = "centos64"
	config.vm.box_url = "https://dl.dropboxusercontent.com/u/383013/centos64-x86-64-mini.box"

	####################
	# Vm configuration #
	####################

	# Forward MySql port on 33066, used for connecting admin-clients to localhost:33066
	config.vm.network :forwarded_port, guest: 3306, host: 33066

	# Set permissions for apache on shared project folder
	#config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", owner: "vagrant", group: "vagrant", mount_options: ["dmode=775,fmode=664"]

	# If you want to share using NFS uncomment this line 
	# (30x faster performance on mac/linux hosts when using VirtualBox)
	# http://docs.vagrantup.com/v2/synced-folders/nfs.html
	#config.vm.synced_folder ".", "/vagrant", :nfs => true
	
	# Set the hostname
	config.vm.hostname = "vagrant"

	# Create a private network, which allows host-only access to the machine
	# using a specific IP.
	config.vm.network :private_network, ip: "33.33.33.10"

	# VirtualBox specific configuration
	config.vm.provider :virtualbox do |v|

		# If you're having timeout errors or just want to see what the VM is up to, enable this
		#v.gui = true

		v.customize ["modifyvm", :id, "--cpus", 1] # Never set more than 1 cpu, degrades performance
		v.customize ["modifyvm", :id, "--memory", 1024]

		# VirtualBox performance improvements
		# Found here: https://github.com/xforty/vagrant-drupal/blob/master/Vagrantfile
		v.customize ["modifyvm", :id, "--nictype1", "virtio"]
		v.customize ["modifyvm", :id, "--nictype2", "virtio"]
		v.customize ["storagectl", :id, "--name", "SATA Controller", "--hostiocache", "off"]
	end

	#################################
	# Provisioners                  #
	#################################
	
	# Install requirements
	config.vm.provision :shell, path: "provision.sh"
  
  # Run ansible on virtual host
  config.vm.provision :shell, :inline =>
   "export PYTHONUNBUFFERED=1; ansible-playbook /vagrant/ansible/main.yml --inventory-file=/vagrant/ansible/hosts-local --user=vagrant"

   # Now with apache probably installed, remount /vagrant with apache group permission
  config.vm.provision :shell, run: "always", :inline =>
   "if [[ -f /etc/sysconfig/httpd ]]; then umount /vagrant && mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g apache`,dmode=775,fmode=664 vagrant-root /vagrant ; fi"

  #config.vm.provision :ansible do |ansible|
  #    ansible.verbose = true
  #    ansible.inventory_path = "ansible/hosts-local"
  #    ansible.playbook = "ansible/main.yml"
  #end

end
