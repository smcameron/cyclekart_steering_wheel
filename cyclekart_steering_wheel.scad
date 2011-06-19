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

module round_corner(x, y, angle1, angle2, radius)
{
	rotate(a = angle2, v = [0, 0, 1]) {
		translate(v = [x, y, 0]) {
			rotate(a = angle1, v = [0, 0, 1]) {
				round_corner_primitive(radius);
			}
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

module arm_primitive(x, y)
{
	translate(v = [x, y, 0]) {
		polygon(points = [ [x - 2 * in, y - 0.65 * in],
				   [x + 2.8 * in, y - 0.3 * in],
				   [x + 2.8 * in, y + 0.3 * in],
				   [x - 2 * in, y + 0.65 * in] ],
			paths = [[0, 1, 2, 3]]);
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
	arm(1 * in, 0, 0);
	arm(1 * in, 0, 90);
	arm(1 * in, 0, 180);

	if (want_round_corners > 0) {
		/* left upper... */
		round_corner(-4.94 * in, 0.38 * in, 0, 0, 0.75 * in);
		/* left lower */
		round_corner(-4.96 * in, -0.38 * in, -90, 0, 0.75 * in);
		/* right upper */
		round_corner(4.94 * in, 0.38 * in, 90, 0, 0.75 * in);
		/* right lower */
		round_corner(4.96 * in, -0.38 * in, 180, 0, 0.75 * in);

		/* top left */
		round_corner(4.94 * in, 0.38 * in, 90, 90, 0.75 * in);
		/* top right */
		round_corner(4.94 * in, -0.38 * in, 180, 90, 0.75 * in);
	}
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
		bolt_hole(0.75 * in,    0, 0.26 * in);
		bolt_hole(0.75 * in,  120, 0.26 * in);
		bolt_hole(0.75 * in, -120, 0.26 * in);

		/* perimeter screw holes */
		bolt_hole(5.5 * in, 0, 3/16 * in);
		bolt_hole(5.5 * in, 22.5, 3/16 * in);
		bolt_hole(5.5 * in, -22.5, 3/16 * in);
		bolt_hole(5.5 * in, 45, 3/16 * in);
		bolt_hole(5.5 * in, -45, 3/16 * in);
		bolt_hole(5.5 * in, -45 - 22.5, 3/16 * in);
		bolt_hole(5.5 * in, 45 + 22.5, 3/16 * in);
		bolt_hole(5.5 * in, 90, 3/16 * in);
		bolt_hole(5.5 * in, -90, 3/16 * in);
	}
}

steering_wheel();


