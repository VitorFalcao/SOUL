#include "api_robot2.h"
#include "config.h"


void busca_parede();
void segue_parede();

void busca_parede() {

	if (read_sonar(3) <= LIMIAR) {
		
		// Turn right and stay parallel to the wall
		set_motors_speed(0, 10);
		while (read_sonar(0) != read_sonar(15)) {
			
		}	
	}
	else if (read_sonar(4) <= LIMIAR) {

		// Turn left and stay parallel to the wall
		set_motors_speed(10, 0);
		while (read_sonar(7) != read_sonar(8)) {

		}
	}

	set_motors_speed(15, 15);
}

void segue_parede() {

	// Robot may turn to the wrong side when going straight onto the wall
	// Maybe checking if sonar 4 and 3 are equal is not enough
}
