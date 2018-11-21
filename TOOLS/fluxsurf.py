#! /usr/bin/env python

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
# REGLAGES
##################################################
tt = 120.
vmin = 0. ; vmax = 1400.
##################################################
lev = 1013e2

temp,x,y,z,t = pp(file=fi,var="temp",t=tt,z=lev,verbose=True,changetime="correctls").getfd()

albedo = pp(file=fi,var="ALB",t=tt,changetime="correctls").getf()
fluxabs = pp(file=fi,var="ASR",t=tt,changetime="correctls").getf()

fluxrecu = fluxabs / (1.-albedo)

p = plot2d()
p.f = fluxrecu
p.x = x
p.y = y
p.proj = "cyl"
p.back = "coast"
p.fmt = "%.0f"
p.title = 'Surface insolation'
p.units = 'W/m2'
p.colorbar = 'gist_ncar'
p.vmin = vmin
p.vmax = vmax
p.makeshow()

