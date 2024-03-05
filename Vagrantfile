Vagrant.configure("2") do |config|

  config.vm.define "server" do |server|
    config.vm.box = 'centos'
    config.ssh.insert_key = 'false'
    server.vm.host_name = 'server'
    server.vm.network :private_network, ip: "192.168.56.101" 
    server.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
      vb.cpus = 2
    end
  
    server.vm.provision "shell",
      path: "subtask1.sh"
  
    server.vm.provision "shell",
      path: "subtask2.sh"

    server.vm.provision "shell",
      path: "subtask3.sh"
  
    end
  
  
  end