require "./linux"
require "./darwin"

module Xattrs
end

module FileDirXattrMethods
  def get(name : String, no_follow = false)
    Xattrs.get(@path, name, no_follow: no_follow)
  end

  def set(name : String, value : String, no_follow = false, only_create = false, only_replace = false)
    Xattrs.set(@path, name, value, no_follow: no_follow, only_create: only_create, only_replace: only_replace)
  end

  def remove(name : String, no_follow = false)
    Xattrs.remove(@path, name, no_follow: no_follow)
  end

  def listxattr(no_follow = false)
    Xattrs.list(@path, no_follow: no_follow)
  end
end

class File
  include FileDirXattrMethods
end

class Dir
  include FileDirXattrMethods
end
