# My Arch Installation
## Steps
1. Download the iso file and the signature to verify it, download it from torrent in my case
    + iso file https://archlinux.org/download/
    + sha256sums.txt
    + b2sums.txt
    + archlinux-2024.08.01-x86_64.iso.sig
2. get the pgp key of pierre@archlinux.org in keys.openpgp.org
NOTE!!!: TO VERIFY THE ISO IMAGE IT MUST BE FULLY DOWNLOADED
3. edit sha256sums.txt and b2sums.txt to only leave the sum that suits you (they give you 3 options)
    + vim sha256sums.txt
    + vim b2sums.txt
4. then run these commandos to check everything is ok
    + sha256sum -c sha256sums.txt
    + b2sum -c b2sums.txt
    + gpg --keyserver-options auto-key-retrieve --verify archlinux-2024.08.01-x86_64.iso.sig
5. import and verify the pierre key
    + gpg --import 3E80CA1A8B89F69CBA57D98A76A5EF9054449A5C.asc
    + gpg --verify archlinux-2024.08.01-x86_64.iso.sig

## Sources
1. archlinux.org
2. wiki.archlinux.org
3. keys.openpgp.org
4. https://www.youtube.com/watch?v=hPHW0y6RAZA&t=479s
5. https://www.wikihow.com/Verify-a-PGP-Signature
6. https://wiki.archlinux.org/title/Installation_guide 