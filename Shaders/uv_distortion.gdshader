shader_type canvas_item;

uniform vec2 offset;

uniform vec3 colorA;
uniform vec3 colorB;
uniform vec3 colorC;
uniform vec3 colorD;

uniform float colorSpeed = 3.0;

vec3 color_palette(float t, vec3 a, vec3 b, vec3 c, vec3 d){
	return a + b*cos(TAU * (c*t+d));	
}

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX += vec2(sin(offset.x * TIME), cos(offset.y * TIME) * 10.0);
}

void fragment() {
	COLOR = texture(TEXTURE,UV);
	COLOR.rgb *= color_palette((TIME * colorSpeed) ,colorA,colorB,colorC,colorD);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
