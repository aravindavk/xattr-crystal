# Crystal bindings for Linux/Unix Extended attributes

Add the dependency to your shard.yml:

```yaml
dependencies:
  xattr:
    github: aravindavk/xattr-crystal
```

## Usage

```crystal
require "xattr"

File.touch("sample.txt")

# List all the Xattrs from the file
puts XAttr.list("sample.txt")

# Set new Xattr
XAttr.set("sample.txt", "user.name", "aravindavk")
XAttr.set("sample.txt", "user.repo", "xattr-crystal")
puts XAttr.list("sample.txt")

# Get a specific xattr
puts XAttr.get("sample.txt", "user.name")

# Remove a Xattr
XAttr.remove("sample.txt", "user.name")
XAttr.remove("sample.txt", "user.repo")
```

Access Xattr methods from the File object

```crystal
require "xattr"

File.touch("sample.txt")
myfile = File.new("sample.txt")
puts myfile.listxattr
myfile.setxattr("user.name", "aravindavk")
myfile.setxattr("user.repo", "xattr-crystal")
puts myfile.listxattr
puts myfile.getxattr("user.name")
myfile.removexattr("user.name")
myfile.removexattr("user.repo")
puts myfile.listxattr
```

Access Xattr methods from the Dir object

```crystal
require "xattr"

Dir.mkdir_p("sample_dir")
mydir = Dir.new("sample_dir")
puts mydir.listxattr
mydir.setxattr("user.name", "aravindavk")
mydir.setxattr("user.repo", "xattr-crystal")
puts mydir.listxattr
puts mydir.getxattr("user.name")
mydir.removexattr("user.name")
mydir.removexattr("user.repo")
puts mydir.listxattr
```

Symlink Xattrs (Only if the platform allows it)

```crystal
require "xattr"

File.touch("sample1.txt")
File.symlink("sample1.txt", "sample2.txt")

XAttr.set("sample2.txt", "user.name", "symlink", no_follow: true)
puts XAttr.list("sample1.txt")
puts XAttr.list("sample2.txt")
puts XAttr.list("sample2.txt", no_follow: true)
begin
    puts XAttr.get("sample2.txt", "user.name")
rescue Exception
    puts "No Xattrs"
end
puts XAttr.get("sample2.txt", "user.name", no_follow: true)
XAttr.remove("sample2.txt", "user.name", no_follow: true)
```

Using Only Create and Only Replace options

```crystal
require "xattr"

File.touch("sample.txt")
XAttr.set("sample.txt", "user.name", "Name1")

# Overwrites the user.name xattr
XAttr.set("sample.txt", "user.name", "Name2")

# This will succeed only if user.name xattr exists, and fails
# if user.name xattr doesn't exists.
XAttr.set("sample.txt", "user.name", "Name3", only_replace: true)

# This will succeed only if user.repo xattr doesn't exists
XAttr.set("sample.txt", "user.repo", "xattr-crystal", only_create: true)
```

## Contributing

- Fork it (https://github.com/aravindavk/xattr-crystal/fork)
- Create your feature branch (`git checkout -b my-new-feature`)
- Commit your changes (`git commit -asm 'Add some feature'`)
- Push to the branch (`git push origin my-new-feature`)
- Create a new Pull Request

## Contributors

- [Aravinda Vishwanathapura](https://github.com/aravindavk) - Creator and Maintainer
