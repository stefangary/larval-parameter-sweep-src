#!/bin/tcsh -f
#==========================
# For a given tcdf_most_likely
# output file, compute the number
# of positions within a given bathymetry
# interval.
#
# Stefan Gary, 2019
# This software is distributed under
# the terms of the GNU GPL v3 or later.
#=========================

#====================================
# Compute the time series for this file
#tcdf_most_likely -S -I $1
# This was done get_area_metrics, same
# command to create the input file for
# this script as well.
#====================================

# For deliverable, go to 185 days only
# Every 5 days, 185/5 = 37, that's the 
# cut off instead of 73 (1 year)

# We want to get the probability that
# a larval particle gets close enough to
# the bottom within a bottom depth range.
# The bottom depth range is set by the
# mask (1 for livable and 0 for not livable).
# The total number of positions close
# to the bottom are obtained by summing
# along the 3rd dimension (time up to 185 days)
# and x and y in the khist variable.
# The total number of all positions are
# obtained similarly from the hist variable.

ln -sv $1 hist.nc
pyferret -nojnl <<EOF
use hist.nc
use bott.nc
let bath_mask = if (bott[d=2] gt 200 and bott[d=2] lt 2200) then 1 else 0
let all_pts = hist[d=1,i=@SUM,j=@SUM,k=1:37@SUM]
let tmp = hist[d=1,k=1:37@SUM]*bath_mask
let bath_pts = tmp[i=@SUM,j=@SUM]
let inbath = 100.0*bath_pts/all_pts
list /file=out.tmp.txt /nohead /clobber inbath
quit

EOF

# Clean up
rm -f hist.nc

# Overwrite existing text output file (if present)
mv -f out.tmp.txt ${1}.br.out.txt
