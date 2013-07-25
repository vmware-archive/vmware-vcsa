# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  config.vm.define :vcsa do |vcsa|
    vcsa.vm.box = 'vcsa_51'
    vcsa.vm.box_url = 'https://dl.dropbox.com/u/1075709/box/vcsa_51.box'
    vcsa.ssh.username = 'root'

    # TODO: This should disable shared folders.
    vcsa.vm.synced_folder '.', '/vagrant', :id => 'vagrant-root', :disabled => true

    vcsa.vm.provider :vmware_fusion do |v|
      v.vmx['displayname'] = 'vCenter.lab'
    end
  end

  config.vm.define :vshield do |vshield|
    vshield.vm.box = 'vshield_51'
    vshield.vm.box_url = 'https://dl.dropbox.com/u/1075709/box/vshield_51.box'
    vshield.ssh.username = 'root'

    # TODO: This should disable shared folders.
    vshield.vm.synced_folder '.', '/vagrant', id: 'vagrant-root', disabled: true

    vshield.vm.provider :vmware_fusion do |v|
      v.vmx['displayname'] = 'vShield.lab'
    end
  end

  # Currently does not support more than 1 due to generated address issue:
  (1..4).each do |i|
    config.vm.define "esx_#{i}" do |esx|
      esx.vm.box = 'esx_51'
      esx.vm.box_url = 'https://dl.dropbox.com/u/1075709/box/esx_51.box'
      esx.ssh.username = 'root'

      esx.vm.synced_folder '.', '/vagrant', :id => 'vagrant-root', :disabled => true

      esx.vm.base_mac = '00:0c:29:60:83:07'
      esx.vm.provider :vmware_fusion do |v|
        v.vmx['displayName'] = "esx_#{i}.lab"
        v.vmx['virtualHW.version'] = 9
        v.vmx['ethernet0.virtualDev'] = 'e1000'
        v.vmx['ethernet0.wakeOnPcktRcv'] = 'FALSE'
        v.vmx['ethernet0.linkStatePropagation.enable'] = 'FALSE'
        v.vmx['ethernet0.generatedAddress'] = '00:0c:29:60:83:07'
        # Appears unecessary:
        #v.vmx['ethernet0.vnet'] = 'vmnet2'
        #v.vmx['ethernet0.bsdName'] = 'en0'
        #v.vmx['ethernet0.displayName'] = 'Ethernet'
      end
    end
  end

  config.vm.define :management do |m|
    m.vm.box = 'centos63'
    m.vm.box_url = 'https://dl.dropbox.com/s/eqdrqnla4na8qax/centos63.box'

    m.vm.provider :vmware_fusion do |v|
      v.vmx['displayName'] = 'vAPI.lab'
    end

    m.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'manifests'
      puppet.module_path    = 'modules'
      puppet.manifest_file  = 'site.pp'
    end
  end
end
