// ==================================================
// Wall-Mount U-Bracket with Rounded Edges and Screw Holes
// Open Front, Tabs at Open End, Holes Perpendicular
// ==================================================

inner_size     = 40;
wall_thickness = 4;
wall_height    = 20;

tab_length     = 20;
tab_thickness  = wall_thickness;
tab_height     = wall_height;

screw_diameter = 4;
screw_clearance = 0.2;

rib_height     = 3;
rib_depth      = 2;
rib_z          = wall_height/2 - rib_height/2;

outer_size = inner_size + 2 * wall_thickness;

// radius for external edges
edge_radius = 1;

// ---------------- Helper Module ----------------
module rounded_cube(size, r) {
    minkowski() {
        cube(size, center=false);
        sphere(r=r, $fn=32);
    }
}

// ---------------- Model ----------------
difference() {
    union() {

        // ---------- U-Frame Walls ----------
        rounded_cube([outer_size, wall_thickness, wall_height], edge_radius); // back
        rounded_cube([wall_thickness, outer_size, wall_height], edge_radius); // left
        translate([outer_size - wall_thickness, 0, 0])
            rounded_cube([wall_thickness, outer_size, wall_height], edge_radius); // right

        // ---------- Side Tabs at Open End ----------
        // Left tab
        translate([-tab_length, outer_size - wall_thickness, 0])
            rounded_cube([tab_length, wall_thickness, tab_height], edge_radius);

        // Right tab
        translate([outer_size, outer_size - wall_thickness, 0])
            rounded_cube([tab_length, wall_thickness, tab_height], edge_radius);

        // ---------- Mid-Height Ribs ----------
        translate([-rib_depth, -rib_depth, rib_z])
            rounded_cube([outer_size + 2*rib_depth, rib_depth, rib_height], edge_radius); // back rib
        translate([-rib_depth, -rib_depth, rib_z])
            rounded_cube([rib_depth, outer_size + rib_depth, rib_height], edge_radius); // left rib
        translate([outer_size, -rib_depth, rib_z])
            rounded_cube([rib_depth, outer_size + rib_depth, rib_height], edge_radius); // right rib
    }

    // ---------- Inner Clearance ----------
    translate([wall_thickness, wall_thickness, 0])
        cube([inner_size, inner_size, wall_height]); // keep inner sharp

    // ---------- Screw Holes ----------
    hole_depth = tab_thickness + 2;

    // Left tab hole
    translate([-tab_length/2, outer_size - wall_thickness/2, wall_height/2])
        rotate([90,0,0])
            cylinder(h = hole_depth, d = screw_diameter + screw_clearance, $fn = 80);

    // Right tab hole
    translate([outer_size + tab_length/2, outer_size - wall_thickness/2, wall_height/2])
        rotate([90,0,0])
            cylinder(h = hole_depth, d = screw_diameter + screw_clearance, $fn = 80);
}
