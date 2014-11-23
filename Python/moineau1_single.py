#!/usr/bin/python

"""Moineau Pump Profile Generator
Generate dxfs of Moineau pump startor and rotor profiles

Copyright   2014, James K. Larson
Version     v0.01 (09/06/14)
License     GPL
Homepage    

9/06/14    Initial Creation          -jkl
This version creates a single lobe rotor.

Credit to:
	Thingiverse Moineau Design for inspiration:
	http://www.thingiverse.com/thing:15538
	http://www.thingiverse.com/thing:15167
	(Note there are others that inspired these.)
	
	Explanations of Moineau Operation:
	http://www2.mat.dtu.dk/people/J.Gravesen/MoineauPump/
	
	Explanations of cycloid geometry:
	http://en.wikipedia.org/wiki/Hypocycloid
	http://en.wikipedia.org/wiki/Epicycloid

    Documenting and updating the sdxf library
    http://www.kellbot.com/sdxf-python-library-for-dxf/

Notes:
    Does not currently do ANY checking for sane input values; use at your own risk

"""

import getopt
import sys
import sdxf
import math


#
#	Enter values here to run within the Python IDE.
# 

# Step one: Create a simple profile and save it to a file.

dxf=sdxf.Drawing()

dxf.layers.append(sdxf.Layer(name="TEXT", color=2) )    #yellow text layer
dxf.layers.append(sdxf.Layer(name="ROTOR", color=1) )     #red rotor layer
dxf.layers.append(sdxf.Layer(name="STATOR", color=5) )  #blue stator layer

# Add text to describe the design
# later dxf.append( sdxf.Text( "lobes="       +str(l), point=(p*n+d, 0.7), layer="text", height=0.1) )

# angle steps = lines in dxf profiles
s = 100
q=2*math.pi/float(s)

#generate the rotor profile
#xhypo(th) := 3*cos(th) + cos(3*th) $
def xhypo(t):
    return math.cos(t)+math.cos(t)
	
#yhypo(th) := 3*sin(th) - sin(3*th) $
def yhypo(t):
    return math.sin(t)- math.sin(t)
	
#xepi(th) := 5*cos(th) - cos(5*th) $
def xepi(t):
    return 3*math.cos(t)-math.cos(3*t)

#yepi(th) := 5*sin(th) - sin(5*th) $
def yepi(t):
    return 3*math.sin(t)- math.sin(3*t)
	
def x(t):
	if t >= 0 and t < math.pi:
		return xhypo(t)
	else:
		return xepi(t)
		
def y(t):
	if t >= 0 and t < math.pi:
		return yhypo(t)
	else:
		return yepi(t)
	
#plot2d([[parametric,xctr(t),yctr(t),[t,0,2*%pi]],[parametric,xhypo(t),yhypo(t),[t,0,2*%pi]]],[nticks,80])

i=0
x1 = x(q*i)
y1 = y(q*i)
# s is the number of steps, q is 2 pi divided by s
for i in range(0, s):
        x2 = x(q*(i+1))
        y2 = y(q*(i+1))
        dxf.append( sdxf.Line(points=[(x1,y1),  (x2,y2)], layer="ROTOR" ) )
        x1 = x2
        y1 = y2

# need a file name
f = "moinSingle.dxf"

try:
        dxf.saveas(f)
except:
        print("File save error!")
        sys.exit(2)


