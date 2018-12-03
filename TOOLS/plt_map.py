#! /usr/bin/env python

from ppclass import pp
from ppplot import plot2d
import numpy as np
import scipy.stats
import matplotlib.pyplot as plt
import math as m

# arguments
from optparse import OptionParser ### TBR by argparse
parser = OptionParser()
(opt,args) = parser.parse_args()
if len(args) == 0: args = "resultat.nc"
fi=args

# Choix des donnees
#------------------------------------------------------------------
tt = 1530.
fluxsurf,x,y,z,t = pp(file=fi,var="ISR",t=tt,changetime="correctls").getfd()
tsurf = pp(file=fi,var="tsurf",t=tt,changetime="correctls").getf()
#------------------------------------------------------------------

# Pour tracer des cartes
#------------------------------------------------------------------
p = plot2d()
p.f = tsurf
p.c = fluxsurf
p.x = x
p.y = y
p.fmt = "%.2f"
#p.vmin=990.
#p.vmax=1030.
#p.vx = u10m
#p.vy = v10m
#p.svx = 1
#p.svy = 1
p.title = 'ISR and surface temperature'
p.units = 'W/m2 and K'
# For colors, see https://matplotlib.org/1.4.3/users/colormaps.html
p.colorbar = 'jet'
p.clab = True # contour ON/OFF
p.cfmt = "%.2f" # format contour
#p.clev = [0.5]
p.makeshow()
#------------------------------------------------------------------
