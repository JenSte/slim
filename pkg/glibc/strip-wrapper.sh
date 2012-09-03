#!/bin/bash

for f in "$@"
do
	OLDMODE=`stat --format=%a $f`

	chmod +w $f

	${CROSS_COMPILE}strip $f

	chmod $OLDMODE $f
done
