# vagrant.dev

Configurable LAMP development stack for Vagrant. Kind of like MAMP or WAMP but auto configuring and virtualized!

Built using simple [Ansible provisioning](http://www.ansible.com/) that works on Windows by running entirely inside the VM!

## Installation

1. Install vagrant from [vagrantup.com](http://vagrantup.com/)
2. Download and Install VirtualBox from [virtualbox.org](http://www.virtualbox.org/)
3. Open a terminal and install the vagrant plugin that automatically updates VirtualBox guest additions in the VM.

    ```
    $ vagrant plugin install vagrant-vbguest
    ```

4. Clone this repository to a folder of your choice (I have it in my home folder ~/vagrant)
5. Change to the repository folder and start vagrant
     
    ```
    $ cd vagrant.dev
    $ vagrant up
    ```

6. Wait for vagrant to download, start and provision your virtual machine (a few minutes)
7. While waiting, add this row to your local machine's "hosts" file (Linux/Mac: "/etc/hosts")

    ```
    33.33.33.10 vagrant.dev
    ```

8. When the setup is done you can visit your local development host at http://vagrant.dev/
9. Any files you add to the folder sites/vagrant.dev/webroot/ will be visible at http://vagrant.dev/
10. Now you can configure your own sites, see the onfiguration section below. (TODO)

## What's inside

Installed software:

* Apache
* MySQL
* php
* phpMyAdmin
* ImageMagick
* memcache
* Xdebug
* git, subversion
* mc, vim, screen, tmux, curl
* [MailCatcher](http://mailcatcher.me/)
* [Drush](http://drupal.org/project/drush)

The vagrant machine is set to use IP 33.33.33.10 by default.

phpMyAdmin is available on every domain. For example:

* http://vagrant.dev/phpmyadmin

PHP is configured to send mail via MailCatcher. Web frontend of MailCatcher is running on port 1080 and also available on every domain:

* http://vagrant.dev:1080

Port 33066 is forwarded to MySql, with a default vagrant/vagrant user so you can use your favorite client to administer databases.

You can add XDEBUG\_PROFILE to your GET parameter to generate an xdebug trace, e.g. http://vagrant.dev/?XDEBUG\_PROFILE. You can then investigate at http://local.dev/webgrind/
