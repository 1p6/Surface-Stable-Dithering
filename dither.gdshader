shader_type spatial;
//render_mode unshaded;

void vertex() {
	// Called for every vertex the material is visible on.
}

mat4 roundmat4(mat4 m) {
	return mat4(round(m[0]), round(m[1]), round(m[2]), round(m[3]));
}

vec3 rand(vec3 x) {
	return sin((mat3(
		vec3(867.356,345.642,143.754),
		vec3(883.298,398.283,898.525),
		vec3(987.222,145.246,484.245)) * x +
		vec3(115.598,983.245,873.244))*10.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	mat4 partMat = VIEW_MATRIX * MODEL_MATRIX;
	mat4 invPartMat = inverse(partMat);
	vec4 pos = invPartMat*vec4(VERTEX, 1.0);
	mat4 world2clip = mat4(mat2(vec2(VIEWPORT_SIZE.x,0.0),vec2(0.0,VIEWPORT_SIZE.y))) * PROJECTION_MATRIX * partMat;
	vec4 clip = world2clip * pos;
	vec4 scr = clip / clip.w;
	//vec4 deriv_x = vec4(1.0/clip.w, 0.0, 0.0, -clip.x/clip.w/clip.w);
	//deriv_x = deriv_x * world2clip;
	//vec4 deriv_y = vec4(0.0, 1.0/clip.w, 0.0, -clip.y/clip.w/clip.w);
	//deriv_y = deriv_y * world2clip;
	//vec4 deriv_mag = sqrt(deriv_x*deriv_x + deriv_y*deriv_y);
	float cosAngle = dot(VIEW, NORMAL);
	
	//ALBEDO = vec3(fract(deriv_mag.y/100.0));
	//ALBEDO = vec3(abs(clamp(deriv_mag.x/100.0, -1.0,1.0)));
	float sc = 0.05;
	float dotSize = 7.0;
	float randAmt = 0.2;
	float dist = length(pos - invPartMat * vec4(VERTEX.xy, 0.0, 1.0));
	float level = -log2(dist / pow(cosAngle,0.3) /sc / min(VIEWPORT_SIZE.x, VIEWPORT_SIZE.y));
	float level_fr = fract(level);
	float level_r = floor(level);
	vec3 closest = round(pos.xyz * exp2(level_r));
	closest += rand(closest)*randAmt;
	closest *= exp2(-level_r);
	vec4 closestScr = world2clip * vec4(closest, 1.0);
	closestScr /= closestScr.w;
	float shadef = clamp(1.0-length(closestScr.xy-scr.xy)/dotSize, 0.0, 1.0);
	vec3 closest2 = round(pos.xyz * exp2(level_r+1.0));
	closest2 += rand(closest2)*randAmt;
	closest2 *= exp2(-1.0-level_r);
	vec4 closestScr2 = world2clip * vec4(closest2, 1.0);
	closestScr2 /= closestScr2.w;
	float shadef2 = clamp(1.0-length(closestScr2.xy-scr.xy)/dotSize, 0.0, 1.0);
	float powerCorrection = 0.5;
	shadef = pow(1.0-level_fr, powerCorrection)*shadef + pow(level_fr, powerCorrection)*shadef2;
	//vec4 shade = level_fr * fract(pos * exp2(level_r)/sc+level_r) + (1.0-level_fr)*fract(pos*exp2(level_r-1.0)/sc+(level_r-1.0)) - 0.5;
	//ALBEDO = vec3(sign(abs(shade.x*shade.y*shade.z)-0.1)*0.5+0.5);
	//float shadef = 2.0*min(length(shade.xy),min(length(shade.yz), length(shade.xz)))/sqrt(2.0);
	//shadef = sign(shadef-0.5)*0.5+0.5;
	//ALBEDO = mix(vec3(0.47, 0.26, 0.56)*0.7, vec3(0.71, 0.0, 1.0), shadef);
	ALBEDO = vec3(shadef);
	//ALBEDO = vec3(cosAngle);
	//float sc = 1.0;
	//pos = roundmat4(world2clip*sc)/sc * pos;
	//pos = pos / round(pos.w+1.0);
	//ALBEDO = vec3(1.0-length(fract(pos.xy/40.0)*2.0-1.0)/sqrt(2));
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
