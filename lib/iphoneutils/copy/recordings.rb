require 'plist'
require 'pp'
require 'time'
module Iphoneutils
  module Copy 
    class << self # See https://stackoverflow.com/a/35012552/685715
      def recordings(source, target)
	plist_file = "#{source}/AssetManifest.plist"
	plist = Plist.parse_xml(plist_file);
	unless plist
	  raise ArgumentError, "Could not interpret plist file #{plist_file}"
	end
	if File.exist?(target)
	  raise ArgumentError, "Already exists: #{target}"
	end
	Dir.mkdir(target)
	#pp plist
	plist.each {|file, prop|
	  copy_recording(source, target, file, prop['name'])
	}

	#puts "foo"
      end

      private

      def copy_recording(src_dir, tgt_dir, src_file, tgt_base)
	src = Pathname.new("#{src_dir}/#{src_file}")
	re = /(\d\d\d\d)(\d\d)(\d\d) (\d\d)(\d\d)(\d\d)/
	if m = re.match(src_file)
	  time_str = "#{m[1]}-#{m[2]}-#{m[3]} #{m[4]}:#{m[5]}:#{m[6]}"
	  time = Time.parse(time_str)
	  puts time
	end 
	tgt_base.gsub!(/\//, "-")	# Avoid '/' is target file name
	tgt = Pathname.new("#{tgt_dir}/#{tgt_base}#{File.extname(src_file)}")
	puts "#{src} => #{tgt}"
	if File.exist?(src)
	  copy_file(src, tgt, time)
	end
	Dir.glob(src.sub(/m4a$/, "composition/fragments/*.m4a")).each {|fragment|
	  puts "FRAGMENT #{fragment}"
	}
      end
      def copy_file(src, tgt, time, instance=0)
	tgt = tgt.sub_ext("-#{instance}#{tgt.extname}") if instance != 0
	  puts "copy_file: #{tgt}"
	if File.exist?(tgt)
	  copy_file(src, tgt, time, instance+1)
	else
	  FileUtils.cp(src, tgt)
	  FileUtils.touch(tgt, mtime: time)
	end
      end
    end
  end
end
