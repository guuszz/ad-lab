# frozen_string_literal: true

Vagrant.configure("2") do |config|
  config.vm.box_check_update = false

  config.vm.define "dc01" do |dc|
    dc.vm.box = "gusztavvargadr/windows-server-2022-standard"
    dc.vm.hostname = "DC01"
    dc.vm.network "private_network", ip: "192.168.56.10"
    dc.vm.provider "virtualbox" do |vb|
      vb.name = "AD-Lab-DC01"
      vb.memory = 4096
      vb.cpus = 2
    end
  end

  [
    ["ws01", "gusztavvargadr/windows-10", "WS01", "192.168.56.20"],
    ["ws02", "gusztavargadr/windows-10", "WS02", "192.168.56.21"]
  ].each do |name, box, hostname, ip|
    config.vm.define name do |vm|
      vm.vm.box = box
      vm.vm.hostname = hostname
      vm.vm.network "private_network", ip: ip
      vm.vm.provider "virtualbox" do |vb|
        vb.name = "AD-Lab-#{hostname}"
        vb.memory = 4096
        vb.cpus = 2
      end
    end
  end

  config.vm.define "kali" do |kali|
    kali.vm.box = "kalilinux/rolling"
    kali.vm.hostname = "KALI"
    kali.vm.network "private_network", ip: "192.168.56.100"
    kali.vm.provider "virtualbox" do |vb|
      vb.name = "AD-Lab-KALI"
      vb.memory = 4096
      vb.cpus = 2
    end
  end
end
