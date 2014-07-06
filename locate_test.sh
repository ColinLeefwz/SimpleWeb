#! /bin/bash
renv=$RAILS_ENV
RAILS_ENV=test2
ruby test/locate_test.rb
RAILS_ENV=$renv
