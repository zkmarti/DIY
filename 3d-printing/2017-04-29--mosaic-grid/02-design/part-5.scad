
rotate([0,0,90])
union() {
    linear_extrude(height=.8) 
    scale([10, 10, 1])
    import("part-5a.dxf");
 
    linear_extrude(height=1)
    scale([10, 10, 1])
    import("part-5b.dxf");
}
 