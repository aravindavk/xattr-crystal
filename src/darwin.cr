require "./helpers"

module Xattrs
  {% if flag?(:darwin) %}
    lib LibXAttr
      fun getxattr(path : LibC::Char*, name : LibC::Char*, value : LibC::Char*, size : LibC::SizeT, position : LibC::UInt32T, options : LibC::Int) : LibC::Int
      fun setxattr(path : LibC::Char*, name : LibC::Char*, value : LibC::Char*, size : LibC::SizeT, position : LibC::UInt32T, options : LibC::Int) : LibC::Int
      fun listxattr(path : LibC::Char*, list : LibC::Char*, size : LibC::SizeT, options : LibC::Int) : LibC::Int
      fun removexattr(path : LibC::Char*, name : LibC::Char*, options : LibC::Int) : LibC::Int
    end

    FLAG_NOFOLLOW = 0x0001
    FLAG_CREATE   = 0x0002
    FLAG_REPLACE  = 0x0004

    private def self.get_size(path : String, name : String, no_follow = false)
      flags = no_follow ? FLAG_NOFOLLOW : 0
      ret = LibXAttr.getxattr(path, name, nil, 0, 0, flags)
      check_and_raise_io_error("Failed to get xattr size", ret)

      ret
    end

    private def self.get(path : String, name : String, size : Int32, no_follow = false)
      return "" if size == 0

      ptr = Slice(LibC::Char).new(size)
      flags = no_follow ? FLAG_NOFOLLOW : 0
      ret = LibXAttr.getxattr(path, name, ptr, size, 0, flags)
      check_and_raise_io_error("Failed to get xattr", ret)

      String.new(ptr)
    end

    def self.get(path : String, name : String, no_follow = false)
      size = get_size(path, name, no_follow: no_follow)
      get(path, name, size, no_follow: no_follow)
    end

    def self.set(path : String, name : String, value : String, no_follow = false, only_create = false, only_replace = false)
      flags = no_follow ? FLAG_NOFOLLOW : 0

      # If both FLAG_CREATE and FLAG_REPLACE are set
      # then it raises EINVAL
      flags |= FLAG_CREATE if only_create
      flags |= FLAG_REPLACE if only_replace

      ret = LibXAttr.setxattr(path, name, value, value.bytesize, 0, flags)
      check_and_raise_io_error("Failed to set xattr", ret)
    end

    def self.remove(path : String, name : String, no_follow = false)
      flags = no_follow ? FLAG_NOFOLLOW : 0
      ret = LibXAttr.removexattr(path, name, flags)
      check_and_raise_io_error("Failed to remove Xattr", ret)
    end

    private def self.list_size(path : String, no_follow = false)
      flags = no_follow ? FLAG_NOFOLLOW : 0
      ret = LibXAttr.listxattr(path, nil, 0, flags)
      check_and_raise_io_error("Failed to list xattrs", ret)

      ret
    end

    private def self.list(path : String, size : Int32, no_follow = false)
      return [] of String if size == 0

      ptr = Slice(LibC::Char).new(size)
      flags = no_follow ? FLAG_NOFOLLOW : 0
      ret = LibXAttr.listxattr(path, ptr, size, flags)
      check_and_raise_io_error("Failed to list xattrs", ret)

      String.new(ptr).split("\000", remove_empty: true).sort
    end

    def self.list(path : String, no_follow = false)
      size = list_size(path, no_follow: no_follow)
      list(path, size, no_follow: no_follow)
    end
  {% end %}
end
