[![Build Status](https://travis-ci.org/x12ruby/x12.png)](https://travis-ci.org/x12ruby/x12)
# ANSI X12 parser in Ruby

This is a fork of the project from http://www.appdesign.com/x12parser/, with the following changes:

* All the gem info has been changed to use bundler
* Everything has been renamed to be lower case and work on case sensitive systems
* Fixed some bugs that were limiting the types of documents that could be parsed
* Switched from REXML to Nokogiri which makes it a gazillion times faster

Changes welcome, especially new document types or better tests.

## Using it
Please note! I don't control the `x12` gem but am working on it. Until then, add

```Ruby
gem "x12", git:  'https://github.com/x12ruby/x12.git'
```

to your Gemfile and run `bundle install`.

## Generating a document

```ruby
parser = X12::Parser.new('misc/997.xml').factory('997')
# Explicitly
parser.ST.TransactionSetIdentifierCode = 997
# With a block
parser.AK1 do |ak1|
  ak1.FunctionalIdentifierCode = 'HS'
  ak1.GroupControlNumber       = 293328532
end

document_as_string = parser.render
```

## Parsing a document

```ruby
parser = X12::Parser.new('misc/997.xml').parse('997', document_as_string)
puts parser.L1000.L1010
```

# Contributing

We welcome patches. Please:

* Fork the repo
* Run tests (`bundle ; rake`) to make sure they work on your machine
* Make a change and include appropriate tests. If your change is to add a new document type, a function test can be used
* Submit a pull request
