Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.box_version = "20240821.0.1"
  config.vm.provider "virtualbox" do |vb|
    vb.name = "task2"
    vb.gui = false
    vb.memory = "2048"
    vb.cpus = 1
  end
  config.vm.hostname = "task2"
  config.vm.provision "shell", path: "./src/task2.sh"
end