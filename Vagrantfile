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

	# Set permissions for shared folder, otherwise all files might become executable which ansible doesn't like
	config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", owner: "vagrant", group: "vagrant", mount_options: ["dmode=775,fmode=664"]

	# Mount private keys folder with right permissions
	config.vm.synced_folder "./privatekeys", "/privatekeys", owner: "vagrant", group: "vagrant", mount_options: ["dmode=700,fmode=600"]

	#config.vm.synced_folder ".", "/vagrant",
	#  type: "rsync",
	#  rsync__auto: "true",
	#  rsync__exclude: [".git/","privatekeys/"],
	#  id: "vagrant-root"

	# If you want to share using NFS uncomment this line 
	# (30x faster performance on mac/linux hosts when using VirtualBox)
	# http://docs.vagrantup.com/v2/synced-folders/nfs.html
	#config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", :nfs => true
	
	# Set the hostname
	config.vm.hostname = "vagrant"

	# Create a private network, which allows host-only access to the machine using a specific IP.
	config.vm.network :private_network, ip: "33.33.33.10"

	# Save host OS for later use
	host = RbConfig::CONFIG['host_os']

	# VirtualBox specific configuration
	config.vm.provider :virtualbox do |v|

		# If you're having timeout errors or just want to see what the VM is up to, enable this
		#v.gui = true

		# If you want to give your VM more memory, change this line
		v.customize ["modifyvm", :id, "--memory", 1600]

		# Never set more than 1 cpu, it might heavily degrade performance
		v.customize ["modifyvm", :id, "--cpus", 1]

		# VirtualBox performance improvements
		# Found here: https://github.com/xforty/vagrant-drupal/blob/master/Vagrantfile
		v.customize ["modifyvm", :id, "--nictype1", "virtio"]
		v.customize ["modifyvm", :id, "--nictype2", "virtio"]
		v.customize ["storagectl", :id, "--name", "SATA Controller", "--hostiocache", "off"]

		# Give VM 1/4 system memory & access to all cpu cores on the host
#		if host =~ /darwin/
#			cpus = `sysctl -n hw.ncpu`.to_i
#			# sysctl returns Bytes and we need to convert to MB
#			mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
#		elsif host =~ /linux/
#			cpus = `nproc`.to_i
#			# meminfo shows KB and we need to convert to MB
#			mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
#		else # sorry Windows folks, I can't help you
#			cpus = 2
#			mem = 1024
#		end
#	  v.customize ["modifyvm", :id, "--memory", mem]
#	  v.customize ["modifyvm", :id, "--cpus", cpus]
	end

	#################################
	# Provisioners                  #
	#################################
	
	# Install initial requirements
	config.vm.provision :shell, path: "provision.sh"

	# Now with apache probably installed, remount /vagrant with apache group permission
  #config.vm.provision :shell, run: "always", :inline =>
  # "if [[ -f /etc/sysconfig/httpd && $(stat -c \"%G\" /vagrant) != \"apache\" ]]; then 
  # umount /vagrant && mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g apache`,dmode=775,fmode=664 vagrant-root /vagrant ; fi"
  # Only works with default shared folder

	if host =~ /darwin|linux/
		config.vm.provision :ansible do |ansible|
		    #ansible.verbose = true
		    #ansible.inventory_path = "ansible/hosts-vagrant"
		    ansible.playbook = "ansible/main.yml"
		    ansible.groups = {
					  "webservers" => ["default"],
					  "dbservers" => ["default"]
					}
				ansible.extra_vars = {
					server_environment: "local",
				}
		end
	else # Windows
		# Run ansible provision on virtual host
  	config.vm.provision :shell, :inline =>
   		"export PYTHONUNBUFFERED=1; ansible-playbook /vagrant/ansible/main.yml --inventory-file=/vagrant/ansible/hosts-local --user=vagrant"
	end



end
