# Iphoneutils

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/iphoneutils`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'iphoneutils'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iphoneutils

## Usage

### Copy recordings

I use iPhone Voice Memos quite a bit to record snippets of music during rehearsals. I dislike iTunes, and want a simple way to get the recording off the phone. 

```
$ iphoneutils copy help recordings
Usage:
  iphoneutils recordings SOURCE TARGET

Description:
  Copies .m4a files from the Recordings directory on the iPhone, and renames them using the 
  name that was given in the Voice Memos app. If then same name was given in the Voice Memos 
  app to more than one recording, then the names of the copies will include a distinguishing 
  number. e.g. 'My Recording.m4a', 'My Recording-1.m4a', and so on. If the name given in the 
  Voice Memos app includes the character '/', then it will be replaced by the character '-'.

  The modification time of the copied file will be set to the time when the recording was 
  created.

  EXAMPLE using idevicebackup2 and ideviceunback 
  -------

  1. Connect your iPhone to USB and get the data

  $ mkdir iPhoneData 	
  $ idevicebackup2 backup iPhoneData 	
  $ ideviceunback -i 
  iPhoneData/<device-id> -o iPhoneData/unback

  2. Copy the recordings

  $ iphoneutils copy recordings iPhoneData/unback/Media/Recordings myRecordings

  EXAMPLE using ifuse 
  -------

  1. Connect your iPhone to USB and get the data

  $ mkdir ~/media/iphone 
  $ ifuse ~/media/iphone

  2. Copy the recordings

  $ iphoneutils copy recordings ~/media/iphone/Recordings myRecordings
```
To see the latest documentation, run afresh:
```
$ iphoneutils copy help recordings
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/matt-wallis/iphoneutils.
