#!/bin/sh

sed -n '
# extract partner ID
/^\[.*\]/, /^signed_key=/ {
	/^\[.*\]/ {
		s/^\[\(.*\)\]/\1/;h
	}
	/^signed_key=/!d
	/^signed_key=/ {
		s/^signed_key\(.*\)/\1/
		H
		g
		s/^\(.*\)\n\(.*\)$/\1\2/
		p
	}
}
' < /etc/vivipos_partners.lic
