shader_type spatial;
render_mode unshaded;

uniform sampler2D screenTex : source_color, hint_screen_texture, repeat_disable, filter_nearest;
//uniform sampler2D depthTex : source_color, hint_depth_texture, repeat_disable, filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 color = texture(screenTex, SCREEN_UV).xyz;
	//ALBEDO = color;
	//float depth = texture(depthTex, SCREEN_UV).x;
	//vec3 ndc = vec3(SCREEN_UV, depth) * 2.0 - 1.0;
	//vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	//view /= view.w;
	////ALBEDO = vec3(fract(world.xyz));
	//mat4 partMat = MODEL_MATRIX;
	//vec4 pos = inverse(partMat)*vec4(VERTEX, 1.0);
	//mat4 model2clip = mat4(mat2(vec2(VIEWPORT_SIZE.x,0.0),vec2(0.0,VIEWPORT_SIZE.y))) * PROJECTION_MATRIX * VIEW_MATRIX *  partMat;
	//vec4 clip = model2clip * pos;
	////vec4 scr = clip / clip.w;
	//vec4 deriv_x = vec4(1.0/clip.w, 0.0, 0.0, -clip.x/clip.w/clip.w);
	//deriv_x = deriv_x * model2clip;
	//vec4 deriv_y = vec4(0.0, 1.0/clip.w, 0.0, -clip.y/clip.w/clip.w);
	//deriv_y = deriv_y * model2clip;
	//vec4 deriv_mag = sqrt(deriv_x*deriv_x + deriv_y*deriv_y);
	////ALBEDO = vec3(fract(deriv_mag.y/100.0));
	////ALBEDO = vec3(abs(clamp(deriv_mag.x/100.0, -1.0,1.0)));
	//float sc = 4.0;
	//vec4 level = log2(deriv_mag);
	//vec4 level_fr = fract(level);
	//vec4 level_r = floor(level);
	//vec4 shade = level_fr * cos(pos * exp2(level_r)/sc+level_r) + (1.0-level_fr)*cos(pos*exp2(level_r-1.0)/sc+(level_r-1.0));
	//ALBEDO = vec3(sign(abs(shade.x*shade.y*shade.z)-0.1)*0.5+0.5);
	//float shadef = min(length(shade.xy),min(length(shade.yz), length(shade.xz)))/sqrt(2.0);
	float shadef = color.r;
	shadef = sign(shadef-0.5)*0.5+0.5;
	ALBEDO = mix(vec3(0.47, 0.26, 0.56)*0.7, vec3(0.71, 0.0, 1.0), shadef);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
