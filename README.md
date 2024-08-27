# My Arch Installation
## Objetive
Make a good performance system, thats why i selected the zen kernel and the i3 window manager, i tried to install as less packages as possible
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
7. connect to the internet (im using my cellphone because arch doesnt recognize my wifi card)
8. timedatectl set-timezone America/Argentina/Buenos_Aires
9. cfdisk 
    + EFI 512MB
    + SWAPON 16GB
    + ROOT
10. cryptsetup -y -v luksFormat --pbkdf pbkdf2 /dev/sda3
11. cryptsetup open /dev/sda3 root
12. mkfs.ext4 /dev/mapper/root
13. mkswap /dev/sda2
14. mkfs.fat -F 32 /dev/sda1
15. mount /dev/mapper/root /mnt
16. mkdir /mnt/boot
17. mkdir /mnt/boot/efi
18. mount /dev/sda1 /mnt/boot/efi
19. swapon /dev/sda2
20. reflector --download-timeout 60 --country Argentina,Brazil,Chile --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
21. pacstrap -K /mnt base linux-zen linux-firmware ntfs-3g vim networkmanager base-devel sudo linux-zen-headers
22. genfstab -U /mnt >> /mnt/etc/fstab 
    + vim /mnt/etc/fstab
    + (check if it generated correctly)
23. arch-chroot /mnt
24. ln -sf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime
25. hwclock --systohc
26. vim /etc/locale.gen
27. locale-gen 
28. vim /etc/hosts
    + 127.0.0.1        localhost
    + ::1              localhost
    + 127.0.1.1        hp-elitebook-745-g2
29. vim /etc/hostname 
    + hp-elitebook-745-g2
30. vim /etc/locale.conf  
    + LANG=en_US.UTF-8
31. systemctl enable NetworkManager
32. passwd
33. useradd -m -G wheel mxsatworld
34. passwd mxsatworld
35. vim /etc/sudoers 
    + uncomment
    + %wheel ALL=(ALL) ALL
36. pacman -S amd-ucode grub efibootmgr xf86-video-amdgpu
37. add key to unlock disk when boot is unlocked 
    + dd bs=512 count=4 if=/dev/random of=/root/cryptlvm.keyfile iflag=fullblock
    + chmod 000 /root/cryptlvm.keyfile
    + cryptsetup -v luksAddKey /dev/sda3 /root/cryptlvm.keyfile
38. vim /etc/mkinitcpio.conf 
    + after the autodetect hook put "keyboard keymap" hooks 
    + before filesystems hook put encrypt hook
    + FILES=(/root/cryptlvm.keyfile) 
39. chmod 600 /boot/initramfs-linux* 
40. mkinitcpio -p linux-zen 
41. blkid >> uuid
    + copy UUID of /dev/sda3 
42. vim uuid 
43. rm uuid
44. vim /etc/default/grub 
    + enable cryptodisk 
    + GRUB_CMDLINE_LINUX="cryptdevice=UUID=<copypasted uuid>:root root=/dev/mapper/root cryptkey=rootfs:/root/cryptlvm.keyfile" 
45. grub-install --target=x86_64-efi --bootloader-id=grub --efi-directory=/boot/efi
46. grub-mkconfig -o /boot/grub/grub.cfg 
47. exit
48. umount -a
49. reboot   
50. change bios path \EFI\grub\grubx64.efi (F9 boot from EFI file)
51. sudo pacman -S broadcom-wl-dkms git
    + clone this repo so i can use the config files
    + reboot 
52. sudo pacman -S xorg xorg-xinit i3 xfce4-terminal firefox dmenu keepassxc alsa-utils pulseaudio htop brightnessctl xclip maim libreoffice lxappearance arc-gtk-theme bluez bluez-utils pulseaudio-bluetooth cups cups-pdf usbutils openssh hplip xss-lock
53. alsamixer
    + unmute all channels    
54. sudo vim /etc/modules-load.d/snd-pcm-oss.conf
    + #sound module
    + snd-pcm-oss
55. sudo vim /etc/modules-load.d/btusb.conf
    + #bluetooth module
    + btusb
    + #bluetooth module, remember to trust devices before connect 
56. sudo vim /etc/systemd/logind.conf
    + HandleLidSwitch=lock
57. systemctl enable bluetooth
58. systemctl enable cups.service
59. config printer with http://localhost:631/admin 
60. ssh-keygen -t rsa -b 4096 -C "mcuadrado578@gmail.com"
    + add public key to github
## Sources
1. archlinux.org
2. wiki.archlinux.org
    + installation guide
    + CUPS
3. keys.openpgp.org
4. https://www.youtube.com/watch?v=hPHW0y6RAZA&t=479s
5. https://www.wikihow.com/Verify-a-PGP-Signature
6. https://www.youtube.com/watch?v=u5Lv_HXICpo (for how to verify iso OS)
7. https://keybase.io
8. https://keys.openpgp.org
9. https://keyserver.ubuntu.com
10. http://keys.gnupg.net
11. https://pgp.mit.edu
12. https://keyoxide.org
13. https://www.youtube.com/watch?v=XNJ4oKla8B0 
14. https://www.freecodecamp.org/news/how-to-install-arch-linux/
15. github
    + https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
