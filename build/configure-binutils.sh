# Configure the binutils tarball for LFS.

# PRE: Run this from $LSF/sources/binutils-build/

# --prefix -- where to install binutils
# --with-sysroot -- look here for system libs during xcompile, not /.
# --with-lib-path -- linker should look for libs here
# --target -- target arch; since slightly different from host arch, xcompile will happen.
# --disable-nls -- no internationalization
# --disable-werror -- don't blow up on compile errors
echo "Building binutils for ${LFS_TGT}."
../binutils-2.25/configure \
	--prefix=/tools \
	--with-sysroot=$LFS \
	--with-lib-path=/tools/lib \
	--target=$LFS_TGT \
	--disable-nls \
	--disable-werror
