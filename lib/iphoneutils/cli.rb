require "thor"
require "iphoneutils/copy/recordings"

module Iphoneutils
  module Subcommands
    class Copy < Thor
      desc "recordings SOURCE TARGET", "Copies recordings from iPhone"
      long_desc <<-LONGDESC
      EXAMPLE using idevicebackup2 and ideviceunback
      \x5-------

      1. Connect your iPhone to USB and get the data

	$ mkdir iPhoneData
	\x5$ idevicebackup2 backup iPhoneData
	\x5$ ideviceunback -i iPhoneData/<device-id> -o iPhoneData/unback

      2. Copy the recordings

	  $ iphoneutils copy recordings iPhoneData/unback/Media/Recordings myRecordings


      EXAMPLE using ifuse
      \x5-------

      1. Connect your iPhone to USB and get the data

      $ mkdir ~/media/iphone
      \x5$ ifuse ~/media/iphone

      2. Copy the recordings

      $ iphoneutils copy recordings ~/media/iphone/Recordings myRecordings

      LONGDESC
      def recordings(source, target)
	puts "copy recordings from #{source} to #{target}"
	Iphoneutils::Copy.recordings(source, target)
      end
    end
  end
  class CLI < Thor

    # See https://github.com/erikhuda/thor/wiki/Making-An-Executable
    def self.exit_on_failure?
      true
    end

    desc "copy SUBCOMMAND ...ARGS",  "Copies stuff from iPhone"
    subcommand "copy", Subcommands::Copy

  end
end
