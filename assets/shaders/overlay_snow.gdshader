shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 main_albedo : source_color;
uniform sampler2D main_texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform ivec2 main_albedo_texture_size;
uniform float main_point_size : hint_range(0.1, 128.0, 0.1);

uniform float main_roughness : hint_range(0.0, 1.0);
uniform sampler2D main_texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 main_roughness_texture_channel;
uniform vec4 main_metallic_texture_channel;
uniform sampler2D main_texture_roughness : hint_roughness_g, filter_linear_mipmap, repeat_enable;

uniform float main_specular : hint_range(0.0, 1.0, 0.01);
uniform float main_metallic : hint_range(0.0, 1.0, 0.01);

uniform sampler2D main_texture_normal : hint_roughness_normal, filter_linear_mipmap, repeat_enable;
uniform float main_normal_scale : hint_range(-16.0, 16.0);

uniform sampler2D main_texture_ambient_occlusion : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 main_ao_texture_channel;
uniform float main_ao_light_affect : hint_range(0.0, 1.0, 0.01);

uniform vec4 overlay_albedo : source_color;
uniform sampler2D overlay_texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform ivec2 overlay_albedo_texture_size;
uniform float overlay_point_size : hint_range(0.1, 128.0, 0.1);

uniform float overlay_roughness : hint_range(0.0, 1.0);
uniform sampler2D overlay_texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 overlay_roughness_texture_channel;
uniform vec4 overlay_metallic_texture_channel;
uniform sampler2D overlay_texture_roughness : hint_roughness_g, filter_linear_mipmap, repeat_enable;

uniform float overlay_specular : hint_range(0.0, 1.0, 0.01);
uniform float overlay_metallic : hint_range(0.0, 1.0, 0.01);

uniform sampler2D overlay_texture_normal : hint_roughness_normal, filter_linear_mipmap, repeat_enable;
uniform float overlay_normal_scale : hint_range(-16.0, 16.0);

uniform sampler2D overlay_texture_ambient_occlusion : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 overlay_ao_texture_channel;
uniform float overlay_ao_light_affect : hint_range(0.0, 1.0, 0.01);

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;


uniform float expo;

varying mat3 tbn;

void vertex() {
	vec3 world_space_normal = normalize(MODEL_NORMAL_MATRIX * NORMAL);
	vec3 world_space_tangent = normalize(MODEL_NORMAL_MATRIX * TANGENT);
	vec3 world_space_binormal = normalize(MODEL_NORMAL_MATRIX * BINORMAL);
	tbn = mat3(world_space_tangent, world_space_binormal, world_space_normal);
	UV = UV * uv1_scale.xy + uv1_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;
	
	float d = max(0.0, dot(tbn * -(texture(main_texture_normal, UV).rgb * 2.0 - 1.0), vec3(0.0, 1.0, 0.0)));
	d = pow(d, expo);

	vec4 albedo = mix(main_albedo, overlay_albedo, d);
	vec4 albedo_tex = mix(texture(main_texture_albedo, base_uv), texture(overlay_texture_albedo, base_uv), d);
	ALBEDO = albedo.rgb * albedo_tex.rgb;

	float metallic_tex = mix(
		dot(texture(main_texture_metallic, base_uv), main_metallic_texture_channel),
		dot(texture(overlay_texture_metallic, base_uv), overlay_metallic_texture_channel),
		d
	);
	float metallic = mix(main_metallic, overlay_metallic, d);
	METALLIC = metallic_tex * metallic;
	SPECULAR = mix(main_specular, overlay_specular, d);

	vec4 roughness_texture_channel = vec4(0.0, 1.0, 0.0, 0.0);
	float roughness_tex = mix(
		dot(texture(main_texture_roughness, base_uv), main_roughness_texture_channel),
		dot(texture(overlay_texture_roughness, base_uv), overlay_roughness_texture_channel),
		d
	);
	float roughness = mix(main_roughness, overlay_roughness, d);
	ROUGHNESS = roughness_tex * roughness;

	NORMAL_MAP = mix(
		texture(main_texture_normal, base_uv).rgb,
		texture(overlay_texture_normal, base_uv).rgb,
		d
	);
	NORMAL_MAP_DEPTH = mix(main_normal_scale, overlay_normal_scale, d);

	AO = mix(
		dot(texture(main_texture_ambient_occlusion, base_uv), main_ao_texture_channel),
		dot(texture(overlay_texture_ambient_occlusion, base_uv), overlay_ao_texture_channel),
		d
	);
	AO_LIGHT_AFFECT = mix(main_ao_light_affect, overlay_ao_light_affect, d);
}
