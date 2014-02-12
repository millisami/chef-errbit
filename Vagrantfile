
Vagrant.configure("2") do |config|

  config.vm.hostname = "errbit-berkshelf"
  config.vm.box = "Opscode-12-04"
  config.vm.network :private_network, ip: "33.33.33.10"

  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.

  # config.vm.network :public_network

  # cache_dir = local_cache(config.vm.box)
  # config.vm.synced_folder "v-cache", "/var/cache/apt/archives/", cache_dir

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.network :forwarded_port, guest: 80, host: 8080

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  # Peepcode chef
  #config.vm.share_folder "v-cookbooks", "/cookbooks", "."

  config.omnibus.chef_version = :latest
  config.vm.boot_timeout = 120

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      :mysql => {
        :server_root_password => 'rootpass',
        :server_debian_password => 'debpass',
        :server_repl_password => 'replpass'
      }
    }

    chef.run_list = [
      'recipe[errbit::install_ruby]',
      'recipe[nginx]',
      'recipe[errbit::default]',
      'recipe[errbit::bootstrap]'
    ]
  end
end
