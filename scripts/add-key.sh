#!/bin/sh

# EXAMPLE >>>>>>>>>>>>>>>>>>>>

KEY_CHAIN="$KEYCHAIN_NAME.keychain"

security create-keychain -p travis $KEY_CHAIN
security import ./Scripts/certs/distEnterprise.p12 -k ~/Library/Keychains/$KEY_CHAIN -P $P12_PASSWORD -T /usr/bin/codesign
security import ./Scripts/certs/apple.cer -k ~/Library/Keychains/$KEY_CHAIN -T /usr/bin/codesign
  
mkdir -p "$XC_PROFILE_PATH"
DELIVER_PASSWORD="$APPLE_PASSWORD" sigh --skip_install -a 'com.example.Travis' -u $USER_ID -t $TEAM_ID -n "TRAVIS-$PROFILE_NAME" -o "$XC_PROFILE_PATH" -f $PROFILE_NAME.mobileprovision

echo "Make default keychain"
security default-keychain -s $KEY_CHAIN

echo "Unlock keychain"
security unlock-keychain -p travis $KEY_CHAIN

echo "Increase keychain unlock timeout"
security set-keychain-settings -lut 7200 $KEY_CHAIN

echo "Add keychain to keychain-list"
security list-keychains -s $KEY_CHAIN