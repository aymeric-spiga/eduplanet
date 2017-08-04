#! /usr/bin/env python
# use: ./TOOLS/windvelocity.py resultat.nc

from ppclass import pp
from ppplot import plot2d
import numpy as np

# arguments
from optparse import OptionParser ### TBR by argparse
parser = OptionParser()
(opt,args) = parser.parse_args()
if len(args) == 0: args = "resultat.nc"
fi=args
##################################################
# PARAMETERS
##################################################
tt = 300 
lev = 980e2
vmin = 0. ; vmax = 15.
##################################################
#fi = "/home/aymeric/Big_Data/DATAPLOT/diagfired.nc"
#tt = 0.7 ; lev = 1 ; vmin = None ; vmax = None
#planet = planets.Mars
##################################################

vitu,x,y,z,t = pp(file=fi,var="u",t=tt,z=lev,verbose=True,changetime="correctls").getfd()
vitv,x,y,z,t = pp(file=fi,var="v",t=tt,z=lev,verbose=True,changetime="correctls").getfd()

windvel = (vitu**2. + vitv**2.)**0.5

p = plot2d()
p.f = windvel
p.x = x
p.y = y
p.proj = "cyl"
p.back = "coast"
p.fmt = "%.0f"
p.title = 'Wind velocity'
p.units = 'm/s'
p.colorbar = 'gist_ncar'
p.vmin = vmin
p.vmax = vmax
p.makeshow()

