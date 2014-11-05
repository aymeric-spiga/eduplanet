#! /usr/bin/env python
import math
#------------------------------------------------------------------
# Calcul des parametres apoastr, periastr et peri_day
# du fichier reglages_init.txt
#------------------------------------------------------------------

# PARAMETRES A RENSEIGNER:
#------------------------------------------------------------------
# Distance moyenne de la planete d (en unites astronomiques):
distUA = 1.
# Excentricite de l'orbite e (Terre: e = 0.0167) :
ecc = 0.0167
# Longitude solaire du perihelie Lp (Terre: Lp = 283.) :
Lp = 283.
# Nombre de jours dans l'annee:
#  (voir year_day dans reglages_init.txt)
year_day = 365.
#------------------------------------------------------------------
#------------------------------------------------------------------
# CALCULS ET AFFICHAGE DES RESULTATS - !!! NE PAS MODIFIER !!!

astrunit = 149.597871
dist = distUA*astrunit
teta = (math.pi/180.)*(360.-Lp)
xo = 2.*math.atan(math.sqrt((1.-ecc)/(1.+ecc))*math.tan(teta/2.))
xref = xo - ecc*math.sin(xo)

peri_day = year_day*(1.-xref/(2.*math.pi))

if peri_day > year_day:
    peri_day = peri_day - year_day

print "peri_day = %.2f days" % (peri_day)
print "periastr = %.2f UA" % (distUA*(1-ecc))
print "apoastr  = %.2f UA" % (distUA*(1+ecc))

# Remarque: equinoxe printemps date --date=3/20/2010 '+%j'
#------------------------------------------------------------------
#------------------------------------------------------------------
