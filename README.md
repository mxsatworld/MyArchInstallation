# My Arch Installation
## Steps
1. Download the iso file and the signature to verify it, download it from torrent in my case
    + https://archlinux.org/download/
    + sha256sums.txt
    + b2sums.txt
    + archlinux-2024.08.01-x86_64.iso.sig
2. get the pgp key of pierre@archlinux.org in keys.openpgp.org and other key servers to double or triple check, see if the fingerprint matches and add it to your favorite pgp manager (gpa in my case)
NOTE!!!: TO VERIFY THE ISO IMAGE IT MUST BE FULLY DOWNLOADED
    + https://pierre-schmitz.com/gpg-keys/
    + Key uid         = Pierre Schmitz <pierre@archlinux.org>
    + Key id          = 76A5EF9054449A5C
    + Key fingerprint = 3E80 CA1A 8B89 F69C BA57  D98A 76A5 EF90 5444 9A5C
3. import and sign the pierre key, you need to make your own pgp key to do this
4. edit sha256sums.txt and b2sums.txt to only leave the sum that suits you (they give you 3 options)
    + vim sha256sums.txt
    + vim b2sums.txt
5. then run these commands to check everything is ok
    + sha256sum -c sha256sums.txt
    + b2sum -c b2sums.txt
    + gpg --keyserver-options auto-key-retrieve --verify archlinux-2024.08.01-x86_64.iso.sig
6. burn the ISO to a usb and boot it
    + lsblk (to see the name of the usb)
    + sudo dd if=archlinux-2024.08.01-x86_64.iso of=/dev/sde bs=16M oflag=direct status=progress
7. Once booted see available keymaps with the first command and use the second to set it
    + localectl list-keymaps
    + loadkeys <keymap>
8. connect to the internet (im using my cellphone because arch doesnt recognize my wifi cards)
timedatectl set-timezone America/Argentina/Buenos_Aires
cfdisk 
EFI 512MB
SWAPON 16GB
ROOT
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
mkfs.fat -F 32 /dev/sda1
mount /dev/sda3 /mnt
mount --mkdir /dev/sda1 /mnt/boot
swapon /dev/sda2
reflector --download-timeout 60 --country Argentina,Brazil,Chile --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
pacstrap -K /mnt base linux linux-firmware

## Sources
1. archlinux.org
2. wiki.archlinux.org
3. keys.openpgp.org
4. https://www.youtube.com/watch?v=hPHW0y6RAZA&t=479s
5. https://www.wikihow.com/Verify-a-PGP-Signature
6. https://wiki.archlinux.org/title/Installation_guide 
7. https://www.youtube.com/watch?v=u5Lv_HXICpo (for how to verify iso OS)
8. https://keybase.io
9. https://keys.openpgp.org
10. https://keyserver.ubuntu.com
11. http://keys.gnupg.net
12. https://pgp.mit.edu
13. https://keyoxide.org