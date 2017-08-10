SERVO_THICKNESS = 11.5;
SERVO_AXIS_RADIUS = 3;

module servo_hull(with_clearances=false) {
    rotate([0, 0, -90])
    translate([0, 0, -SERVO_THICKNESS/2])
    linear_extrude(height=SERVO_THICKNESS)
    //offset(delta=TOLERANCE/2) // <== Loosen a bit the cavity
    scale([10, 10, 1]) {
        import("servo.dxf");
        if (with_clearances)
            import("servo-clearances.dxf");
    }
}

module servo_cable_clearance(height) {
    rotate([0, 0, -90])
    translate([0, 0, -height/2])
    linear_extrude(height=height)
    scale([10, 10, 1]) {
        import("servo-cable-clearance.dxf");
    }
}

module servo_cut(thickness, shave_by=SERVO_AXIS_RADIUS) {
    rotate([0, 0, -90])
    translate([0, 0, -thickness/2])
    linear_extrude(height=thickness)
    offset(r=-shave_by)
    scale([10, 10, 1])
    import("servo.dxf");  
}

module servo_grips() {
    radius = 0.8;
    rotate([0, 0, -90])
    minkowski() {
        scale([10, 10, 1])
        linear_extrude(height=0.0001)
        import("servo-grips.dxf");
        sphere(r=radius, $fn=15);
    }
}

module servo_cover(thickness, shave_by=0 /*TOLERANCE*/) {
    rotate([0, 0, -90])
    difference() {
        linear_extrude(height=thickness)
        offset(delta=-shave_by)
        scale([10, 10, 1])
        import("servo-cover.dxf");
    }   
}

module servo_cover_clip(thickness, grow_by=0 /*TOLERANCE*/) {
    rotate([0, 0, -90])
    difference() {
        linear_extrude(height=thickness)
        offset(delta=grow_by)
        scale([10, 10, 1])
        import("servo-cover-clip.dxf");
    }   
}


module servo_cover_screw_hole_part(diameter, thickness) {
    rotate([0, 0, -90])
    difference() {
        delta = (diameter - 1) /2;
        linear_extrude(height=thickness)
        offset(delta=delta)
        scale([10, 10, 1])
        import("servo-cover-screws.dxf");
    }   
}

module servo_cover_screw_holes(bottom_aligned=true) {
    // thread
    servo_cover_screw_hole_part(SCREW2_DIAMETER-TOLERANCE*2, PLATE_THICKNESS);

    // hole
    z = WHEEL_EXTERNAL_DIAMETER/2 - PINION_THICKNESS + SERVO_THICKNESS/2;
    translate([0, 0, bottom_aligned ? z : 0])
    servo_cover_screw_hole_part(SCREW2_DIAMETER+TOLERANCE*3, SERVO_THICKNESS);

    // head
    translate([0, 0, bottom_aligned
                     ? PLATE_THICKNESS -SCREW2_HEAD_THICKNESS -TOLERANCE
                     : servo_cover_height() -SCREW2_HEAD_THICKNESS -TOLERANCE])
    servo_cover_screw_hole_part(SCREW2_HEAD_DIAMETER+TOLERANCE*2, PLATE_THICKNESS);
}

//%servo_hull();
//servo_grips();
//servo_cut(20, 8);