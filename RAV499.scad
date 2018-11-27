
module roundedRect(size, radius) {
	x = size[0];
	y = size[1];
	z = size[2];

	linear_extrude(height=z)
	hull() {
		// place 4 circles in the corners, with the given radius
		translate([(-x/2)+(radius/2), (-y/2)+(radius/2), 0])
		circle(r=radius);
	
		translate([(x/2)-(radius/2), (-y/2)+(radius/2), 0])
		circle(r=radius);
	
		translate([(-x/2)+(radius/2), (y/2)-(radius/2), 0])
		circle(r=radius);
	
		translate([(x/2)-(radius/2), (y/2)-(radius/2), 0])
		circle(r=radius);
	}
}

module rav499_bat_cov() {

    //dimensions
    L1 = 53.5;//length of main body
    L2 = 23.4;//width of main body (flat section only)
    L3 = 9;//width of main body (angled section only)
    L4 = 14.75;//center-to-center
    L5 = 3.75-1.5;//height of end clips
    L6 = 2.5;//Length of end clips
    L7 = 4.0;//width of end clips
    L8 = 15.6;//width of retension clip
    L9 = 11.1;//height of retension clip
    T1 = 1.5;//thickness of main body
    T2 = 1.1;//thickness of end clips
    T3 = 1.25; //thickness of retension clip
    D1 = 4+T3/2; //outer diamater of retension clip
    D2 = D1 - 2*T3;//inner diamater of retension clip

    union() {
        //the main body
        roundedRect([L1, L2, T1], 1, $fn=50);

        // the end clips
        translate([(L1/2)-.5,L4/2,(L5+T2)/2])
        cube([T2, L7, L5], center = true);
        translate([(L1/2)-.5,-L4/2,(L5+T2)/2])
        cube([T2, L7, L5], center = true);
        // the end clip extensions
        translate([L1/2+.2,L4/2,L5])
        cube([L6, L7, T2], center = true);
        translate([L1/2+.2,-L4/2,L5])
        cube([L6, L7, T2], center = true);
        
        //opener
        translate([-((L1/2)+(D2/2)),0,0]) {
            difference () { //difference
                //The outer cylinder (OD)
                translate([0,0,L9-(D1/2)])
                rotate([90,0,0])
                scale([1/100,1/100,1/100])
                cylinder(100*L8, 100*(D1/2), 100*(D1/2), center = true);

                //The inner cylinder (ID)
                translate([0,0,L9-(D1/2)])
                rotate([90,0,0])
                scale([1/100,1/100,1/100])
                cylinder(100*L8, 100*(D2/2), 100*(D2/2), center = true);

                translate([0,0,L9-(D1/2)-((D1/2)/2)])
                cube([D1, L8+.1, D1/2], center = true);
            } //difference

            // Vertical parts
            translate([((D1/2)-(T3/2)),0,(L9/2)-D1/4])
            cube([T3, L8, L9-(D1/2)], center = true);
            translate([-((D1/2)-(T3/2)),0,(L9/2)-D1/4])
            cube([T3, L8, L9-(D1/2)], center = true);	

            // Nail clip
            translate([-((D1/2)-(T3/2))-T3,0,T1/3])
            cube([3, L8-2, 1], center = true);	

        }//Translate
    }//union
}

rav499_bat_cov();

module cylinder_ep(p1, p2) {
	vector = [p2[0] - p1[0],p2[1] - p1[1],p2[2] - p1[2]];
	distance = sqrt(pow(vector[0], 2) +	pow(vector[1], 2) +	pow(vector[2], 2));
	echo(distance);
	translate(vector/2 + p1)
	//rotation of XoY plane by the Z axis with the angle of the [p1 p2] line projection with the X axis on the XoY plane
	rotate([0, 0, atan2(vector[1], vector[0])]) //rotation
	//rotation of ZoX plane by the y axis with the angle given by the z coordinate and the sqrt(x^2 + y^2)) point in the XoY plane
	rotate([0, atan2(sqrt(pow(vector[0], 2)+pow(vector[1], 2)),vector[2]), 0])
	cylinder(h = distance, r = 0.1, center = true);
}
