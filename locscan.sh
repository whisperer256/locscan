#!/bin/bash

revision="1.8.3"

# Help function
Help()
{
    echo "Locscan help to locally identify opening port numbers from"
    echo "a giving host/ip address without being spotted by local IDS."
    echo
    echo "Syntax: locscan [-h|-u|--version]."
    echo
    echo "Options:"
    echo "-h | --help    Print this help message."
    echo "-u | --url     The given host/ip address to ports scan."
    echo "--version     This script version number."
    echo
    echo "*Only to use for educational or ethical purpose."
}


# Scan operation
lscan()
{
  url=$1
  for ip in $url;do
    for port in {1..65535}; do
        (echo >/dev/tcp/$url/$port) 2>/dev/null \
        && echo "$url:$port is open";
    done;
	done
}


# Very if there were no arguments provided to the script
if [ $# -eq 0 ]; then
  echo "No arguments provided"
  echo "*Syntax: locscan [-h|-u|--version]."
fi


# PID Keyboard interrupt, let's user interrupt the process
ctrl_c()
{
  kill $PID
  echo "User terminate process with"
  echo "[+] Keyboard interrupt."
  exit
}

trap ctrl_c SIGINT


#Get the options
while test $# -gt 0; do
  case "$1" in
    -h|--help) # Display Help
      Help
      break
      ;;
    -u|--url) #Url to scan
      shift
      if test $# -gt 0; then
        lscan ${1}
        # PID=$!
      else
        echo "No host/ip address has been specified."
      fi
      break
      ;;
    
    --version) #Print the version number
      echo "Locscan $revision"
      echo "Author: Whisperer256 ( https://twitter.com/whisperer256 )"
      break
      ;;

    *) # Invalid option
      echo "Unexpected argument"
      echo "*Syntax: locscan [-h|-u|--version]."
      break
      ;;
  esac
done