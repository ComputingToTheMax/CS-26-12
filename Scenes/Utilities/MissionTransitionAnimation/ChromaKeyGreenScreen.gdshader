shader_type canvas_item;

uniform vec4 key_color: source_color = vec4(0, 1, 0, 1);
uniform float similarity: hint_range(0.0, 1.0) = 0.4;
uniform float smoothness: hint_range(0.0, 1.0) = 0.08;
uniform float spill: hint_range(0.0, 1.0) = 0.1;

vec2 RGBtoUV(vec3 rgb){
	return vec2(
		rgb.r * -0.169 + rgb.g * -0.331 + rgb.b * 0.5 + 0.5,
		rgb.r * 0.5 + rgb.g * -0.419 + rgb.b * -0.081 + 0.5
	);
}

vec4 ProcessChromaKey(sampler2D tex, vec2 textureCoordinate){
	vec4 rgba = texture(tex, textureCoordinate);
	float chromaDist = distance(RGBtoUV(texture(tex, textureCoordinate).rgb), RGBtoUV(key_color.rgb));
	
	float baseMask = chromaDist - similarity;
	float fullMask = pow(clamp(baseMask / smoothness, 0., 1.), 1.5);
	rgba.a = fullMask;
	
	float spillVal = pow(clamp(baseMask / spill, 0., 1.), 1.5);
	float desat = clamp(rgba.r * 0.2126 + rgba.g * 0.7152 + rgba.b * 0.0722, 0., 1.);
	rgba.rgb = mix(vec3(desat, desat, desat), rgba.rgb, spillVal);
	
	return rgba;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = ProcessChromaKey(TEXTURE, UV);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
