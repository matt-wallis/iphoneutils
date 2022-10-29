# Developer Notes

This document is to remind me of things that are useful during development, but which I will probably forget!

## Creating the gem

I used bundler to create boiler plate for a gem with an executable:
```
$ bundle gem --exe iphoneutils
```

## Experimenting

To fire up `irb` with the library loaded:
```
$ bin/console`
```

## Documents consulted
During the development, I looked at these:

- [Restore or copy iPhone contacts to another phone using Linux](https://ctpc.biz/idevice-restore-iphone-contacts-using-linux.html) - how to use [idevicebackup2](https://www.libimobiledevice.org/) and [ideviceunback](https://github.com/inflex/ideviceunback) to get the data from the iPhone.
- [ifuse](https://www.mankier.com/1/ifuse) for mounting the iPhone locally using fuse: 
```
$ mkdir -p ~/media/iphone
$ ifuse ~/media/iphone
```
- [How to write your first CLI with Thor](https://medium.com/magnetis-backstage/how-to-write-your-first-cli-with-thor-9da6636bf744)
- [What is Thor?](http://whatisthor.com/)
- [How to create a Ruby gem with Bundler](https://bundler.io/v2.0/guides/creating_gem.html)

## Files on the iPhone

### Recordings

This directory contains audio recorded by the Voice Memos app. 
The recordings are stored on the iPhone in a `Recordings` directory with file names containing timestamps. e.g. `20190716 203652.m4a`. 

There's a file called `AssetManifest.plist` that maps the names of the `.m4a` files onto the titles that you see in the user interface of the Voice Memos app.
It is an Apple plist in XML format. Here's an example that maps a .m4a file name onto the name 'God Only Knows':
```
    <key>20140701 205735.m4a</key>
        <dict>
                <key>hasChanges</key>
                <false/>
                <key>name</key>
                <string>God Only Knows</string>
                <key>pid</key>
                <integer>7608165057324974017</integer>
        </dict>
```
Fortunately, there's a [ruby gem plist](https://github.com/patsplat/plist) to convert it into a Hash.

If only things were that simple!
Sometimes, the .m4a file mentioned in the `<key>` does not exist.
In this case, there is another place where .m4a files may lurk. 
An example:
```
$ ls Recordings/20180802\ 222805.composition/fragments/*.m4a
'Recordings/20180802 222805.composition/fragments/7F1452E7-3DD9-4287-A875-7C440D545B2B.m4a'
```
 
## Running the exe

Without installing the gem, commands can be run like this:
```
$ bundle exec exe/iphoneutils copy recordings ~/media/iphone/Recordings/ my-target-dir
```

## Installing the gem

I generally install gems with `--user-install` to put them in my local tree.
This seemed to do the job for version 0.1.0:
```
$ bundle exec rake install
$ gem install --user-install pkg/iphoneutils-0.1.0.gem
```
