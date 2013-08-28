#!/bin/bash

bundle exec rerun --pattern '*.{rb,js,coffee,css,scss,sass,erb,html,haml,ru}' 'ruby index.rb'
