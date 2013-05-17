use <obiscad/bcube.scad>

X = 0;
Y = 1;
Z = 2;

//----------------- USER parameters ------------------
base_side = 52;
base_th = 3;
base_cr = 3;
base_cres = 4;

ear_lx = 23.8;
ear_lz = 7.4;

ear_size = [2.5, 18, 7.4];
ear_pos_h = 1.5;

foot_th = 6;
foot_size = [foot_th + ear_size[X], 23, ear_lz];

foot_drill_diam = 3.2;
foot_drill_h = 1.6;

//-- Distance between the center of the two
//-- foot drills
foot_drill_dx = 6.6 + foot_drill_diam;

//---------------------- DATA calculation
base_size = [base_side, base_side, base_th];

//-- Distance in x between the two feet
feet_dx = ear_lx - 2 * foot_th;

//-- Feet location coordinates
foot_pos = [foot_size[X]/2 + feet_dx/2,
            0,
            foot_size[Z]/2 + base_size[Z]/2];

            //foot_pos[X] - foot_size[X]
//-- Steps----
step1_size = [2.5, foot_size[Y], 1.5];
step1_pos = [-step1_size[X]/2 - foot_pos[X] - foot_size[X]/2,
            0,
            step1_size[Z]/2 + base_size[Z]/2];
            
//-- captive Nuts
nut_h = 3;
nut_radius = 6.6/2;            
            
extra = 5;


//--- SKYMEGA Drills
sky_dd = 15;  //-- Distance

sky_drill_table = [
  [sky_dd, sky_dd, 0],
  [-sky_dd, sky_dd, 0],
  [-sky_dd, -sky_dd, 0],
  [sky_dd, -sky_dd, 0],
];

sky_drill_diam = 3.2;


//--- Center cutouts
co1_size = [feet_dx - 2, foot_size[Y], base_size[Z]+extra];


module foot()
{

  nut_co = nut_h + extra;
  
  ear_co_size = [ear_size[X]+extra, ear_size[Y], ear_size[Z]+extra];
  foot_drill_pos = [0, 
               foot_drill_dx/2, 
               -foot_size[Z]/2 + foot_drill_diam/2 + foot_drill_h];

  difference() {
    //-- Main foot body
    cube(foot_size, center = true);
    
    //-- space for the servo ear
    translate([-ear_co_size[X]/2 - foot_size[X]/2 + ear_size[X],
               0,
               0])
    cube(ear_co_size, center = true);
    
    //-- Foot drills
    translate(foot_drill_pos)
    rotate([0, 90, 0])
    cylinder(r = foot_drill_diam/2, h = foot_size[X] + extra, center = true);

    translate([foot_drill_pos[X], -foot_drill_pos[Y], foot_drill_pos[Z]])
    rotate([0, 90, 0])
    cylinder(r = foot_drill_diam/2, h = foot_size[X] + extra, center = true);
    
    //-- Embebed nuts
    translate([nut_co/2 + foot_size[X]/2 - nut_h,
               foot_drill_dx/2,
                foot_drill_pos[Z]])
     rotate([0,90,0])
     rotate([0,0,90])
     cylinder(r = nut_radius, h = nut_co, center = true, $fn=6);
 
     translate([nut_co/2 + foot_size[X]/2 - nut_h,
               -foot_drill_dx/2,
                foot_drill_pos[Z]])
     rotate([0,90,0])
     rotate([0,0,90])
     cylinder(r = nut_radius, h = nut_co, center = true, $fn=6);
    
  }  
}
 
//foot(); 




 
//--------- PART building -----------------

difference() {
  //-- The base
  bcube(base_size, cr = base_cr, cres = base_cres);
  
  //-- Skymega drills
  for (drill = sky_drill_table) {
    translate(drill)
      cylinder(r=sky_drill_diam/2, h=base_size[Z]+extra,center=true, $fn=6);
  }
  
  //-- Central cutout
  bcube(co1_size, cr = base_cr, cres = base_cres);

}  
  
//-- The feet

//-- Right foot
translate(foot_pos)
rotate([0,0,180])
foot();

//-- Left foot
translate([-foot_pos[X], foot_pos[Y], foot_pos[Z]])
foot();

//-- Left step
*translate(step1_pos)
cube(step1_size, center = true);



//--- Things TODO
//-- * Feet reinforcements
//-- * (optional) more cutouts
