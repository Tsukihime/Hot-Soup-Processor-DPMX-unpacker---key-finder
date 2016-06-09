#!/usr/bin/ruby

require 'fileutils'
require_relative 'dpm'

EXTRACT_PATH = 'extracted'
SECRET_KEY = 0x233A66DF
EXE_PART_SIZE = 0x2B000

class Numeric
  def byte(index)
    return self >> (index * 8) & 0xFF
  end
end

def get_pesonal_filekey(filekey, datasize)
  x1 = (SECRET_KEY.byte(0) * SECRET_KEY.byte(2) * 0x55555556) >> 32
  s1 = (((x1 >> 31) + x1) ^ datasize).byte(0)

  x2 = SECRET_KEY.byte(1) * SECRET_KEY.byte(3) * 0x66666667 >> 33
  s2 = (((x2 >> 31) + x2) ^ datasize ^ 0xAA).byte(0)
  
  key1 = (((filekey.byte(0) + 0x55) ^ filekey.byte(2)) + s1).byte(0);
  key2 = (((filekey.byte(1) + 0xAA) ^ filekey.byte(3)) + s2).byte(0);
  
  return [key1, key2]
end

def decode(data, keys);
  decoded_data = []
  res = 0
  data.each_byte{ |b|
    res = (res + ((b - keys[1]) ^ keys[0]))
    decoded_data.push(res);
  }
  return decoded_data.pack("c*")
end

ARGV.each { |hotsoup_fn|
  datasize =  File.size(hotsoup_fn) - EXE_PART_SIZE - Dpm.from_file(hotsoup_fn).data_offset
  Dpm.from_file(hotsoup_fn).entries.each { |f|
    filename = f.filename.strip.encode('UTF-8')
    dirname = File.dirname(filename)
    FileUtils::mkdir_p("#{EXTRACT_PATH}/#{dirname}")

    keys = get_pesonal_filekey(f.key, datasize)
    data = decode(f.data, keys)
    File.write("#{EXTRACT_PATH}/#{filename}", data)
    puts "file: #{filename}\tsize: #{data.size}"
  }
}
