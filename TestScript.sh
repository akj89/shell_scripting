#!/bin/bash

echo "Hello World"
a=abc
echo "$a"

action=$1
case $action in
  a) echo -e "/e[32m Testing green/e[0m";;
  b) echo  -e "\e[31m Testing red/e[0m" ;;
  *) echo  -e "\e[33m Testing yellow\e[0m" ;;

esac

exit 0