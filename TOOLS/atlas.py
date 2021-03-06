#! /usr/bin/env python
# A. Spiga 06-08/14 
from ppclass import pp

# arguments
from optparse import OptionParser ### TBR by argparse
parser = OptionParser()
(opt,args) = parser.parse_args()
if len(args) == 0: args = "resultat.nc"

fi=args

#t = pp(var="tsurf",file=fi,x="-180,180",y=-80,superpose=True,quiet=True,ylabel=r'surface temperature ($^{\circ}$C)',legend="lat=-80",changetime="correctls",fmt="%.1f").get()-273.15
#t.plot(extraplot=3)
#t2 = pp(var="tsurf",file=fi,x="-180,180",y=-60,superpose=True,quiet=True,ylabel=r'surface temperature ($^{\circ}$C)',legend="lat=-60",plotin=t,changetime="correctls",fmt="%.1f").get()-273.15
#t2.plot()
#t2 = pp(var="tsurf",file=fi,x="-180,180",y=-20,superpose=True,quiet=True,ylabel=r'surface temperature ($^{\circ}$C)',legend="lat=-20",plotin=t,changetime="correctls",fmt="%.1f").get()-273.15
#t2.plot()
#t2 = pp(var="tsurf",file=fi,x="-180,180",y=0,superpose=True,quiet=True,ylabel=r'surface temperature ($^{\circ}$C)',legend="lat=0",plotin=t,changetime="correctls",fmt="%.1f").get()-273.15
#t2.plot()

t = pp()
t.var = "tsurf"
t.file = fi
t.x = "-180,180"
t.y = -80 ## latitude
t.superpose = True
t.quiet = True
t.ylabel = r'surface temperature ($^{\circ}$C)'
t.legend = "lat="+str(t.y)
t.changetime = "correctls"
t.fmt="%.1f"
t.ymin = -100.
t.ymax = 60.
t = t.get() - 273.15
t.plot(extraplot=3)

t2 = pp()
t2 << t
t2.y = -60
t2.legend = "lat="+str(t2.y)
t2 = t2.get() - 273.15
t2.plotin = t
t2.plot()

t2 = pp()
t2 << t
t2.y = -20
t2.legend = "lat="+str(t2.y)
t2 = t2.get() - 273.15
t2.plotin = t
t2.plot()

t2 = pp()
t2 << t
t2.y = 0
t2.legend = "lat="+str(t2.y)
t2 = t2.get() - 273.15
t2.plotin = t
t2.plot()

p = pp(var="tsurf",file=fi,x="-180,180",y="-90,90",quiet=True,superpose=True,compute="meanarea",ylabel="globally-averaged surface temperature (K)",changetime="correctls",fmt="%.1f").getplot()

p = pp(var="ISR",file=fi,x="-180,180",quiet=True,changetime="correctls").getplot(extraplot=3)
p2 = pp(var="ASR",file=fi,x="-180,180",plotin=p,quiet=True,changetime="correctls").getplot()
p2 = pp(var="OLR",file=fi,x="-180,180",plotin=p,quiet=True,changetime="correctls").getplot()
p2 = pp(var="tsurf",file =fi,x="-180,180",plotin=p,quiet=True,units=r'$^{\circ}$C',changetime="correctls").get()-273.15
p2.vmin = -90. ; p2.vmax = 60. ; p2.div = 12 ; p2.plot()

q = pp(var="temp",file=fi,x=0,t=360+90,quiet=True,logy=True,changetime="correctls").getplot(extraplot=1)
q2 = pp(var="temp",file=fi,x=0,t=360+270,plotin=q,quiet=True,logy=True,changetime="correctls").getplot()

## just for ref
#u'zdtsw', u'zdtlw', u'dtrad', u'h2o_ice', u'h2o_ice_surf', u'h2o_ice_col', u'tau_col', u'h2o_vap', u'h2o_vap_surf', u'h2o_vap_col'
