# set params
ANDROID_NDK_ROOT=/Users/Peteo/Android/android-ndk-r5-crystax-2
COCOS2DX_ROOT=/Users/Peteo/git/cocos2d-x/cocos2d-x
GAME_ROOT=/Users/Peteo/projects/GeniusPeteo/SimpleGame
GAME_ANDROID_ROOT=$GAME_ROOT/android
RESOURCE_ROOT=$GAME_ROOT/Resources

# make sure assets is exist
if [ -d $GAME_ANDROID_ROOT/assets ]; then
    rm -rf $GAME_ANDROID_ROOT/assets
fi

mkdir $GAME_ANDROID_ROOT/assets

# copy resources
for file in $RESOURCE_ROOT/*
do
    if [ -d $file ]; then
        cp -rf $file $GAME_ANDROID_ROOT/assets
    fi

    if [ -f $file ]; then
        cp $file $GAME_ANDROID_ROOT/assets
    fi
done

# build
$ANDROID_NDK_ROOT/ndk-build -C $GAME_ANDROID_ROOT $*

