// 
// 11/6/14 - Middle disk for Schmidt coupling for Moineau pump.
/ Licensed under the Creative Commons - GNU GPL license. 
// � 2014 by James K. Larson (aka Doctek)
//

$fn=100;

module disk()
{
	union()
	{
		difference()
		{
			translate([0,0,0]) rotate([0,0,0]) cylinder(r=16,6.9,center=false);
			translate([0,0,0]) rotate([0,0,0]) cylinder(r=7,10,center=false);
			for ( i = [0 : 3] )
			{
			    rotate(i * 360 / 3,[0, 0, 1])
			    translate([0, 11.18, 0])
			   cylinder(r = 1.1,10,center=false);
			}
	
		}
		//translate([-16,-16,0]) cube([32,32,1]);
	}

}

disk();