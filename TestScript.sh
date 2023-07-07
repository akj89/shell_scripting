#!/bin/bash

echo "Hello World"
a=abc
echo "$a"

action=$1
case $action in
  a) echo -e "\e[32m Testing green\e[0m";;
  b) echo  -e "\e[31m Testing red\e[0m" ;;
  *) echo  -e "\e[33m Testing yellow\e[0m" ;;

esac



code=1
for color in red green blue yellow Magenta Cyan; do
    case $color in
      red) code="\e[41m" ;;
      green) code="\e[42m" ;;
      yellow) code="\e[43m" ;;
      blue) code="\e[44m" ;;
      Magenta) code="\e[45m" ;;
      Cyan) code="\e[46m" ;;
    esac
    echo -e "$code Check BG color is $color\e[0m"
done

echo $0
echo $1
echo $2
echo $$
echo $*
echo $#
echo $?

exit 0