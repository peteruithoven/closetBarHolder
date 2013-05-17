//  Closet bar holder 
// version 2 - Added support for boxes.scad 
// version 1 - Original
$fn = 50;
include <MCAD/boxes.scad>  // from https://github.com/elmom/MCAD/blob/master/boxes.scad

// this is how big we want the opening to be
// the wooded pole for my closet was 33mm diamater so I made the opening 36mm

bar_radius = 23/2;
plug_depth = 10;
plug_radius = 2.5;
plug_distance = 26; // distance inbetween plugs
plugs_offset = -15; 

holder_bottom_thns = 12; //9; //
holder_top_thns = 5;
base_width = bar_radius*2+holder_bottom_thns*2;
base_depth = 3;

o = 0.01; // slight overlap
distance = 1;


base();
translate([0,0,base_depth-o]) holder();

translate([0,base_width/2+plug_radius*2+distance,0]) {
  plug();
  translate([plug_radius*4+distance,0,0]) plug();
}

// this is the piece that sticks out to holds the bar
// we will be extruding this
module wall_mold() { 
  polygon(points=[[0,0],[0,10],[holder_top_thns,10],[holder_bottom_thns,0]]);
}
module holder() {
  difference()
  {
    // this is a circle extrusion of the wall_mold()
    rotate_extrude(convexity = 10) translate([bar_radius, 0, 0]) wall_mold();
    // we only want the bottom 1/2 so lets take take away the top half
    translate([base_width/2,0,15/2-0.1]) cube([base_width,base_width,15],center=true);
  }
  // Here is the "straight" extrusions for the wall_mold()
  translate([-o,bar_radius,0]) rotate([90,0,90]) 
    linear_extrude( height=bar_radius+2) wall_mold();
  translate([bar_radius+2-o,-bar_radius,0]) rotate([90,0,-90]) 
    linear_extrude(height=bar_radius+2) wall_mold();
}
module base() {
  difference()
  {
     translate([0,0,base_depth/2]) roundedBox([base_width*1.75,base_width, base_depth], base_width/2, true);
     translate([plugs_offset,0,0]) {
      //
      rotate([180,0,0]) translate([0,0,-base_depth]) {
        translate([plug_distance/2+plug_radius,0,0]) plug(true);
        translate([-plug_distance/2-plug_radius,0,0]) plug(true);
      }
    }
  }
}
module plug(remove=false) {
  if(remove) {
    translate([0,0,-base_depth]) cylinder(base_depth*2,plug_radius*3,plug_radius);
  } else {
    cylinder(base_depth,plug_radius*2,plug_radius);
  }
  translate([0,0,base_depth-o])
    cylinder(plug_depth+o,plug_radius,plug_radius);
}