#!/bin/bash

function usage {
   echo "Usage: `basename $0` -p[room number] -s(single sided) [file]"
   exit 0
}

USERNAME="CHANGE THIS"
SERVER="moon.scs.ryerson.ca"
DESTDIR="~"
SINGLESTRING="-single"

destfile=""
printer=""
file=""
single=1

while getopts "p:s" o; do
   case "${o}" in
      p)
         printer=${OPTARG}
         ;;
      s)
         single=0
         ;;
   esac
done

file="${@: -1}"

if [ -z "$file" ];
then
   echo "ERROR: No file specified."
   usage
   exit 1
fi

if [ -z "$printer" ];
then
   echo "No printer specified. \nRequires -p202 OR -p206."
   usage
   exit 1
fi

destfile=`basename $file`
echo "printing in $printer $single, file: $DESTDIR/$destfile"
echo "Printing in ENG-$printer"

if [ "$single" -eq 0 ];
then
   echo "Single sided."
else
   echo "Double sided."
fi

echo "File: $file copied to: $DESTDIR/$destfile"

scp $file $USERNAME@$SERVER:$DESTDIR/

if [ "$single" -eq 0 ] ;
then
   ssh $USERNAME@$SERVER "lpr -Peng$printer-single $DESTDIR/$destfile"
else
   ssh $USERNAME@$SERVER "lpr -Peng$printer $DESTDIR/$destfile"
fi


