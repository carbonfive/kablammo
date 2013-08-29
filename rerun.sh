#!/bin/bash

bundle exec rerun --pattern '*.{rb,js,coffee,css,scss,sass,erb,html,haml,jbuilder,ru}' 'ruby index.rb'
