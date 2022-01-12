require "./helpers"

module Xattr
  {% if flag?(:linux) %}
    lib LibXAttr
      fun getxattr(path : LibC::Char*, name : LibC::Char*, value : LibC::Char*, size : LibC::SizeT) : LibC::Int
      fun setxattr(path : LibC::Char*, name : LibC::Char*, value : LibC::Char*, size : LibC::SizeT, options : LibC::Int) : LibC::Int
      fun listxattr(path : LibC::Char*, list : LibC::Char*, size : LibC::SizeT) : LibC::Int
      fun removexattr(path : LibC::Char*, name : LibC::Char*) : LibC::Int
      fun lgetxattr(path : LibC::Char*, name : LibC::Char*, value : LibC::Char*, size : LibC::SizeT) : LibC::Int
      fun lsetxattr(path : LibC::Char*, name : LibC::Char*, value : LibC::Char*, size : LibC::SizeT, options : LibC::Int) : LibC::Int
      fun llistxattr(path : LibC::Char*, list : LibC::Char*, size : LibC::SizeT) : LibC::Int
      fun lremovexattr(path : LibC::Char*, name : LibC::Char*) : LibC::Int
    end

    FLAG_CREATE  = 0x1
    FLAG_REPLACE = 0x2

    private def self.get_size(path : String, name : String, no_follow = false)
      if no_follow
        ret = LibXAttr.lgetxattr(path, name, nil, 0)
      else
        ret = LibXAttr.getxattr(path, name, nil, 0)
      end
      check_and_raise_io_error("Failed to get xattr", ret)

      ret
    end

    private def self.get(path : String, name : String, size : Int32, no_follow = false)
      return "" if size == 0

      ptr = Slice(LibC::Char).new(size)
      if no_follow
        ret = LibXAttr.lgetxattr(path, name, ptr, size)
      else
        ret = LibXAttr.getxattr(path, name, ptr, size)
      end
      check_and_raise_io_error("Failed to get xattr", ret)

      String.new(ptr)
    end

    def self.get(path : String, name : String, no_follow = false)
      size = get_size(path, name, no_follow: no_follow)
      get(path, name, size, no_follow: no_follow)
    end

    def self.set(path : String, name : String, value : String, no_follow = false, only_create = false, only_replace = false)
      flags = 0
      # If both FLAG_CREATE and FLAG_REPLACE are set
      # then it raises ENODATA if attribute not exists
      # and EEXIST if attribute already exists.
      flags |= FLAG_CREATE if only_create
      flags |= FLAG_REPLACE if only_replace

      ret = if no_follow
              LibXAttr.lsetxattr(path, name, value, value.bytesize, flags)
            else
              LibXAttr.setxattr(path, name, value, value.bytesize, flags)
            end
      check_and_raise_io_error("Failed to set xattr", ret)
    end

    def self.remove(path : String, name : String, no_follow = false)
      ret = if no_follow
              LibXAttr.lremovexattr(path, name)
            else
              LibXAttr.removexattr(path, name)
            end

      check_and_raise_io_error("Failed to remove Xattr", ret)
    end

    private def self.list_size(path : String, no_follow = false)
      ret = if no_follow
              LibXAttr.llistxattr(path, nil, 0)
            else
              LibXAttr.listxattr(path, nil, 0)
            end
      check_and_raise_io_error("Failed to list xattrs", ret)

      ret
    end

    private def self.list(path : String, size : Int32, no_follow = false)
      return [] of String if size == 0

      ptr = Slice(LibC::Char).new(size)
      ret = if no_follow
              LibXAttr.llistxattr(path, ptr, size)
            else
              LibXAttr.listxattr(path, ptr, size)
            end
      check_and_raise_io_error("Failed to list xattrs", ret)

      String.new(ptr).split("\000", remove_empty: true).sort
    end

    def self.list(path : String, no_follow = false)
      size = list_size(path, no_follow: no_follow)
      list(path, size, no_follow: no_follow)
    end
  {% end %}
end
