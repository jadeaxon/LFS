# LFS 7.9
Linux from Scratch<br>
Toolchain built on Ubuntu 15.04 x86_64.<br>
Target is x86_64.<br>
Target is also whatever the Raspberry Pi 3 is.<br>

# Getting Started
Login as user `lfs` to your dev VM.<br>
Make sure you have `bash-glory` and `home` applied to this user.<br>
Insert the USB thumbdrive you prepared and attach to VM.<br>
```
sudo $(command which mount-lfs.sh)
```
Do some work in `/mnt/LFS`.<br>
```
sudo $(command which umount-lfs.sh)
```
