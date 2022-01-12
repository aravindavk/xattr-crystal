require "./linux"
require "./darwin"

module XAttr
end

module FileDirXattrMethods
  def getxattr(name : String, no_follow = false)
    XAttr.get(@path, name, no_follow: no_follow)
  end

  def setxattr(name : String, value : String, no_follow = false, only_create = false, only_replace = false)
    XAttr.set(@path, name, value, no_follow: no_follow, only_create: only_create, only_replace: only_replace)
  end

  def removexattr(name : String, no_follow = false)
    XAttr.remove(@path, name, no_follow: no_follow)
  end

  def listxattr(no_follow = false)
    XAttr.list(@path, no_follow: no_follow)
  end
end

class File
  include FileDirXattrMethods
end

class Dir
  include FileDirXattrMethods
end
