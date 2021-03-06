#!/bin/sh
# This scripts generates a devhelp meta file using the TOC and .idx files
# generated by texi2html
#
# written by Tobias Gruetzmacher <devhelp@portfolio16.de>
#
# Example usage:
# texi2html -Verbose -split=section -idx_sum -subdir=doc/devhelp/autoconf-2.59 doc/autoconf.texi
# gen-meta-devhelp.sh doc/devhelp/autoconf-2.59 autoconf Autoconf 2.59
# rm doc/devhelp/autoconf-2.59/*.idx

if [ "$#" -ne 4 ]
then
	echo "Syntax: `basename $0` <directory> <name> <book title> <version>"
	exit 1
fi

dir=$1
name=$2
title=$3
ver=$4

exec > $dir/$name-$ver.devhelp

cat <<EOF
<?xml version="1.0"?>

<book name="$name" version="$ver" title="$title" link="${name}_toc.html">

<chapters>
EOF

sed -n '1, /^<H1>/ d
	/^<HR/, $ d
	/^<BR>$/ N
	s/^<BR>\n<BLOCKQUOTE>$//
	s/^<BR>/<\/sub>/
	s/<\/\?\(TT\|CODE\|FONT\)[^>]*>//ig
	s/<A.*HREF=\("[^"]*"\)>\(.*\)<\/A>/<sub name="\2" link=\1>/p
	s/<\/BLOCKQUOTE>$/<\/sub>/p' $dir/${name}_toc.html | sed '$d'

cat <<EOF
</chapters>

<functions>
EOF

sed	's/&/\&amp;/g; s/"/\&quot;/g; s/</\&lt;/g; s/>/\&gt;/g
	 s/^/<function name="/
	 s/\t/" link="/
	 s/$/"\/>/' $dir/*.idx

cat <<EOF
</functions>

</book>
EOF

