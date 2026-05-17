#!/bin/bash
DOWN=$(printf '\uf175')
UP=$(printf '\uf176')
/usr/share/i3blocks/bandwidth | sed "s/IN /$DOWN /;s/OUT /$UP /"
