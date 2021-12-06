# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$run = <<"SCRIPT"
# Disk setup
if sudo sfdisk --list-free /dev/sda | grep Start
then
echo LVM extend to maximum size
START_SEKTOR=$(sfdisk --list-free /dev/sda | tail -n 1 | cut -d ' ' -f 1)
END_SEKTOR=$(sfdisk --list-free /dev/sda | tail -n 1 | cut -d ' ' -f 2)
fdisk /dev/sda << FDISK_CMDS
n
p

$START_SEKTOR

t
3
8e
w
FDISK_CMDS
vgextend rpibuilder-vg /dev/sda3
lvm lvextend -l +100%FREE /dev/rpibuilder-vg/root
resize2fs -p /dev/mapper/rpibuilder--vg-root
fi

echo ">>> Generating rpi image ... $@"
export DEBIAN_FRONTEND=noninteractive
export RPIGEN_DIR="${1:-/home/vagrant/rpi-gen}"
export APT_PROXY='http://127.0.0.1:3142'
echo "deb http://ftp.de.debian.org/debian buster main" | sudo tee /etc/apt/sources.list.d/qemu.list
apt-get update
apt-get install --yes coreutils quilt parted qemu-user-static debootstrap zerofree zip \
dosfstools libarchive-tools libcap2-bin grep rsync xz-utils file git curl bc \
qemu-utils kpartx

# Prepare without NOOBS
echo "Prepare rpi-gen into vagrant home"
rsync -a --delete --exclude 'backup' --exclude 'work' --exclude 'deploy' \
  --exclude 'EXPORT_NOOBS' /vagrant/  ${RPIGEN_DIR}/
cd ${RPIGEN_DIR}
echo "Clean up"
sudo ./clean.sh
# Build
echo "Build"
time sudo --preserve-env=APT_PROXY ./build-all.sh
# Copy images back to server
echo "Copy images into host machine"
[ -d deploy ] && rsync -av --checksum deploy /vagrant/
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  # Taken from https://github.com/gantsign/development-environment/blob/master/Vagrantfile
  required_plugins = %w[vagrant-disksize]
  plugins_to_install = required_plugins.reject { |plugin| Vagrant.has_plugin? plugin }
  unless plugins_to_install.empty?
    puts "Installing plugins: #{plugins_to_install.join(' ')}"
    if system "vagrant plugin install #{plugins_to_install.join(' ')}"
      exec "vagrant #{ARGV.join(' ')}"
    else
      abort 'Installation of one or more plugins has failed. Aborting.'
    end
  end

  config.vm.define :rpigen do |rpigen|
      # Every Vagrant virtual environment requires a box to build off of.
      #rpigen.vm.box = "ubuntu/xenial32"
      rpigen.vm.box = "jriguera/rpibuilder-buster-10.2-i386"
      rpigen.disksize.size = '60GB'
      # Create a forwarded port mapping which allows access to a specific port
      # within the machine from a port on the host machine. In the example below,
      # accessing "localhost:8080" will access port 80 on the guest machine.
      # ubuntu.vm.network "forwarded_port", guest: 80, host: 8080

      # Create a private network, which allows host-only access to the machine
      # using a specific IP.
      # ubuntu.vm.network "private_network", ip: "192.168.33.10"
      # rpigen.vm.network "private_network", ip: "192.168.50.58"

      # Create a public network, which generally matched to bridged network.
      # Bridged networks make the machine appear as another physical device on
      # your network.
      # ubuntu.vm.network "public_network"

      # Share an additional folder to the guest VM. The first argument is
      # the path on the host to the actual folder. The second argument is
      # the path on the guest to mount the folder. And the optional third
      # argument is a set of non-required options. (type: "rsync")
      #rpigen.vm.synced_folder ".", "/home/vagrant/rpi-gen", type: "virtualbox"

      rpigen.vm.provision "shell" do |s|
        s.inline = $run
        s.args = "#{ENV['WORK_DIR']}"
      end
  end
end
