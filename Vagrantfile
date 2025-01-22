Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.box_version = "20240821.0.1"

  num_workers = 2
  
  vm_memory = 2048
  vm_cpu = 1

  manager_ip = "192.168.100.100"

  config.vm.define "manager01" do |manager|
    manager.vm.hostname = "manager01"
    manager.vm.network "private_network", ip: manager_ip
    
    manager.vm.provider "virtualbox" do |vb|
      vb.name = "manager01"
      vb.gui = false
      vb.memory = vm_memory
      vb.cpus = vm_cpu
    end

    manager.vm.provision "shell", inline: <<-SHELL
      /vagrant/src/task3_manager.sh #{manager_ip}
    SHELL
  end

  (1..num_workers).each do |i|
    worker_ip = "192.168.100.#{100 + i}"
    config.vm.define "worker0#{i}" do |worker|
      worker.vm.hostname = "worker0#{i}"
      worker.vm.network "private_network", ip: worker_ip
      
      worker.vm.provider "virtualbox" do |vb|
        vb.name = "worker0#{i}"
        vb.gui = false
        vb.memory = vm_memory
        vb.cpus = vm_cpu
      end

      worker.vm.provision "shell", inline: <<-SHELL
        /vagrant/src/task3_worker.sh #{manager_ip}
      SHELL
    end
  end
end
