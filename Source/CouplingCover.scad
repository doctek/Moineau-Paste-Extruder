//
// Moineau Pump Coupling Cover
/ Licensed under the Creative Commons - GNU GPL license. 
// � 2014 by James K. Larson (aka Doctek)
//
// 11/9/14   Initial Creation
//

$fn=100;
gap = 43;	// distance between Hypocycloid gear box and Moineau chamber.
module cover ()
{
	union()
	{
		difference()
		{
			cylinder(r = 36,gap,center=false);
			translate([0,0,-1]) cylinder(r = 33,gap+2,center=false);
			for ( i = [0 : 4] )
			{
			    rotate([0,-90,(i * 360 / 4)]) 
			    translate([20,0,20]) 
		            window();
			}
		}
		for ( i = [0 : 4] )
		{
		    rotate(i * 360 / 4,[0, 0, 1])
		    translate([0, 30, 0])
		   nutHolder();
		}
		for ( i = [0 : 4] )
		{
		    //rotate(i * 360 / 4,[0, 0, 1])
		    rotate([0, 180, (i * 360 / 4)+45])
		    translate([0, 30, -gap])
		   nutHolder();
		}
	}
}

module nutHolder()
{
	rotate([0,0,180])
	difference()
	{
		translate([-5.8,-3,0])
		cube([11.6,6,10]);
		translate([-2.8,-3,4])
		cube([5.6,6,7]);
		cylinder(r=1.4,6,center=false);
		translate([-10,3,4]) rotate([0,-90,180])
		linear_extrude(height = 20, center = false, convexity = 10, $fn = 100)
		triangle();
	}
}

// Window so we can see the Schmidt coupling (optional)
module window()
{
	union()
	{
		difference()
		{
			cylinder(r=10,20,center=false);
			translate([0,-10,0])
			cube([20,20,20]);
		}
		rotate([0,0,45])
		translate([-7.07,-7.07,0])
		
		cube([14.14,14.14,20]);
	}
}

module triangle()
{
	polygon( points=[[0,0],[10,0],[10,10],[0,0]] );
}
cover();
//nutHolder();
//window();