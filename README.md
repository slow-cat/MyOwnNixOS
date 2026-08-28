# おれおれNixOSの設定

今使ってるNixOSの設定

>[!WARNING]
>このリポジトリは個人用の NixOS 設定です。
>ユーザー名、Git の作者情報、ディスク UUID、ホスト固有設定を含みます。
>他の環境で利用する場合は、各自の値へ変更してください。

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
こちらはUEFI GPTで行う。

## To Do

1. firefoxのDownloadディレクトリが/tmpになっていない

1. bun codexはlatestにする

1. bubblewrap

1. swaylock多分有効化してない

1. 実機とうまくこのレポジトリどうきさせたい

1. erofsで持ってくるlatexの設定
  
1. フルシステム管理がどうであるか
