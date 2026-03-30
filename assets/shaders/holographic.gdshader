shader_type canvas_item;

uniform highp vec2 offset;
uniform highp float speed : hint_range(0, 1) = 0.3;
vec4 effect(sampler2D tex, vec2 texture_coords, float time) {
	vec4 texel = texture(tex, texture_coords);
	vec2 uv = texture_coords;

	vec2 adjusted_uv = uv - vec2(0.5, 0.5);
	
	float low = min(texel.r, min(texel.g, texel.b));
    float high = max(texel.r, max(texel.g, texel.b));
	float delta = min(high, max(0.5, 1. - low));
	
	vec2 foil = vec2(time / (1. / speed) + offset.x, offset.y);
	
	// fac desligado (era o círculo central)
	float fac = 0.0;
	
	vec2 rotater = vec2(cos(foil.r * 0.1221), sin(foil.r * 0.3512));
	float angle = dot(rotater, adjusted_uv) / (length(rotater) * length(adjusted_uv));
	float fac2 = max(min(5. * cos(foil.g * 0.3 + angle * 3.14*(2.2 + 0.9*sin(foil.r * 1.65 + 0.2 * foil.g))) - 4. - max(2.-length(20.*adjusted_uv), 0.), 1.), 0.);
	
	// Ajustando fac3 e fac4 para serem mais diagonais (uv.x + uv.y)
	float fac3 = 0.3 * max(min(2. * sin(foil.r * 5. + (uv.x + uv.y) * 3. + 3. * (1. + 0.5 * cos(foil.r * 7.))) - 1., 1.), -1.);
	float fac4 = 0.3 * max(min(2. * sin(foil.r * 6.66 + (uv.x + uv.y) * 3.8 + 3. * (1. + 0.5 * cos(foil.r * 3.414))) - 1., 1.), -1.);

	// maxfac calcula a intensidade do brilho
	float maxfac = max(max(fac, max(fac2, max(fac3, max(fac4, 0.0)))) + 1.5 * (fac + fac2 + fac3 + fac4), 0.0);

	// Rainbow color generation
	vec3 rainbow;
	rainbow.r = 0.5 + 0.5 * cos(6.28318 * (maxfac * 0.3 + time * 0.2 + 0.0));
	rainbow.g = 0.5 + 0.5 * cos(6.28318 * (maxfac * 0.3 + time * 0.2 + 0.33));
	rainbow.b = 0.5 + 0.5 * cos(6.28318 * (maxfac * 0.3 + time * 0.2 + 0.67));

	// Mix intensity (0.2 faz o efeito ficar mais transparente/esmaecido)
	float mix_intensity = 0.25;
	texel.rgb = mix(texel.rgb, texel.rgb + rainbow * maxfac, delta * mix_intensity);
	
	// Brilho branco reduzido
	texel.rgb += vec3(maxfac * 0.05);
	// Aplica o escurecimento manual apenas nos canais RGB para não afetar a transparência
	return texel;
}

varying vec4 v_color;

void vertex() {
	v_color = COLOR;
}

void fragment() {
	COLOR = effect(TEXTURE, UV, TIME) * v_color;
}
