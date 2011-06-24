/* cyclekart steering wheel design */

want_round_corners = 1;

in = 25.4; /* mm per inch */
$fn = 100;

module cut_off_handle_ends(leftorright)
{
	translate(v = [leftorright * 5 * in, -1.7 * in, 0])
		square( size = [2 * in, 2 * in], center = true);
}

module round_handle_ends(leftorright)
{
	translate(v = [leftorright * 5.455 * in, -0.70 * in, 0])
		circle(r = 0.5 * in);
}

module round_corner_primitive(diameter)
{
	difference() {
		square(size = [diameter, diameter],
			center = true);
		translate(v = [diameter / 2.0, diameter / 2.0, 0]) {
			circle(r = diameter / 2.0);
		}
	}
}

module main_wheel(d)
{
	difference() {
		circle(r = d / 2);
		circle(r = (d - 2 * in) / 2);
		translate(v = [0, -4.7 * in, 0 ]) {
			square(size = [d, d / 2], center = true);
		}
		cut_off_handle_ends(1);
		cut_off_handle_ends(-1);
	}
	round_handle_ends(1);
	round_handle_ends(-1);
}

module round_arm_corner(angle, yoffset)
{
	translate(v = [2.94 * in, yoffset, 0])
		rotate(a = angle, v = [0, 0, 1]) 
			round_corner_primitive(0.75 * in);
}

module round_arm_corners()
{
	if (want_round_corners > 0) {
		round_arm_corner(90, 0.35 * in);
		round_arm_corner(180, -0.35 * in);
	}
}

module arm_primitive(x, y)
{
	translate(v = [x, y, 0]) {
		union() {
			polygon(points = [ [x - 2 * in, y - 0.65 * in],
					   [x + 2.8 * in, y - 0.3 * in],
					   [x + 2.8 * in, y + 0.3 * in],
					   [x - 2 * in, y + 0.65 * in] ],
				paths = [[0, 1, 2, 3]]);
			round_arm_corners();
		}
	}
}

module arm(x, y, d)
{
	rotate(a = d, v = [0, 0, 1]) {
		translate(v = [x, y, 0]) {
			arm_primitive(x, y);
		}
	}
}

module central_hub()
{
	circle(r = 1.4 * in);
}

module steering_wheel_without_holes()
{
	main_wheel(12 * in);
	central_hub();

	for (i = [0, 90, 180])
		arm(1 * in, 0, i);
}

module bolt_hole(offset, angle, diameter)
{
	rotate(a = angle, v = [0, 0, 1]) {
		translate(v = [0, offset, 0]) {
			circle(r = diameter / 2.0);
		}
	}
}

module steering_wheel()
{
	difference() {
		steering_wheel_without_holes();
	
		/* main steering shaft hole */
		bolt_hole(0, 0, 0.5 * in);

		/* steering wheel attachment holes */
		for (i = [-120, 0, 120])
			bolt_hole(0.75 * in, i, 0.26 * in);

		/* perimeter screw holes */
		for (i = [-4, -3, -2, -1, 0, 1, 2, 3, 4])
			bolt_hole(5.5 * in, i * 180/8, 3/16 * in);
	}
}

steering_wheel();

