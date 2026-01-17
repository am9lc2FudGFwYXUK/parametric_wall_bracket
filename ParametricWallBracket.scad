// ==================================================
// Wall-Mount U-Bracket with Rounded Edges and Screw Holes
// Open Front, Tabs at Open End, Holes Perpendicular
// ==================================================

inner_width    = 40;  // X dimension
inner_height   = 40;  // Y dimension (depth of U)
wall_thickness = 4;
wall_height    = 20;  // Z dimension

tab_length     = 20;
tab_thickness  = wall_thickness;
tab_height     = wall_height;

screw_diameter = 4;
screw_clearance = 0.2;

rib_height     = 3;
rib_depth      = 2;
rib_z          = wall_height/2 - rib_height/2;

outer_width  = inner_width + 2 * wall_thickness;
outer_height = inner_height + wall_thickness;  // only one back wall

edge_radius = 1;

module rounded_cube(size, r) {
    minkowski() {
        cube(size, center=false);
        sphere(r=r, $fn=32);
    }
}

difference() {
    union() {
        // Back wall
        rounded_cube([outer_width, wall_thickness, wall_height], edge_radius);
        
        // Left wall
        rounded_cube([wall_thickness, outer_height, wall_height], edge_radius);
        
        // Right wall
        translate([outer_width - wall_thickness, 0, 0])
            rounded_cube([wall_thickness, outer_height, wall_height], edge_radius);

        // Left tab
        translate([-tab_length, outer_height - wall_thickness, 0])
            rounded_cube([tab_length, wall_thickness, tab_height], edge_radius);

        // Right tab
        translate([outer_width, outer_height - wall_thickness, 0])
            rounded_cube([tab_length, wall_thickness, tab_height], edge_radius);

        // Back rib
        translate([-rib_depth, -rib_depth, rib_z])
            rounded_cube([outer_width + 2*rib_depth, rib_depth, rib_height], edge_radius);
        
        // Left rib
        translate([-rib_depth, -rib_depth, rib_z])
            rounded_cube([rib_depth, outer_height + rib_depth, rib_height], edge_radius);
        
        // Right rib
        translate([outer_width, -rib_depth, rib_z])
            rounded_cube([rib_depth, outer_height + rib_depth, rib_height], edge_radius);
    }

    // Inner clearance
    translate([wall_thickness, wall_thickness, -edge_radius])
        cube([inner_width, inner_height + edge_radius*2, wall_height + edge_radius*2]);

    // Cut off front protrusion - flush with inner opening
    translate([-tab_length - edge_radius*2, outer_height, -edge_radius])
        cube([outer_width + tab_length*2 + edge_radius*4, edge_radius*2, wall_height + edge_radius*2]);

    // Cut off left tab inner protrusion (where it meets U opening)
    translate([wall_thickness, outer_height - wall_thickness - edge_radius, -edge_radius])
        cube([edge_radius*2, wall_thickness + edge_radius*2, wall_height + edge_radius*2]);

    // Cut off right tab inner protrusion (where it meets U opening)
    translate([outer_width - wall_thickness - edge_radius*2, outer_height - wall_thickness - edge_radius, -edge_radius])
        cube([edge_radius*2, wall_thickness + edge_radius*2, wall_height + edge_radius*2]);

    // Left tab hole
    translate([-tab_length/2, outer_height - wall_thickness - 1, wall_height/2])
        rotate([-90, 0, 0])
            cylinder(h = wall_thickness + 2, d = screw_diameter + screw_clearance, $fn = 80);

    // Right tab hole
    translate([outer_width + tab_length/2, outer_height - wall_thickness - 1, wall_height/2])
        rotate([-90, 0, 0])
            cylinder(h = wall_thickness + 2, d = screw_diameter + screw_clearance, $fn = 80);
}
