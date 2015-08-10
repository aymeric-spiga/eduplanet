#! /usr/bin/env python

from ppclass import pp
from ppplot import plot2d
import numpy as np
import planets

##################################################
fi = "resultat.nc"
tt = 300 
lev = 0.9e5
planet = planets.Earth
vmin = 900. ; vmax = 1100.
##################################################
#fi = "/home/aymeric/Big_Data/DATAPLOT/diagfired.nc"
#tt = 0.7 ; lev = 1 ; vmin = None ; vmax = None
#planet = planets.Mars
##################################################

temp,x,y,z,t = pp(file=fi,var="temp",t=tt,z=lev,verbose=True).getfd()

ps = pp(file=fi,var="ps",t=tt).getf()

z = pp(file=fi,var="phisinit",t=tt).getf() / planet.g

H = planet.H(T0=temp)

plev = ps*np.exp(z/H)

p = plot2d()
p.f = plev/1.e2
p.x = x
p.y = y
p.proj = "cyl"
p.back = "coast"
p.fmt = "%.0f"
p.title = 'Sea-level surface pressure'
p.units = 'hPa'
p.colorbar = 'gist_ncar'
p.vmin = vmin
p.vmax = vmax
p.makeshow()
