#include "api_robot2.h"

void set();
void set_2();

void _start() {

	int i = 0;

	register_proximity_callback(3, 1200, &set);
	
	register_proximity_callback(3, 2500, &set_2);

	set_motors_speed(50, 50);

	while (1) {
		
			
	}
}

void set() {

	set_motors_speed(30, 0);
}

void set_2() {

	set_motors_speed(10, 10);
}
