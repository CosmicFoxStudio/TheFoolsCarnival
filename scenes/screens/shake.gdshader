shader_type canvas_item;

uniform vec2 dirToShake = vec2(1,1);
uniform float amplitude = 1;

uniform float frequency = 1;

void vertex()
{
	VERTEX += dirToShake * vec2(sin(TIME * frequency) * amplitude, cos(TIME * frequency) * amplitude);	
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
