shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : repeat_disable;
uniform sampler2D noise_texture;

uniform float speed : hint_range(0.02,0.1) = .01;
uniform float strength : hint_range(0.001,0.03) = .02;

uniform vec2 direction;

void twirl(vec2 uv, vec2 center, float Strength, vec2 Offset, out vec2 Out){
	vec2 delta = uv - center;
	float angle = Strength * length(delta);
    float x = cos(angle) * delta.x - sin(angle) * delta.y;
    float y = sin(angle) * delta.x + cos(angle) * delta.y;

	Out = vec2(
	x + center.x + Offset.x,
	y + center.y + Offset.y);
}

void vertex() {
	// Called for every vertex the material is visible on.
	vec2 result;
	//twirl(UV,POSITION.xy,strength, vec2(1,1), result);

}

void fragment() {
	// Called for every pixel the material is visible on.
	float noise = texture(noise_texture, UV + TIME * speed).r * strength;
	vec2 distortion = vec2(noise) * direction;
	COLOR = texture(screen_texture, SCREEN_UV + distortion - direction * strength / 2.0);

}
