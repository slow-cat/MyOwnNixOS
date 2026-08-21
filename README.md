# おれおれNixOSの設定

授業で作成したNixOSの設定用レポジトリ

## Qemuでのテスト

以下のコマンドで可変長の仮想イメージを作成

```bash
qemu-img create -f qcow2 nix 20G
```

次にnixosのisoを準備してQemuの中に入る

```bash
# Qemuの内部 レガシーで行う
sudo umount -R /mnt
sudo parted /dev/sda --mktable msdos
sudo parted /dev/sda --mkpart primary ext4 1MiB 100%
sudo mkfs.ext4 -L nixos /dev/sda1
sudo mount /dev/disk/by-label/nixos /mnt
sudo nixos-generate-config --root /mnt
# ここらへんで/mnt/nixosに設定をコピーする。
# Qemu内部でクローンしてもいいかもしれない
sudo nixos-install
```

<!-- Makefileでイメージ作ってSSHまで立ち上げるのは難しかったので -->

## 実機

気が向いたら追記がされる
