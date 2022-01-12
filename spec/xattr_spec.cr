require "file_utils"

require "./spec_helper"

describe XAttr do
  Spec.before_each do
    FileUtils.rm_rf(TESTDIR)
    Dir.mkdir_p(TESTDIR)
  end

  describe "get" do
    it "matches the Value of xattr to set value" do
      File.touch(SAMPLE_FILE)
      XAttr.set(SAMPLE_FILE, "user.name", "demo")
      XAttr.get(SAMPLE_FILE, "user.name").should eq "demo"
    end

    it "matches the Value of xattr to set value (File)" do
      File.touch(SAMPLE_FILE)
      file = File.new(SAMPLE_FILE)
      file.setxattr("user.name", "demo")
      file.getxattr("user.name").should eq "demo"
    end

    it "matches the Value of xattr to set value (Dir)" do
      Dir.mkdir(SAMPLE_DIR)
      d = Dir.new(SAMPLE_DIR)
      d.setxattr("user.name", "demo")
      d.getxattr("user.name").should eq "demo"
    end
  end

  describe "set" do
    it "sets the xattr user.name=demo" do
      File.touch(SAMPLE_FILE)
      XAttr.set(SAMPLE_FILE, "user.name", "demo")
      XAttr.get(SAMPLE_FILE, "user.name").should eq "demo"
    end

    it "sets the xattr user.name=demo (File)" do
      File.touch(SAMPLE_FILE)
      file = File.new(SAMPLE_FILE)
      file.setxattr("user.name", "demo")
      file.getxattr("user.name").should eq "demo"
    end

    it "sets the xattr user.name=demo (Dir)" do
      Dir.mkdir(SAMPLE_DIR)
      d = Dir.new(SAMPLE_DIR)
      d.setxattr("user.name", "demo")
      d.getxattr("user.name").should eq "demo"
    end
  end

  describe "list" do
    it "validates the xattr.list" do
      File.touch(SAMPLE_FILE)
      XAttr.set(SAMPLE_FILE, "user.name", "demo")
      xattrs = XAttr.list(SAMPLE_FILE)

      xattrs.should be_a(Array(String))
      xattrs.size.should eq 1
      xattrs[0].should eq "user.name"
    end

    it "validates the xattr.list (File)" do
      File.touch(SAMPLE_FILE)
      file = File.new(SAMPLE_FILE)
      file.setxattr("user.name", "demo")
      xattrs = file.listxattr

      xattrs.should be_a(Array(String))
      xattrs.size.should eq 1
      xattrs[0].should eq "user.name"
    end

    it "validates the xattr.list (Dir)" do
      Dir.mkdir(SAMPLE_DIR)
      d = Dir.new(SAMPLE_DIR)
      d.setxattr("user.name", "demo")
      xattrs = d.listxattr(SAMPLE_FILE)

      xattrs.should be_a(Array(String))
      xattrs.size.should eq 1
      xattrs[0].should eq "user.name"
    end
  end

  describe "remove" do
    it "checks if the xattr is removed" do
      File.touch(SAMPLE_FILE)
      XAttr.set(SAMPLE_FILE, "user.name", "demo")
      XAttr.remove(SAMPLE_FILE, "user.name")
      XAttr.list(SAMPLE_FILE).size.should eq 0
    end

    it "checks if the xattr is removed (File)" do
      File.touch(SAMPLE_FILE)
      file = File.new(SAMPLE_FILE)
      file.setxattr("user.name", "demo")
      file.removexattr("user.name")
      file.listxattr.size.should eq 0
    end

    it "checks if the xattr is removed (Dir)" do
      Dir.mkdir(SAMPLE_DIR)
      d = Dir.new(SAMPLE_DIR)
      d.setxattr("user.name", "demo")
      d.removexattr("user.name")
      d.listxattr.size.should eq 0
    end
  end
end
