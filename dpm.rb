# This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

require 'kaitai/struct/struct'
require 'zlib'

class Dpm < Kaitai::Struct::Struct
  def initialize(_io, _parent = nil, _root = self)
    super(_io, _parent, _root)
    @exe_data = @_io.read_bytes(176128)
    @magic = @_io.ensure_fixed_contents(4, [68, 80, 77, 88])
    @data_offset = @_io.read_u4le
    @file_count = @_io.read_u4le
    @magic2 = @_io.read_u4le
    @entries = Array.new(file_count)
    (file_count).times { |i|
      @entries[i] = FileEntry.new(@_io, self, @_root)
    }
  end
  class FileEntry < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @filename = @_io.read_str_byte_limit(16, "ASCII")
      @magic_ffffffff = @_io.read_u4le
      @key = @_io.read_u4le
      @offset = @_io.read_u4le
      @filesize = @_io.read_u4le
    end
    def data
      return @data if @data
      io = _root._io
      _pos = io.pos
      io.seek(((_root.data_offset + offset) + 176128))
      @data = io.read_bytes(filesize)
      io.seek(_pos)
      @data
    end
    attr_reader :filename
    attr_reader :magic_ffffffff
    attr_reader :key
    attr_reader :offset
    attr_reader :filesize
    attr_reader :_root
    attr_reader :_parent
  end
  attr_reader :exe_data
  attr_reader :magic
  attr_reader :data_offset
  attr_reader :file_count
  attr_reader :magic2
  attr_reader :entries
  attr_reader :_root
  attr_reader :_parent
end
