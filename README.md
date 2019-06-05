# Custom set of cerbero recipes

Use:

1. Configure ~/.cerbero/cerbero.cbc. Add home_dir, at least. E.g. home_dir = '/home/user/build/cerbero'
2. Use cerbero script in the root dir of the project. It includes the flexvdi.cbc file and runs from the cerbero config directory so that a) custom recipe paths and toolchains are set, and b) other configuration files are referenced without path.

For instance:

    ./cerbero -c cross-android-universal.cbc bootstrap
