// ============================================================================
// NOTES:
//
// Printing resolution: Normal (not draft, not fine)
// Fill: 15%
//
// ============================================================================

include <definitions.scad>
use <02-primary-plate.scad>
use <04-holder.scad>
use <05-cubes.scad>

BASE_CROWN_MEDIAN_RADIUS = PLATE2_BOX_INNER_HOLE_DIAMETER/2;
BASE_CROWN_OUTER_RADIUS = BASE_CROWN_MEDIAN_RADIUS + WALL_THICKNESS;

BASE_ONE_CAVITY_DIAMETER = 25;
BASE_CROWN_HEIGHT = 9;
BASE_SCREW_POS_RADIUS = BASE_CROWN_MEDIAN_RADIUS - SCREW2_HEAD_DIAMETER/2 - PLAY - WALL_THICKNESS;

module base_plate_cavity(angle, radius, disc) {
    height = BASE_CROWN_HEIGHT + 2*ATOM;
    difference() {
        // cable or holder cavity
        rotate([0, 0, 180 - angle/2])
        translate([0, 0, -ATOM])
        intersection() {
            cylinder(r=radius, h=height);
            cube([PLATE_DIAMETER, PLATE_DIAMETER, height]);
            rotate([0, 0, angle-90])
            cube([PLATE_DIAMETER, PLATE_DIAMETER, height]);
        }
        
        if (!disc)
            translate([0, 0, -ATOM*2])
            cylinder(r=PLATE_DIAMETER/2, h=height+ATOM*4);
    }
    if (disc)
        translate([0, 0, -ATOM])
        cylinder(r=PLATE_DIAMETER/2 - TOLERANCE, h=height);
}

module base_plate_holder_cavity() {
    base_plate_cavity(HOLDER_ANGLE, PLATE_DIAMETER/2+HOLDER_THICKNESS+PLAY, true);
}

module base_plate_cables_cavity() {
    radius = PLATE_DIAMETER/2+HOLDER_THICKNESS-PLAY;
    height = 3;
    width = 5;
    angle = 45;
    radius2 = PLATE_DIAMETER/2+HOLDER_THICKNESS/2;

    base_plate_cavity(angle*2, radius, false);


    union() {
        // cable canal
        rotate([0, 0, angle])
        translate([-radius2/2 -width/2, width/2, 0])
        cube([radius2-width, width, height*2 +ATOM*2], true);
     
        // cable canal
        rotate([0, 0, -angle])
        translate([-radius2/4, -width/2, 0])
        cube([radius2*1.5, width, height*2 +ATOM*2], true);
    }
}

module base_plate_main_plate(variant_one) {
    if (variant_one)
        difference() {
            cylinder(r=PLATE_DIAMETER/2, h=PLATE_THICKNESS);
            translate([0, 0, -ATOM])            
            cylinder(r=BASE_ONE_CAVITY_DIAMETER/2, h=PLATE_THICKNESS+ATOM*2);
        }
    else
        difference() {
            flip(PLATE_HEIGHT_SHORT)
            primary_plate(is_short=true);
            translate([0, 0, -PLATE_THICKNESS])
            cylinder(r=PLATE_DIAMETER, h=PLATE_THICKNESS);
        }
}

module base_plate_lower_plate() {
    r = get_cube_snap_ball_pos_radius() + CUBE_SNAP_BALLS_RADIUS*CUBE_SNAP_BALLS_K*2 + WALL_THICKNESS;
    r = BASE_CROWN_OUTER_RADIUS;

    difference() {
        cylinder(r=r, h=BASE_CROWN_HEIGHT);
        
        *translate([0, 0, -ATOM])
        cylinder(r=PLATE_DIAMETER/2-PLAY, h=BASE_CROWN_HEIGHT+2*ATOM);

        // snap marks
        *translate([0, 0, BASE_CROWN_HEIGHT])
        rotate([0, 0, 45]) flip(0)
        make_block_snap_marks();
        
        // grove
        translate([0, 0, CUBE_CROWN_HEIGHT - CUBE_CROWN_SHORT_HEIGHT - TOLERANCE])
        barrel(BASE_CROWN_MEDIAN_RADIUS + WALL_THICKNESS + PLAY,
               BASE_CROWN_MEDIAN_RADIUS - PLAY/2, PLATE_THICKNESS);
    }
}

module base_plate_screws_holes() {
    for (i=[0:2]) {
        rotate([0, 0, 120*i])
        translate([BASE_SCREW_POS_RADIUS, 0, WALL_THICKNESS*2])
        screw(head_extent=PLATE_THICKNESS, is_clearance_hole=true);            
    }
}

module base_plate_screws() {
    for (i=[0:2]) {
        rotate([0, 0, 120*i])
        translate([BASE_SCREW_POS_RADIUS, 0, WALL_THICKNESS*2])
        screw();            
    }
}

module base_plate_parts(variant_one) {
    union() {
        // plate
        base_plate_main_plate(variant_one);
        
        // support plates
        rotate([0, 0, 45]) {
            difference() {
                base_plate_lower_plate();
                base_plate_holder_cavity();
            }
        }
    }
}

module base_plate(variant_one=false) {
    difference() {
        base_plate_parts(variant_one);

        rotate([0, 0, 45]) {
            base_plate_screws_holes();
            if (!variant_one)
               base_plate_cables_cavity();
        }
    }

    rotate([0, 0, 45])
    %base_plate_screws();
}

base_plate(false);
