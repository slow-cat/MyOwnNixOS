#音声やグラフィック関連のQEMUパッケ不足で動かない可能せいあり
IMAGE := "./nix.qcow2"
QEMU_BASE := \
	-enable-kvm \
	-boot order=d \
	-m 4G \
	-vga none
QEMU_AUDIO := \
	-audiodev pipewire,id=snd0 \
	-device intel-hda \
	-device hda-duplex,audiodev=snd0
QEMU_DISK := \
	-drive file=$(IMAGE),format=qcow2
QEMU_SHARE := \
	-virtfs local,path="./nixos",mount_tag=nixos,security_model=mapped-xattr,id=nixos
QEMU_SSH := \
	-nic user,hostfwd=tcp::60022-:22
QEMU_OPTS_NODISPLAY := \
	-serial mon:stdio \
	$(QEMU_BASE) $(QEMU_AUDIO) $(QEMU_DISK) $(QEMU_SHARE) $(QEMU_SSH) -display none
QEMU_OPTS_GTK := \
	-serial mon:stdio \
	$(QEMU_BASE) $(QEMU_AUDIO) $(QEMU_DISK) $(QEMU_SHARE) $(QEMU_SSH) -device virtio-vga-gl -display gtk,gl=on
QEMU_OPTS_SSH := \
	-monitor none \
	$(QEMU_BASE) $(QEMU_AUDIO) $(QEMU_DISK) $(QEMU_SHARE) $(QEMU_SSH) -display none
	
.PHONY: help nogui gui img

help:
	@echo -e "make img :\tIt creates only an empty qcow2 file. \n\t\tYou still need to format it and install nixos, \n\t\tsetting up SSH and the shared-folder mounted at /etc/nixos."
	@echo -e "make nogui :\tIt boots installed nixos with nogui. \n\t\tIf SSH is set up, you can use 'ssh -p 60022 moamoa@localhost'."
	@echo -e "make gui :\tIt"
nogui:
	qemu-system-x86_64 $(QEMU_OPTS_NODISPLAY)
ssh:
	qemu-system-x86_64 $(QEMU_OPTS_SSH)>/dev/null 2>&1 &
	sleep 1
	ssh -o ConnectTimeout=20 -p 60022 moamoa@localhost
gui:
	qemu-system-x86_64 $(QEMU_OPTS_GTK)
$(IMAGE):
	qemu-img create -f qcow2 nix 20G
	# qemu-system-x86_64 -boot order=d \
	# 	-drive file=nix.qcow2,format=qcow2 -m 4G \
	# 	-enable-kvm -nographic -serial mon:stdio \
	# 	-audiodev pipewire,id=snd0 -device intel-hda,hda-duplex,audiodev=snd0 \
	# 	-virtfs local,path="./nixos",mount_tag=nixos,security_model=mapped-xattr,id=nixos \
	# 	# -nic user,hostfwd=tcp::60022-:22
	# qemu-system-x86_64 -boot order=d -drive file=nix,format=raw -cdrom nixos-minimal-26.05.4193.a50de1b7d8a5-x86_64-linux.iso -m 4G -enable-kvm -nographic -serial mon:stdio
	# 自動化はきつい
	# latex からコピペでもってきたのでハイフンユニコードおかしいかも
	# パーティション関連
	# sudo umount -R /mnt
	# sudo parted /dev/sda --mktable msdos
	# sudo parted /dev/sda --mkpart primary ext4 1MiB 100%
	# sudo mkfs.ext4 -L nixos /dev/sda1
	# sudo mount /dev/disk/by-label/nixos /mnt
	# どうせこいつ依存に加えても解決はコマンドじゃきつそうやし加えない
	# 作り方でも書こうか
img: $(IMAGE)
	
