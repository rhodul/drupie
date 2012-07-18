#!/bin/bash

usage() {
  printf "Usage: `basename $0` -s|--mysql-password<value> [-h|--help]\n";
}

if [ $(whoami) != "root" ];
  then
  printf "Warning: `basename $0` must be run by root.  Exiting...\n";
  exit 1
fi

# parse arguments
TEMP=`getopt -o hs: --long help,mysql-password: \
     -n \`basename $0\` -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

while true ; do
	case "$1" in
    -h|--help)
      usage;
      exit 0;
    ;;
    -s|--mysql-password)
      MYSQL_PWD="$2"; shift 2; continue;
    ;;
    --)
      # no more arguments to parse
      break
    ;;
    *)
      printf "Unknown option %s\n" "$1"
      exit 1
    ;;
	esac
done

if [ "$MYSQL_PWD" == "" ];
  then
  printf "Error: MySql root password is required.\n";
  usage;
  exit 1
fi

apt-get install puppet-common;

# pass MySql pwd to puppet as a variable;
# we also have to pass current directory, because puppet
# only supports full paths, not relative
FACTER_mysqlpwd=$MYSQL_PWD FACTER_workingdirectory=$PWD puppet apply lampanddrupal.pp