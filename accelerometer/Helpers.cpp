#include "Helpers.h"

double Helpers::line(double max_y, double min_y, double max_x, double min_x, double x_val) {
	// Finds the value of a linear function evaluated at x_val. The linear function has
	// m = dy/dx, and b = min_y. 
	return (max_y - min_y) * (double)(x_val - min_x) / (double)(max_x - min_x) + min_y;
}