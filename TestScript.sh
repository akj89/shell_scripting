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
      red) code = $((41)) ;;
      green) code = 42 ;;
      yellow) code = 43 ;;
      blue) code = 44 ;;
      Magenta) code = 45 ;;
      Cyan) code = 46 ;;
    esac
    echo -e "\e[$codem Check BG color is $color\e[0m"
done

exit 0