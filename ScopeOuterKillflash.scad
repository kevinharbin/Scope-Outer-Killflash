//scope outer killflash version 1.1
//all units mm
//https://openscad.cloud/openscad/ for testing
scope_outer_diameter = 26;
scope_depth = 22;//total height of killflash
lip_depth = 11;//depth of hex pattern
hex_diam = 6;
thickness = 2; //thickness of slip cover
Anti_SosnaN = 1; // 1=Yes, 0=No
module hexagon(diam)
{
  cylinder(h=lip_depth, d=diam,$fn=6);
}

module draw_hexagon(x,y)
{
    for(y = [-(y/2):1:(y/2)])
    {
        translate([0,hex_diam*y,0])
                {
                    for(ang = [60])
            {
            rotate(ang)
            for(x = [-(x/2):1:(x/2)])
            {
                translate([0,hex_diam*x,0])
                {
                    hexagon(hex_diam);
                }
            }
            }
                }
    }        
}
module make_hexagon()
{
total_width=hex_diam+scope_outer_diameter;
lattice_quant = ceil(total_width/hex_diam);
if (lattice_quant % 2 == 0) draw_hexagon(lattice_quant+0,lattice_quant+0);//confirm this value is even so a hexagon is centered
else {draw_hexagon(lattice_quant+1,lattice_quant+1);}
}

union() //create the combined model
{
difference()//invert hex pattern
{
    cylinder(h=lip_depth, d=scope_outer_diameter,$fn=128);
    //rcube([scope_outer_diameter+thickness,1.5*(scope_outer_diameter+thickness),.75*scope_depth],[0,0,1],true);
    intersection()//hex pattern of lip depth
        {
            make_hexagon();
            //cube([scope_outer_diameter+thickness,2*(scope_outer_diameter+thickness),.75*scope_depth],true);
            cylinder(h=lip_depth, d=scope_outer_diameter,$fn=128);
        }
}
difference()//gradual opening
    {
    difference()//total depth including slip cover
        {
         hull()
        {
            translate([0, 0, 0.5*.25*scope_depth]) {
            if(Anti_SosnaN==1){rcube([scope_outer_diameter+thickness,1.5*(scope_outer_diameter+thickness),.25*scope_depth],[1,1,2],true);}
            }
            cylinder(h=scope_depth, d=scope_outer_diameter+thickness,$fn=128);
        }
            cylinder(h=scope_depth, d=scope_outer_diameter,$fn=128);
        } 
    translate([0,0,scope_depth-2]){
        cylinder(h=2, d1=scope_outer_diameter-1.2,d2=scope_outer_diameter+0.8,$fn=128);}
    }   
}

module rcube(size=[30, 20, 10], radius=[3, 2, 1], center=true)
    hull() {
        translate( center ? [0,0,0] : size/2 ) {
            cube(size-2*radius+[2*radius[0],0,0],center=true);
            cube(size-2*radius+[0,2*radius[1],0],center=true);
            cube(size-2*radius+[0,0,2*radius[2]],center=true);
 
            for(x = [-0.5,0.5], y = [-0.5,0.5], z = [-0.5,0.5])
                translate([x * ( size[0] - 2*radius[0]),
                           y * ( size[1] - 2*radius[1]),
                           z * ( size[2] - 2*radius[2])])
                    scale([radius[0], radius[1], radius[2]])
                        sphere(1.0,$fn=4*4);
        }
    }
