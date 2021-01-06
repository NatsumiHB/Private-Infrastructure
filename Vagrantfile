Vagrant.configure("2") do |config|
  config.vm.box               = "natsuwumi/ubuntu-20.04"

  config.vm.provider            "hyperv"
  config.vm.network             "public_network"

  config.vm.provider "hyperv" do |hyperv|
    hyperv.linked_clone       = true
    hyperv.memory             = 4096
    hyperv.cpus               = 4
  end

  config.vm.synced_folder ".", "/vagrant", disabled: false

  config.vm.define "private-infra", primary: true do |machine|
    machine.vm.hostname       = "private-infra-vm"

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
