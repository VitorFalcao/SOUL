#include "api_robot2.h"

void set();
void set_2();

void _start() {

	add_alarm(&set_2, 5);

	register_proximity_callback(3, 1200, &set);

	while (1) {
		
			
	}
}

void set() {

	set_motors_speed(30, 0);
}

void set_2() {

	set_motors_speed(10, 10);
}
