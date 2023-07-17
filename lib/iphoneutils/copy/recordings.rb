require 'plist'
require 'pathname'
require 'time'
require 'fileutils'
module Iphoneutils
  module Copy 
    class << self # See https://stackoverflow.com/a/35012552/685715
      def recordings(source, target)
	# The plist file contains the mappings between the names of the .m4a files
	# on the idevice and the titles entered for each recording in the Voice Memos app:
	plist_file = "#{source}/AssetManifest.plist"
	plist = Plist.parse_xml(plist_file);
	unless plist
	  raise ArgumentError, "Could not interpret plist file #{plist_file}"
	end

	# We don't want to overwrite an existing directory:
	if File.exist?(target)
	  raise ArgumentError, "Already exists: #{target}"
	end
	Dir.mkdir(target)

	# Copy all of the recordings in the plist:
	plist.each {|file, prop|
	  copy_recording(source, target, file, prop['name'])
	}

	#puts "foo"
      end

      private

      def copy_recording(src_dir, tgt_dir, src_file, tgt_base)
	src = Pathname.new("#{src_dir}/#{src_file}")

	# The file names of the recordings are of the form YYYYMMDD HHMMSS
	# We want to use these timestamps to set the modification time of the copied file.
	re = /(\d\d\d\d)(\d\d)(\d\d) (\d\d)(\d\d)(\d\d)/
	if m = re.match(src_file)
	  time_str = "#{m[1]}-#{m[2]}-#{m[3]} #{m[4]}:#{m[5]}:#{m[6]}"
	  time = Time.parse(time_str)
	end 
	tgt_base.gsub!(/\//, "-")	# Avoid '/' in target file name
	tgt = Pathname.new("#{tgt_dir}/#{tgt_base}#{File.extname(src_file)}")
	if File.exist?(src)
	  copy_file(src, tgt, time)
	end

	# Sometimes, the recording is not in foo.m4a, but in foo.composition/fragment/*.m4a:
	Dir.glob(src.sub(/m4a$/, "composition/fragments/*.m4a")).each {|fragment|
	  #puts "FRAGMENT #{fragment}"
	  copy_file(fragment, tgt, time)
	}
      end
      def copy_file(src, tgt, time, instance=0)
	# It is possible for more than one .m4a file to have the same title
	# set in the Voice Memos app.
	# In the case, we add a distiguishing instance number to the target file name:
	tgt = tgt.sub_ext("-#{instance}#{tgt.extname}") if instance != 0

	if File.exist?(tgt)
	  # Here is the recursive call to walk through the instance numbers we've already used:
	  copy_file(src, tgt, time, instance+1)
	else
	  puts "#{src} => #{tgt}"
	  FileUtils.cp(src, tgt)
	  if time
	    FileUtils.touch(tgt, mtime: time)
	  end
	end
      end
    end
  end
end
