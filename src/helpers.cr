module Xattrs
  def self.check_and_raise_io_error(msg, ret, err_ret = -1)
    raise IO::Error.from_errno(msg) if ret == err_ret
  end
end
