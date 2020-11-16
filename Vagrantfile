$update_script = <<-SHELL
  sudo apt-get update
  sudo apt-get dist-upgrade -y
  sudo apt-get autoremove -y
SHELL

Vagrant.configure("2") do |config|
  config.vm.box               = "bento/ubuntu-20.04"

  config.vm.provider            "hyperv"
  config.vm.network             "public_network"

  config.vm.provider "hyperv" do |hyperv|
    hyperv.linked_clone       = true
    hyperv.memory             = 4096
    hyperv.cpus               = 4
  end

  # Disable shared folders (Since we copy ansible files manually later)
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Disable Vagrant inserting a key automatically
  config.ssh.insert_key = false

  # Define provision for updates
  config.vm.provision "shell" do |shell|
    shell.privileged        = true
    shell.inline            = $update_script
    #shell.reboot            = true
  end

  config.vm.define "worker" do |machine|
    machine.vm.hostname       = "worker-vm"    
  end

  config.vm.define "controller", primary: true do |machine|
    machine.vm.hostname       = "controller-vm"

    # Create vagrant folder and copy required files into guest FS
    machine.vm.provision "shell",
      inline: <<-SHELL
        sudo mkdir -p /vagrant
      SHELL

    machine.vm.provision "file",
      source: "ansible.cfg",
      destination: "/tmp/vagrant/ansible.cfg"
    machine.vm.provision "file",
      source: "install_infra.yml",
      destination: "/tmp/vagrant/install_infra.yml"
    machine.vm.provision "file",
      source: "inventory",
      destination: "/tmp/vagrant/inventory"
    machine.vm.provision "file",
      source: "nginx",
      destination: "/tmp/vagrant/nginx"

    machine.vm.provision "shell",
      inline: "rm -rf /vagrant/* && mv /tmp/vagrant/* /vagrant"
    
    # Install sshpass and create an SSH key for ansible
    machine.vm.provision "shell",
      inline: "sudo apt-get install sshpass"
    
    $set_up_ssh = <<-SHELL
      mkdir -p ~/.ssh

      ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -P ""
      eval $(ssh-agent -s)
      ssh-add ~/.ssh/id_rsa
      sshpass -p "vagrant" ssh-copy-id -f -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no worker-vm
    SHELL

    machine.vm.provision "shell",
      inline: $set_up_ssh,
      privileged: false

    # Install ansible via pip and run ansible playbook
    machine.vm.provision "ansible_local" do |ansible|
      ansible.install_mode    = :pip
      ansible.playbook        = "install_infra.yml"
      ansible.become          = true
      ansible.install         = true
      ansible.limit           = "all"
      ansible.inventory_path  = "inventory"
      ansible.config_file     = "ansible.cfg"
    end
  end
end
