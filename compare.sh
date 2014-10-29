#! /bin/bash

pp.py -S -v tsurf -y 20. -y 60. -x 0. $1 $2


pp.py -S -v tsurf -y "-90.,90." -x "-180.,180." -u meanarea $1 $2
