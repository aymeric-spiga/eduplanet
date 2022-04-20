# Changing continent albedo over a specific area

value=$1
lonmin=$2
lonmax=$3
latmin=$4
latmax=$5

cd RUN/DATAGENERIC
ferret -nojnl << eod
use "surface_earth.nc"
let newalb = if (x gt $lonmin and x le $lonmax) and (y gt $latmin and y le $latmax) and albedo gt 0.07 then $value else albedo
save/clobber/file="surface_earth_newalb.nc" newalb,thermal,zmol
quit
eod

ncrename -d LONGITUDE,longitude -d LATITUDE,latitude -v LONGITUDE,longitude -v LATITUDE,latitude -v NEWALB,albedo -v THERMAL,thermal -v ZMOL,zMOL surface_earth_newalb.nc
