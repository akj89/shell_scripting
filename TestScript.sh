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



bgColorCode = 1
for color in red green blue yellow Magenta Cyan; do
    case $color in
      red) bgColorCode = 41 ;;
      green) bgColorCode = 42 ;;
      yellow) bgColorCode = 43 ;;
      blue) bgColorCode = 44 ;;
      Magenta) bgColorCode = 45 ;;
      Cyan) bgColorCode = 46 ;;
    esac
    echo -e "\e[$bgColorCodem Check BG color is $color\e[0m"
done

exit 0