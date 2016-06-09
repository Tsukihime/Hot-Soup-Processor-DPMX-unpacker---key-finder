#!/usr/bin/ruby

require 'fileutils'

HSP_INI_DATA_SIZE = 32

class File
  def read_u1
    return self.read(1).unpack("C")[0]
  end
  
  def read_u2
    return self.read(2).unpack("S")[0]
  end

  def read_u4
    return self.read(4).unpack("L")[0]
  end
end

ARGV.each { | hotsoup_fn |
  puts "Searching key..."
  File.open(hotsoup_fn, "rb") { | f |
    offset = 0;
                
    (0..f.size() - HSP_INI_DATA_SIZE - 1).each { | i |
        f.seek(i)
      data = f.gets(nil, 13).split("")
      if data[0] == 'x' and
        data[3] == 'y' and
        data[6] == 'd' and
        data[9] == 's' and
        data[12] == 'k' then
          offset = i - 19
          break
      end
    }
    f.seek(offset)
    f.seek(9, IO::SEEK_CUR) # stub
    HSPInitDataOffset = f.read(9)
    mode = f.read_u1
    f.seek(1, IO::SEEK_CUR)
    width = f.read_u2
    f.seek(1, IO::SEEK_CUR)
    height = f.read_u2
    f.seek(1, IO::SEEK_CUR)
    d = f.read_u2
    f.seek(1, IO::SEEK_CUR)
    chksum = f.read_u2
    f.seek(1, IO::SEEK_CUR)
    key = f.read_u4

    puts "HSPKey found!\n"
    puts "HSPInitializeDataOffset - 0x10000:\t#{HSPInitDataOffset.to_i - 0x10000}\n"
    puts "mode:\t#{mode}\n"
    puts "width:\t#{width}\n"
    puts "height:\t#{height}\n"
    puts "d:\t#{d}\n"
    puts "chksum:\t#{"0x%04X" % chksum}\n"
    puts "KEY:\t#{"0x%08X" % key}\n"
  }
}