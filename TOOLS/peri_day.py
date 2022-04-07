#! /usr/bin/env python
import math
#------------------------------------------------------------------
# Calcul des parametres apoastr, periastr et peri_day
# du fichier reglages_init.txt
#------------------------------------------------------------------

# PARAMETRES A RENSEIGNER:
#------------------------------------------------------------------

distUA = input("Mean distance to star in astro unit (Earth 1.0):")
distUA = float(distUA)
ecc = input("Orbit's excentricity (Earth e = 0.0167 ):")
ecc = float(ecc)
Lp = input("Solar longitude of perihelion (Earth Lp = 283. ):")
Lp = float(Lp)
year_day = input("Number of days in a year (Earth year_day = 365 ):")
year_day = float(year_day)

#------------------------------------------------------------------
#------------------------------------------------------------------
# CALCULS ET AFFICHAGE DES RESULTATS - !!! NE PAS MODIFIER !!!

astrunit = 149.597871
dist = distUA*astrunit
teta = (math.pi/180.)*(360.-Lp)
xo = 2.*math.atan(math.sqrt((1.-ecc)/(1.+ecc))*math.tan(teta/2.))
xref = xo - ecc*math.sin(xo)

peri_day = year_day*(1.-xref/(2.*math.pi))

if peri_day >= year_day:
    peri_day = peri_day - year_day

print("peri_day = "+str(peri_day))
print("periastr = "+str(distUA*(1-ecc)))
print("apoastr  = "+str(distUA*(1+ecc)))

# Remarque: equinoxe printemps date --date=3/20/2010 '+%j'
#------------------------------------------------------------------
#------------------------------------------------------------------
