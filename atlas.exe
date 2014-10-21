#! /usr/bin/env python
# A. Spiga 06-08/14 
from ppclass import pp

# arguments
from optparse import OptionParser ### TBR by argparse
parser = OptionParser()
(opt,args) = parser.parse_args()
if len(args) == 0: args = "resultat.nc"

fi=args

t = pp(var="tsurf",file=fi,x="-180,180",y=[-80,-60,-20,0],superpose=True,quiet=True,ylabel=r'surface temperature ($^{\circ}$C)').get()-273.15
t.plot()

p = pp(var="tsurf",file=fi,x="-180,180",y="-90,90",quiet=True,superpose=True,compute="meanarea",ylabel="globally-averaged surface temperature (K)").getplot()

p = pp(var="ISR",file=fi,x="-180,180",quiet=True).getplot(extraplot=3)
p2 = pp(var="ASR",file=fi,x="-180,180",plotin=p,quiet=True).getplot()
p2 = pp(var="OLR",file=fi,x="-180,180",plotin=p,quiet=True).getplot()
p2 = pp(var="tsurf",file =fi,x="-180,180",plotin=p,quiet=True,units=r'$^{\circ}$C').get()-273.15
p2.vmin = -90. ; p2.vmax = 30. ; p2.div = 12 ; p2.plot()

q = pp(var="temp",file=fi,x=0,t=360+90,quiet=True,logy=True).getplot(extraplot=1)
q2 = pp(var="temp",file=fi,x=0,t=360+270,plotin=q,quiet=True,logy=True).getplot()

## just for ref
#u'zdtsw', u'zdtlw', u'dtrad', u'h2o_ice', u'h2o_ice_surf', u'h2o_ice_col', u'tau_col', u'h2o_vap', u'h2o_vap_surf', u'h2o_vap_col'
