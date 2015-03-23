# vagrant.dev

Configurable LAMP development stack for Vagrant. Kind of like MAMP or WAMP but auto configuring and virtualized.

Built using the simple [Ansible provisioning](http://www.ansible.com/) that works on Windows by running it entirely inside the VM. Ansible is usually run on your local machine so it can manage multiple servers at once. The only downside to running it on the VM is that you don't get coloured output, and when an error happens the output can get a bit messy since its run through a bash script.

## Installation

1. Install vagrant from [vagrantup.com](http://vagrantup.com/)
2. Download and Install VirtualBox from [virtualbox.org](http://www.virtualbox.org/)
3. Open a terminal and install the vagrant plugin that automatically updates VirtualBox guest additions in the VM.

    ```
    $ vagrant plugin install vagrant-vbguest
    ```

4. Clone this repository to a folder of your choice (I have it in my home folder ~/vagrant)
5. Change to the repository folder and start vagrant (make sure you have enough free RAM, VM is set to use 1600 MB by default)
     
    ```
    $ cd vagrant.dev
    $ vagrant up provider=virtualbox
    ```

6. Wait for vagrant to download, start and provision your virtual machine (a few minutes)
7. While waiting, add this row to your local machine's "hosts" file (Linux/Mac: "/etc/hosts")

    ```
    33.33.33.10 vagrant.dev
    ```

8. When the setup is done you can visit your local development host at http://vagrant.dev/
9. Any files you add to the folder sites/vagrant.dev/webroot/ will be visible at http://vagrant.dev/
10. Now you can configure your own sites, see the configuration section below.

## What's inside

Installed software:

* Apache
* MySQL
* php
* phpMyAdmin
* ImageMagick
* memcache
* Xdebug
* git
* mc, vim, screen, tmux, curl
* [MailCatcher](http://mailcatcher.me/)
* [Drush](http://drupal.org/project/drush)

The vagrant machine is set to use IP 33.33.33.10 and 1600 MB RAM by default. 

phpMyAdmin is available on every domain. For example:

* http://vagrant.dev/phpmyadmin

PHP is configured to send mail via MailCatcher. Web frontend of MailCatcher is running on port 1080 and also available on every domain:

* http://vagrant.dev:1080

Port 33066 is forwarded to MySql, with a default vagrant/vagrant user so you can use your favorite client to administer databases.

## Sites configuration

Site configurations are set in the file ```ansible/vars-sites.yml```. These configs automatically set up apache virtual hosts and databases. They can also import databases and rsync uploaded files from a remote server. See examples below.

Whenever you need to apply new configurations all you need to do is run the provisioning again.

    $ vagrant provision

Put your code for the site in the "sites" folder, within a folder named as the "host" in your config.

Also remember to add your new site hosts to your local machine's hosts file.

    33.33.33.10 vagrant.dev project.dev project2.dev


### Standard site

Put your web app in the folder ```sites/local.dev/webroot/``` for this site configuration to work.

```yaml
sites:
- id: local
  host: local.dev
  webroot: webroot
  database:
  - no: no
  rsync:
  - no: no
```

### Site with database

Put your web app in the folder ```sites/database.dev/``` for this site configuration to work.

```yaml
sites:
- id: database
  host: database.dev
  webroot: webroot
  database:
  - db_name: my_db
    db_user: my_db
    db_pass: my_db
```

### Automatically copy database from remote server

For this config to work you need an SSH account on a remote server and a MySQL account. For the SSH account you must have Public Key Authentication set up and your private key file needs to exist in the root vagrant directory. All settings under "db_copy" are required.

I use a single private key file without a passphrase for all the servers I need to sync databases and files from. This is a separate private key from the one I usually use, since it has no passphrase it is best to use it only for syncing from development and testing servers. Read more about public and private keys at [help.ubuntu.com](https://help.ubuntu.com/community/SSH/OpenSSH/Keys).

```yaml
sites:
- id: copy
  host: copy.dev
  webroot: webroot
  database:
  - db_name: my_copy
    db_user: my_copy
    db_pass: my_copy
    db_copy:
      ssh_host: copy.example.com
      ssh_user: vagrant
      ssh_private_key: vagrant_id_rsa
      mysql_host: localhost
      mysql_user: root
      mysql_pass: pass
      remote_database: data
```

### Automatically copy uploaded files

Here we expand on the config above to also copy uploaded files for a drupal project. This is done using rsync and ssh connections.

The way rsync works, the first time you run this provision it will copy all files, the next time will be faster since it only copies new and changed files.

```yaml
sites:
- id: rsync
  host: rsync.dev
  webroot: webroot
  database:
  - db_name: my_rsync
    db_user: my_rsync
    db_pass: my_rsync
    db_copy:
      ssh_host: rsync.example.com
      ssh_user: vagrant
      ssh_private_key: vagrant_id_rsa
      mysql_host: localhost
      mysql_user: root
      mysql_pass: pass
      remote_database: data
  rsync:
  - ssh_host: rsync.example.com
    ssh_user: vagrant
    ssh_private_key: vagrant_id_rsa
    remote_source_path: /opt/deploy/project/webroot/sites/default/files/
    local_target_path: sites/default/files/
```


## Troubleshooting

Problems with empty responses on redirects? It might be XDebug, try turning off your current debug session.