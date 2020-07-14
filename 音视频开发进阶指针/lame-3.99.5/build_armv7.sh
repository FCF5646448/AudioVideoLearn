./configure \
--disable-shared    \
--disable-frontend  \
--prefix="/Users/fan/Downloads/lame-3.99.5/thin/armv7"  \
CC="xcrun -sdk iphoneos clang -arch armv7"  \
CFLAGS="-arch armv7 -fembed-bitcode -miphoneos-version-min=7.0" \
LDFLASS="-arch armv7 -fembed-bitcode -miphoneos-version-min=7.0"    \
make clean
make -j8
make install
