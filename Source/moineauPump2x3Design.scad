// Moineau Paste Extruder
// (File: moineauPump2x3Design.scad)
// Licensed under the Creative Commons - GNU GPL license. 
// � 2014 by James K. Larson (aka Doctek)
//
// (Original file moineauPump2x3DriveDesign.scad)
//

$fn=100;

showAssy = 1;		// set to 1 to show the assembly, 0 to print parts
show = 1;	// set to zero to suppress cut-outs
explode = 1; 	// set to 1 to spread assembly apart
print_Driver = 0;
//print_Impeller = 0;
print_Chamber =0;
print_Nozzle = 0;


phi=360; // degrees of rotation of Moineau (>360)
H=30; // height
flange_thickness = 3;
e = 2; // Eccentricity
ofs = sqrt(e);
extrusionDia = 1.0;
overSize = 0.2;		// chamber oversize value: 0.30 = 30%


module impeller()
{
				linear_extrude(height = H, center = false, convexity = 20, twist=phi)
				import("moinDual.dxf", layer = "STATOR");
}


module driver()
{
	difference(){
	import("driver.stl",convexity=20);
	}
}
module buildDriver()
{
	difference(){
		union() {
			difference() {
				union(){
					translate([0,0,0]) rotate([0,0,0]) cylinder(r=16,7.5,center=false);

				}
				// Mounts for Schmidt Couplling
				for ( i = [0 : 3] )
				{
				    rotate(i * 360 / 3,[0, 0, 1])
				    translate([0, 11.18, 0])
				   cylinder(r = 1.1,10,center=false);
				}
				for ( i = [0 : 3] )
				{
				    rotate(i * 360 / 3,[0, 0, 1])
				    translate([0, 11.18, 5.7])
				   cylinder(r = 2.6,6,center=false);
				}
				
			}
			translate([0,0,7.5])
			impeller();

		}
	}
}

/*
This is done to speed things up when viewing. To build the chamber,  and
create the stl, just use the buildChamber routine.
*/
module chamber()
{
	difference(){
	import("chamber.stl",convexity=20);
	if (show == 1){
		translate([0,0,-1]) rotate([0,0,44])
		linear_extrude(height = 40, center = false, convexity = 10, $fn = 100)
		triangle();
		translate([0,0,-1]) rotate([0,0,0])
		linear_extrude(height = 40, center = false, convexity = 10, $fn = 100)
		triangle();
	}
	}
}

// Chamber needs to be scaled oversize.
module buildChamber()
{
	difference(){
		union(){
			translate([0,0,3]) cylinder(r=12.5,H-flange_thickness,center=false);
			translate([0,4,8])rotate ([0,80,80])		// Feed tube 
			feedTube(14,4,12);
			difference() {
				translate([0,0,0]) rotate([0,0,0]) cylinder(r=36,4,center=false,$fn=30);
				for ( i = [0 : 4] )
				{
				    rotate(i * 360 / 4,[0, 0, 1])
				    translate([0, 30, 0])
				   cylinder(r = 1.7,10,center=false);
				}
			}
			translate([0,0,H-flange_thickness])
			flange(20,flange_thickness,3,1);
		}
		
			scale([1+overSize,1+overSize,1.0])
			translate([0,0,0])
			rotate([0,0,-15])
				linear_extrude(height = H, center = false, convexity = 20, twist=phi*2/3, $fn = 40)
				
				import("moinTriple.dxf", layer = "STATOR");
			scale([1+overSize,1+overSize,1.0])
			translate([0,0,-0.01])
			rotate([0,0,-15])
				linear_extrude(height = 0.01, center = false, convexity = 20, $fn = 40)
				
				import("moinTriple.dxf", layer = "STATOR");
			scale([1+overSize,1+overSize,1.0])
			translate([0,0,H])
			rotate([0,0,-15])	// found by trial and error. 
				linear_extrude(height = 0.01, center = false, convexity = 20, $fn = 40)
				
				import("moinTriple.dxf", layer = "STATOR");
			translate([0,4,8])rotate ([0,80,80])		// Feed tube 
			feedTubeClrnc(len=20,depth=1);
		
	}
}
module nozzle(aperture) {
   difference() {
	   union() {
		flange(20,flange_thickness,3,0);
		translate([0, 0, flange_thickness]) cylinder(r1 = 12, r2 = 0, h = 12);
	   }
	cylinder(r = aperture, h = 18);
	translate([0,0,-0.01]) cylinder(r1 = 12, r2 = 0, h = 12);
	   	if (show == 1){
		translate([0,0,-1]) rotate([0,0,44])
		linear_extrude(height = 20, center = false, convexity = 10)
		triangle();
	}
  }
  }
 

module flange(radius, thickness, bolt_diameter, supported) {
  difference() {
    if (supported == 0) {
      cylinder(r = radius, h = thickness);
    } else {
      cylinder(r = radius, h = thickness);
      translate([0, 0, -radius])cylinder(r1 = 0, r2 = radius, h = radius);
    }
    for (i = [0 : 60 : 360]) {
      rotate(i, [0, 0, 1])
      //translate([0, radius - bolt_diameter * 1.5, 0])
	translate([0, radius - bolt_diameter * 1.5, -0.01])
      cylinder(r = bolt_diameter / 2, h = thickness+0.02);
      if (supported == 1) {
        rotate(i, [0, 0, 1])
        translate([0, radius - bolt_diameter * 1.5, -bolt_diameter * 3])
        cylinder(r = bolt_diameter, h = bolt_diameter * 3);         
      }
    }
  }
}
module feedTube(len=15,depth=10,od=16)
{
	difference() {
		cylinder(r=od/2,h=len);
		translate([0,0,len-depth])cylinder(r=4.2,h=depth+1);
		translate([0,0,-1])cylinder(r=3.2,h=20);
	}
}
// Clearance module created so it can be positioned same as the feed tube
module feedTubeClrnc(len=20,depth=5)
{
	translate([0,0,-depth])cylinder(r=3.2,h=len);
}
// Modified to just be a single hole
// slotted hole for a motor mount
module slot_hole(head = 0){
	difference(){
		union(){
			translate([0,0,0]) cylinder(r=1.8,40,center=false,$fn=30);
		if (head == 1) {
			translate([0,0,0]) cylinder(r=2.8,3.5,center=false,$fn=30);
		}
		}
	}
}
// triangle is just used for viewing
module triangle()
{
	polygon( points=[[0,0],[50,0],[50,50],[0,0]] );
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// Printing Stuff
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if (print_Driver == 1){
	buildDriver();
} else if(showAssy == 1) {
	if (!(explode == 1)) {
		color([0.8,0.1,0.1,1])
		translate([0,0,0]) 
		driver();
	} else {
		color([0.8,0.1,0.1,1])
		translate([0,0,0])
		driver();
	}
}

if (print_Nozzle == 1){
	nozzle(extrusionDia);
} else if(showAssy == 1) {
	if (!(explode == 1)) {
		color([0.1,0.8,0.1,1])
		translate([0,0,7.5+30]) 
		nozzle(extrusionDia);
	} else {
		color([0.1,0.8,0.1,1])
		translate([0,0,7.5+30+45])
		nozzle(extrusionDia);
	}
}

if (print_Chamber == 1){
	buildChamber();
} else if(showAssy == 1) {
	if (!(explode == 1)) {
		color([0.3,0.5,0.5,1])
		translate([0,0,7.5]) 
		chamber();
	} else {
		color([0.3,0.5,0.5,1])
		translate([0,0,7.5+35])
		chamber();
	}
}
