require "./linux"
require "./darwin"

module Xattr
end

module FileDirXattrMethods
  def get(name : String, no_follow = false)
    Xattr.get(@path, name, no_follow: no_follow)
  end

  def set(name : String, value : String, no_follow = false, only_create = false, only_replace = false)
    Xattr.set(@path, name, value, no_follow: no_follow, only_create: only_create, only_replace: only_replace)
  end

  def remove(name : String, no_follow = false)
    Xattr.remove(@path, name, no_follow: no_follow)
  end

  def listxattr(no_follow = false)
    Xattr.list(@path, no_follow: no_follow)
  end
end

class File
  include FileDirXattrMethods
end

class Dir
  include FileDirXattrMethods
end
