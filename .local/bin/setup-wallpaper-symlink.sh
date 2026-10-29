# Wallpaper Engine Symlink Fix
# Steam via snap stores data in ~/snap, but DMS plugin looks for ~/.snap
# This symlink fixes the path resolution
ln -s ~/snap ~/.snap

