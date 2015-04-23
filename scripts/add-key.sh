#!/bin/sh

# EXAMPLE >>>>>>>>>>>>>>>>>>>>

security create-keychain -p travis $KEYCHAIN_NAME.keychain
security import ./Scripts/certs/distEnterprise.p12 -k ~/Library/Keychains/$KEYCHAIN_NAME.keychain -P $P12_PASSWORD -T /usr/bin/codesign
security import ./Scripts/certs/apple.cer -k ~/Library/Keychains/$KEYCHAIN_NAME.keychain -T /usr/bin/codesign
  
mkdir -p "$XC_PROFILE_PATH"
DELIVER_PASSWORD="$APPLE_PASSWORD" sigh --skip_install -a 'com.example.Travis' -u $USER_ID -t $TEAM_ID -n "TRAVIS-$PROFILE_NAME" -o "$XC_PROFILE_PATH" -f $PROFILE_NAME.mobileprovision

echo "Unlock keychain"
security unlock-keychain -p travis $KEYCHAIN_NAME.keychain

echo "Increase keychain unlock timeout"
security set-keychain-settings -lut 7200 $KEYCHAIN_NAME.keychain

echo "Add keychain to keychain-list"
security list-keychains -s $KEYCHAIN_NAME.keychain