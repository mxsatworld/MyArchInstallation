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
8. connect to the internet (im using my cellphone because arch doesnt recognize my wifi card)
9. timedatectl set-timezone America/Argentina/Buenos_Aires
10. cfdisk 
    + EFI 512MB
    + SWAPON 16GB
    + ROOT
11. cryptsetup -y -v luksFormat --pbkdf pbkdf2 /dev/sda3
12. cryptsetup open /dev/sda3 root
13. mkfs.ext4 /dev/mapper/root
14. mkswap /dev/sda2
15. mkfs.fat -F 32 /dev/sda1
16. mount /dev/mapper/root /mnt
17. mkdir /mnt/boot
18. mkdir /mnt/boot/efi
19. mount /dev/sda1 /mnt/boot/efi
20. swapon /dev/sda2
21. reflector --download-timeout 60 --country Argentina,Brazil,Chile --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
22. pacstrap -K /mnt base linux-zen linux-firmware ntfs-3g vim networkmanager base-devel sudo linux-zen-headers
23. genfstab -U /mnt >> /mnt/etc/fstab 
    +vim /mnt/etc/fstab
    +(check if it generated correctly)
24. arch-chroot /mnt
25. ln -sf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime
26. hwclock --systohc
27. vim /etc/locale.gen
28. locale-gen 
29. vim /etc/hosts
    + 127.0.0.1        localhost
    + ::1              localhost
    + 127.0.1.1        hp-elitebook-745-g2
30. vim /etc/hostname 
    + hp-elitebook-745-g2
31. vim /etc/locale.conf  
    +LANG=en_US.UTF-8
32. systemctl enable NetworkManager
33. passwd
34. useradd -m -G wheel mxsatworld
35. passwd mxsatworld
36. vim /etc/sudoers 
    +#uncomment
    +#%wheel ALL=(ALL) ALL
37. pacman -S amd-ucode grub efibootmgr xf86-video-amdgpu
38. dd bs=512 count=4 if=/dev/random of=/root/cryptlvm.keyfile iflag=fullblock
    +add key to unlock disk when boot is unlocked 
    +chmod 000 /root/cryptlvm.keyfile
    +cryptsetup -v luksAddKey /dev/sda3 /root/cryptlvm.keyfile
39. vim /etc/mkinitcpio.conf 
    +despues del hook autodetect poner "keyboard keymap" 
    +antes de filesystems poner hook encrypt 
    +FILES=(/root/cryptlvm.keyfile) 
40. chmod 600 /boot/initramfs-linux* 
41. mkinitcpio -p linux-zen 
42. blkid >> uuid
    +copy UUID of /dev/sda3 
43. vim uuid 
44. rm uuid
45. vim /etc/default/grub 
    + enable cryptodisk 
    + GRUB_CMDLINE_LINUX="cryptdevice=UUID=<uuid copypasteada>:root root=/dev/mapper/root cryptkey=rootfs:/root/cryptlvm.keyfile" 
46. grub-install --target=x86_64-efi --bootloader-id=grub --efi-directory=/boot/efi
47. grub-mkconfig -o /boot/grub/grub.cfg 
48. exit
49. umount -a
50. reboot   
51. cambiar path bios \EFI\grub\grubx64.efi (F9 boot from EFI file)
52. sudo pacman -S broadcom-wl-dkms
53. vim ~/.bashrc
function wifiList() {
    nmcli dev wifi list 
} 
function wifiConnect() {
	sudo nmcli --ask dev wifi connect "$1"
}
function wifiDisconnect(){
        nmcli con down "$1" 
} 
#reiniciar para poder usar los drivers 
reboot 
#instalar e iniciar i3 y emulador terminal 
sudo pacman -S xorg xorg-xinit i3 xfce4-terminal
vim ~/.xinitrc 
#exec i3
startx
sudo pacman -S firefox dmenu keepassxc alsa-utils pulseaudio htop brightnessctl xclip git maim libreoffice
alsamixer
#desmutear todos los canales, puede ser necesario reiniciar para que los cambios hagan efecto 
#EN CASO DE QUE HAYA PROBLEMAS DE AUDIO DEFINIR TARJETA DE SONIDO DEFAULT O INVESTIGAR COMO
sudo vim /etc/modules-load.d/snd-pcm-oss.conf
#sound module
snd-pcm-oss

sudo vim /etc/modules-load.d/btusb.conf
#bluetooth module, remember to trust devices before connect 
btusb

aplay -l 
#ver cual es el nombre de la tarjeta de sonido, en mi caso se llama Generic
vim ~/.asoundrc
pcm.!default {
   type hw
   card Generic
}

ctl.!default {
   type hw
   card Generic
}
reboot 
~/.config/i3/config
#personal commands
bindsym ctrl+Shift+Return exec xfce4-terminal -e htop
bindsym ctrl+Shift+l exec i3lock
exec_always setxkbmap -layout us -variant altgr-intl
bindsym XF86MonBrightnessDown exec brightnessctl set 1%-
bindsym XF86MonBrightnessUp exec brightnessctl set +1% 
#screenshots
bindsym ctrl+Shift+r exec maim -s | xclip -selection clipboard -t image/png
#resolution of pop ups and floating windows
floating_minimum_size 75 x 50
floating_maximum_size 400 x 300 
#end personal commands 
~/.config/i3status/config 
general {
        colors = true
        interval = 5
}

order += "wireless _first_"
order += "ethernet _first_"
order += "battery all"
order += "memory"
order += "tztime local"

wireless _first_ {
        format_up = "Wi-fi signal: (%quality at %essid) "
        format_down = "Wi-fi signal: down"
}

ethernet _first_ {
        format_up = "Ethernet: up (%speed)"
        format_down = "Ethernet: down"
}

battery all {
        format = "BATERY %status %percentage %remaining"
}
memory {
        format = "in use RAM %used | available RAM %available"
        threshold_degraded = "1G"
        format_degraded = "MEMORY < %available"
}

tztime local {
        format = "%a %d/%m/%Y %H:%M"
} 

sudo pacman -S lxappearance arc-gtk-theme bluez bluez-utils pulseaudio-bluetooth
systemctl enable bluetooth

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
14. https://www.youtube.com/watch?v=XNJ4oKla8B0 
15. https://www.freecodecamp.org/news/how-to-install-arch-linux/
