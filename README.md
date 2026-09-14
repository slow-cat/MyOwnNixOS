# おれおれNixOSの設定

今使ってるNixOSの設定

>[!WARNING]
>このリポジトリは個人用の NixOS 設定です。
>ユーザー名やGitのメールアドレス設定、firefoxの拡張など個人的なものが多く含まれます。

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

<!-- 1. firefoxのDownloadディレクトリが/tmpになっていない -->

<!-- 1. bun codexはlatestにする -->

<!-- 1. bubblewrap -->

<!-- 1. swaylock多分有効化してない -->

<!-- 1. 実機とうまくこのレポジトリどうきさせたい -->

<!-- 1. erofsで持ってくるlatexの設定 -->
  
<!-- 1. フルシステム管理がどうであるか -->

1. 環境変数はログアウトしないと行けないのであんまその体制は好みでない
<!-- 1. パッケージ管理がゴチャついてる -->
1. nix repl で最終評価を確認しながらしないと
1. これ外部でこのzshとかそこら辺の設定を使いたいなあ
設定部分との分離が必要になりそう めんどそう
1. うまーく構造で管理かな
