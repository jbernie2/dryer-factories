#!@shell@

# login to github
# get version of library
# fail if version of library has already been released
# create new release for version

@gh@ auth login --hostname github.com

gem_version=$(@ruby@ -e '
  require "rubygems"
  puts Gem::Specification::load("@gemspec_path@").version
')
release_version="v$gem_version"
@gh@ release create $release_version --generate-notes
