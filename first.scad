// Parameters
random_fill_percent = 0.8;
pixel_size = 0.4;
card_depth = 0.8;
card_width = 84;
card_height = 54;
frame_thickness = 4;
canvas_width = card_width-frame_thickness;
canvas_height = card_height-frame_thickness;

module my_cube(cube_x, cube_y, cube_z) {
    cube([cube_x, cube_y, cube_z]);
}

module center_cube(cube_x, cube_y, cube_z) {
    cube([cube_x, cube_y, cube_z], center = true);
}

module difference_center_cube(cube_x, cube_y, cube_z, hole_x, hole_y, hole_z) {
    difference() {
        center_cube(cube_x, cube_y, cube_z);
        center_cube(hole_x, hole_y, hole_z);
    }
}

module card_frame() {
    //business card frame
    difference_center_cube(card_width, card_height, card_depth, canvas_width, canvas_height, card_depth+1);
}

module card_pixel(x, y, z) {
    //business card pixel
        translate([x, y, z]) {
            my_cube(1, 1, 0.8);
        }
    }

// Function to generate the card pixels
module card_pixels() {
    pixel_draw_area_width = canvas_width-pixel_size;
    pixel_draw_area_height = canvas_height-pixel_size;
    card_depth = 0.8;

    for (x = [-pixel_draw_area_width/2:pixel_size:pixel_draw_area_width/2]) {
        for (y = [-pixel_draw_area_height/2:pixel_size:pixel_draw_area_height/2]) {
            if (rands(0, 1, 1)[0] < random_fill_percent) {
                draw_card_pixel(x-(pixel_size/2), y-(pixel_size/2), -card_depth/2);
            }
        }
    }
}

// Function to draw a single pixel
module draw_card_pixel(x, y, z) {
    translate([x, y, z])
        cube([pixel_size, pixel_size, 0.8]);
}
// Function to add text
module add_text(txt, size, thickness) {
    translate([0, 0, -thickness/2]) {
        linear_extrude(height = thickness)
            text(txt, size = size, halign = "center", valign = "center");
    }
}

module difference_text(txt, size, thickness) {
    translate([0, 0, -thickness/2]) {     
    difference() {
        linear_extrude(height = thickness)
        text(txt, size = size, halign = "center", valign = "center");
    };
}
}

module add_text_tophalf(txt, size, thickness) {
    translate([0, canvas_height/4, -thickness/2]) {
        linear_extrude(height = thickness/2)
            text(txt, size = size, halign = "center", valign = "center");
    }
}

module add_text_bottomhalf(txt, size, thickness) {
    translate([0, -canvas_height/4, -thickness/2]) {
        linear_extrude(height = thickness/2)
            text(txt, size = size, halign = "center", valign = "center");
    }
}
// Main card module with difference text
module main_card() {
    difference() {
        // Card frame and pixels
        union() {
            add_text_tophalf("A2024", 20, card_depth);
            add_text_bottomhalf("0723", 20, card_depth);
            card_frame();
            card_pixels();
        }
        // Subtract text
        difference_text("GK", 10, card_depth+1);
    }
}

// Render the main card with difference text
main_card();


