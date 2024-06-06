#!/bin/env fish
cat software.txt | string split " " | sort | string join ' ' >software.txt
