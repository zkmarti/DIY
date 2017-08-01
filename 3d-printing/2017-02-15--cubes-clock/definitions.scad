//
// GENERAL
//
PLAY = 0.4;
TOLERANCE = 0.17;
ATOM = 0.01;

//
// SPECIFIC
//

// Screws
SCREW_SHAFT_DIAMETER = 2;
SCREW_THREAD_DIAMETER = 2.5;
SCREW_HOLE_LENGTH = 5;

SCREW_PLATE_THICKNESS = 1;

// Plate
PLATE_DIAMETER = 46;
PLATE_SCREWS_BORDER_DISTANCE = 4;
PLATE_THICKNESS = 20.5;

// PLATE 2
PINION_NECK_RADIUS = 6.5;
PINION_SCREW_HEAD_RADIUS = 3 + PLAY;

PINION_THICKNESS = 5.3;
PINION_HEIGHT = PINION_THICKNESS;

PLATE2_H4 = 7;
PLATE2_H3 = 5.5;
PLATE2_H2 = 5;
PLATE2_H1 = 3;

PLATE2_R5 = PLATE_DIAMETER/2;
PLATE2_R4 = PLATE2_R5 - 1;
PLATE2_R3 = PLATE2_R4 - 1;
PLATE2_R2 = PLATE2_R3 - 1.5;
//PLATE2_R1 = PLATE2_R2 - 1.5;
PLATE2_R1 = PLATE2_R5 - 7;
PLATE2_R0 = PLATE2_R5 - 8;

PLATE2_R32 = (PLATE2_R2-0.5);

PLATE2_BAR_SPACE = 0.4;
PLATE2_RING_THICKNESS = 0.7 * 2;

PLATE2_RATCHET_RADIUS = 1;

PLATE2_SPRING_THICKNESS = 0.7;
PLATE2_SPRING_HEIGHT = 1;

PLATE2_BAR_WIDTH = 5;
PLATE2_BAR_ANGLE = 20;

PLATE2_NECK_HEIGHT = PLATE2_H4 - PINION_HEIGHT + 0.5;
PLATE2_CROWN_HEIGHT = PLATE2_H4 - PLATE2_H3;

echo("Total height: ", PLATE_THICKNESS+PLATE2_H4+PLAY+TOLERANCE);

// Snapping
SNAP_HOLE_DIAMETER = 4;

//
// HELPERS
//

module spoke(radius, width, height) {
    translate([0, 0, height/2])
    intersection() {
        cube([radius*3, width, height], true);

        translate([0, 0, -height/2])
        scale([1, 1, height])
        cylinder(r=radius, true);
    }
}

module barrel(outer_radius, inner_radius, height) {
    scale([1, 1, height])
    difference() {
        cylinder(r=outer_radius);
        translate([0, 0, -0.5]) scale([1, 1, 2])
        cylinder(r=inner_radius);
    }
}

module alignment_columns(column_extra=0, height=1) {
    r = PLATE_DIAMETER/2 - PLATE_SCREWS_BORDER_DISTANCE;
    n = 4;
    offset_angle = 45;
    scale([1, 1, height])
    for(a=[0:n-1])
        rotate([0, 0, a*360/n + offset_angle])
        translate([0, r, 0])
        cylinder(r=SNAP_HOLE_DIAMETER/2 + column_extra, true);        
}