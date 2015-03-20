# export PATH="$PATH:/Applications/Android Studio.app/sdk/platform-tools"
# export PATH="$PATH:/Applications/Android Studio.app/sdk/tools"

# export PATH="$PATH:/Users/Shawn/Development/adt-bundle-mac-x86_64-20140702/sdk/platform-tools/adb"
# export PATH="$PATH:/Users/Shawn/Development/adt-bundle-mac-x86_64-20140702/sdk/platform-tools"
# export PATH="$PATH:/Users/Shawn/Development/adt-bundle-mac-x86_64-20140702/sdk/tools"

export PATH="$PATH:/Users/Shawn/Development/adt-bundle-mac-x86_64-20140321/sdk/platform-tools/adb"
export PATH="$PATH:/Users/Shawn/Development/adt-bundle-mac-x86_64-20140321/sdk/platform-tools"
export PATH="$PATH:/Users/Shawn/Development/adt-bundle-mac-x86_64-20140321/sdk/tools"

export PATH="$PATH:/Users/Shawn/Development/android-ndk-r10d"

alias jnidebug="adb shell setprop debug.checkjni 1"

alias and-screencap="echo 'Capturing screenshot...' && adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' >"