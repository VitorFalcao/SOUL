#include "api_robot2.h"

void set();
void set_2();
void set_3();
void set_4();

void _start() {

	int i = 0;
/*
	register_proximity_callback(3, 1200, &set);
	
	register_proximity_callback(3, 2500, &set_2);
*/
	set_motors_speed(50, 50);
/*
	add_alarm(set, 5);
	add_alarm(set_2, 15);
	add_alarm(set, 25);
	add_alarm(set_2,35);
	add_alarm(set, 45);
	add_alarm(set_2, 55); */
	add_alarm(set_4,5);

	while (1) {
		
			
	}
}

void set() {

	set_motors_speed(30, 0);
}

void set_2() {

	set_motors_speed(10, 10);
}

void set_3() {
	set_motors_speed(0,0);
}
void set_4() {
	add_alarm(set_3, 10);
}

