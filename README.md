[![Build Status](https://travis-ci.org/swalberg/x12.png)](https://travis-ci.org/swalberg/x12)
# ANSI X12 parser in Ruby

This is a fork of the project from http://www.appdesign.com/x12parser/, with the following changes:

* All the gem info has been changed to use bundler
* Everything has been renamed to be lower case and work on case sensitive systems
* Stopped including REXML, which was causing problems with Rails 3 and mailer

Changes welcome, especially new document types or better tests. 
