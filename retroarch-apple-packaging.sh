#!/bin/sh
# app stuff

rm -rf Fruitendo.app

mkdir -p Fruitendo.app/Contents/MacOS
cp -r pkg/apple/OSX/* Fruitendo.app/Contents
cp Fruitendo Fruitendo.app/Contents/MacOS

mv Fruitendo.app/Contents/Info_Metal.plist Fruitendo.app/Contents/Info.plist

sed -i'.bak' 's/\${EXECUTABLE_NAME}/Fruitendo/' Fruitendo.app/Contents/Info.plist
sed -i'.bak' 's/\$(PRODUCT_BUNDLE_IDENTIFIER)/com.libretro.Fruitendo/' Fruitendo.app/Contents/Info.plist
sed -i'.bak' 's/\${PRODUCT_NAME}/Fruitendo/' Fruitendo.app/Contents/Info.plist
sed -i'.bak' 's/\${MACOSX_DEPLOYMENT_TARGET}/10.13/' Fruitendo.app/Contents/Info.plist

cp media/Fruitendo.icns Fruitendo.app/Contents/Resources/

# dmg stuff

umount wc
rm -rf Fruitendo.dmg wc empty.dmg

mkdir -p template
hdiutil create -fs HFSX -layout SPUD -size 200m empty.dmg -srcfolder template -format UDRW -volname Fruitendo -quiet
rmdir template

mkdir -p wc
hdiutil attach empty.dmg -noautoopen -quiet -mountpoint wc
rm -rf wc/Fruitendo.app
ditto -rsrc Fruitendo.app wc/Fruitendo.app
ln -s /Applications wc/Applications
WC_DEV=`hdiutil info | grep wc | grep "Apple_HFS" | awk '{print $1}'` && hdiutil detach $WC_DEV -quiet -force
hdiutil convert empty.dmg -quiet -format UDZO -imagekey zlib-level=9 -o Fruitendo.dmg

umount wc
rm -rf wc empty.dmg
