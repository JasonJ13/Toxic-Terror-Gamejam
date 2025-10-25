shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx, sss_mode_skin;

uniform sampler2D base_albedo: hint_default_white;
uniform sampler2D base_arm;
uniform sampler2D base_normals: hint_normal;

uniform sampler2D overlay_albedo: hint_default_white;
uniform sampler2D overlay_arm;
uniform sampler2D overlay_normals: hint_normal;


uniform float ao_light_affect: hint_range(0.0, 1.0);

varying vec3 world_space_normal;
varying vec3 world_space_tangent;
varying vec3 world_space_binormal;

void vertex() {
	world_space_normal = normalize(MODEL_NORMAL_MATRIX * NORMAL);
	world_space_tangent = normalize(MODEL_NORMAL_MATRIX * TANGENT);
	world_space_binormal = normalize(MODEL_NORMAL_MATRIX * BINORMAL);
}

void fragment() {
	vec3 normal_map = texture(base_normals, UV).rgb * 2.0 - 1.0;
	mat3 tbn = mat3(world_space_tangent, world_space_binormal, world_space_normal);
	
	//float d = max(0.0, -normalize(tbn * normal_map).y);
	float d = 0.0;
	
	//ALBEDO = mix(texture(base_albedo, UV).rgb, texture(overlay_albedo, UV).rgb, d);
	ALBEDO = texture(base_albedo, UV).rgb;
	vec3 arm = mix(texture(base_arm, UV).rgb, texture(overlay_arm, UV).rgb, d);
	//AO = arm.r;
	//AO_LIGHT_AFFECT = ao_light_affect;
	//ROUGHNESS = arm.g;
	//METALLIC = arm.b;
	
	SPECULAR = 0.5;
	
	NORMAL_MAP = mix(normal_map * 0.5 + 0.5, texture(overlay_normals, UV).rgb, d);
}


