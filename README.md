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
    ```
    vim sha256sums.txt
    vim b2sums.txt
    
    #check if the three verification files are in order
    sha256sum -c sha256sums.txt
    b2sum -c b2sums.txt
    gpg --keyserver-options auto-key-retrieve --verify archlinux-2024.08.01-x86_64.iso.sig
    
    #to see the name of the usb
    lsblk
    
    #burn the iso file in a usb
    sudo dd if=archlinux-2024.08.01-x86_64.iso of=/dev/sde bs=16M oflag=direct status=progress
    ```
5. connect to the internet (im using my cellphone because arch doesnt recognize my wifi card)
6. ```
    #date
    timedatectl set-timezone America/Argentina/Buenos_Aires
    
    #make partitions
    cfdisk
    #/dev/sda1 EFI 512MB
    #/dev/sda2 SWAP 16GB
    #/dev/sda3 ROOT
    
    #format partitions
    mkfs.ext4 /dev/sda3 
    mkswap /dev/sda2
    mkfs.fat -F 32 /dev/sda1
    
    #mount partitions
    mount /dev/sda3 /mnt 
    mkdir /mnt/boot
    mount /dev/sda1 /mnt/boot 
    swapon /dev/sda2

    #search mirrors
    reflector --download-timeout 60 --country Argentina,Brazil,Chile --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    
    #install base packages
    pacstrap -K /mnt base linux-zen linux-firmware ntfs-3g neovim networkmanager base-devel sudo linux-zen-headers
    
    #generate filesystem tab
    genfstab -U /mnt >> /mnt/etc/fstab 
    
    #check if it generated correctly)
    nano /mnt/etc/fstab 
    
    #enter the root system
    arch-chroot /mnt
    
    #set date
    ln -sf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime
    hwclock --systohc
    
    #set language
    nvim /etc/locale.gen
    locale-gen 
    
    #set host name
    nvim /etc/hosts
        # 127.0.0.1        localhost
        # ::1              localhost
        # 127.0.1.1        hp-elitebook-745-g2
    nvim /etc/hostname 
        # hp-elitebook-745-g2
    
    #set language
    nvim /etc/locale.conf  
        # LANG=en_US.UTF-8
    
    #Enable Internet Service
    systemctl enable NetworkManager
    
    #Make user
    passwd
    useradd -m -G wheel mxsatworld
    passwd mxsatworld
    nvim /etc/sudoers 
        # uncomment
        # %wheel ALL=(ALL) ALL
    
    #grub, microcode, video drivers
    pacman -S amd-ucode grub efibootmgr xf86-video-amdgpu
    
    #install grub
    grub-install --target=x86_64-efi --bootloader-id=grub --efi-directory=/boot

    #edit timeout of grub to 1 second
    nvim /etc/default/grub

    #make grub config
    grub-mkconfig -o /boot/grub/grub.cfg 
    
    #finish and reboot
    exit
    umount -a
    reboot
    ```
7. change bios path \EFI\grub\grubx64.efi (F9 boot from EFI file)
```
#wifi drivers, reboot is necessary
sudo pacman -S broadcom-wl-dkms
reboot

#install packages
nmcli dev wifi list
sudo nmcli --ask dev wifi connect "$1"
sudo pacman -S xorg xorg-xinit i3 xfce4-terminal firefox dmenu keepassxc alsa-utils pulseaudio htop brightnessctl xclip maim libreoffice lxappearance arc-gtk-theme bluez bluez-utils pulseaudio-bluetooth cups cups-pdf usbutils openssh hplip xss-lock tmux git lightdm lightdm-gtk-greeter

#start X
nvim ~/.xinitrc
    # exec i3
startx
```
8. login to github
    + ssh-keygen -t rsa -b 4096 -C "mcuadrado578@gmail.com"
    + add key
    + git clone with ssh this repo and use the config files
9. alsamixer
    + unmute all channels    
```
#sound,bluetooth modules
sudo nvim /etc/modules-load.d/snd-pcm-oss.conf
    # sound module
    # snd-pcm-oss
sudo nvim /etc/modules-load.d/btusb.conf
    # bluetooth module
    # btusb
    # bluetooth module, remember to trust devices before connect 

#start services
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable lightdm
```
10. reboot
11. config printer with http://localhost:631/admin 
12. AUR (opera)

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
