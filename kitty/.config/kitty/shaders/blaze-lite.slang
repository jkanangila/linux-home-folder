#language slang 2026
// Lightweight Blaze-style cursor trail for kitty 0.49+.
// Single pass, no off-screen textures, no multi-pass blur.

import kitty_custom_shader_types;

// Colors are in linear RGB.
static const float4 CORE_COLOR = float4(1.0, 0.52, 0.10, 1.0);
static const float4 EDGE_COLOR = float4(0.80, 0.12, 0.025, 1.0);
static const float4 GLOW_COLOR = float4(1.0, 0.25, 0.035, 1.0);

// Tuning parameters (can be overridden from the .pipeline file).
static const float GLOW_RADIUS = 9.0;
static const float GLOW_STRENGTH = 0.24;
static const float CORE_STRENGTH = 0.88;
static const float EDGE_WIDTH = 2.2;
static const float AA_WIDTH = 1.35;

// Distance from a point to a line segment.
static float
segment_distance(float2 p, float2 a, float2 b) {
    float2 ab = b - a;
    float denom = max(dot(ab, ab), 0.0001);
    float h = clamp(dot(p - a, ab) / denom, 0.0, 1.0);
    return length(p - (a + h * ab));
}

// Signed distance to a quadrilateral. The supplied points are in perimeter order.
static float
quad_distance(float2 p, float2 a, float2 b, float2 c, float2 d) {
    float dist = min(
        min(segment_distance(p, a, b), segment_distance(p, b, c)),
        min(segment_distance(p, c, d), segment_distance(p, d, a))
    );

    bool inside = false;
    inside = inside != ((a.y > p.y) != (b.y > p.y) &&
        p.x < (b.x - a.x) * (p.y - a.y) / (b.y - a.y + 0.00001) + a.x);
    inside = inside != ((b.y > p.y) != (c.y > p.y) &&
        p.x < (c.x - b.x) * (p.y - b.y) / (c.y - b.y + 0.00001) + b.x);
    inside = inside != ((c.y > p.y) != (d.y > p.y) &&
        p.x < (d.x - c.x) * (p.y - c.y) / (d.y - c.y + 0.00001) + c.x);
    inside = inside != ((d.y > p.y) != (a.y > p.y) &&
        p.x < (a.x - d.x) * (p.y - d.y) / (a.y - d.y + 0.00001) + d.x);

    return inside ? -dist : dist;
}

static float
box_distance(float2 p, float2 center, float2 half_size) {
    float2 q = abs(p - center) - half_size;
    return length(max(q, float2(0.0))) + min(max(q.x, q.y), 0.0);
}

public float4
fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
    // Do no work when there is no active cursor trail.
    if (d.cursor_trail_color.a <= 0.0 || d.cursor_trail_state <= 0.0) {
        return color;
    }

    float2 pixel_dims = float2(d.viewport_size_pixels) * t.viewport.zw;
    float2 p = t.pos * pixel_dims;

    // Kitty corner order: 0=top-right, 1=bottom-right,
    // 2=bottom-left, 3=top-left.
    float2 tr = float2(d.cursor_trail_corners_x.x, d.cursor_trail_corners_y.x) * pixel_dims;
    float2 br = float2(d.cursor_trail_corners_x.y, d.cursor_trail_corners_y.y) * pixel_dims;
    float2 bl = float2(d.cursor_trail_corners_x.z, d.cursor_trail_corners_y.z) * pixel_dims;
    float2 tl = float2(d.cursor_trail_corners_x.w, d.cursor_trail_corners_y.w) * pixel_dims;

    float sdf = quad_distance(p, tr, br, bl, tl);

    // Restore the active cursor itself so the trail never obscures it.
    float left = d.cursor_trail_edge.x * pixel_dims.x;
    float right = d.cursor_trail_edge.y * pixel_dims.x;
    float top = d.cursor_trail_edge.z * pixel_dims.y;
    float bottom = d.cursor_trail_edge.w * pixel_dims.y;
    float2 cursor_center = float2((left + right) * 0.5, (top + bottom) * 0.5);
    float2 cursor_half_size = float2((right - left) * 0.5, (top - bottom) * 0.5);
    float cursor_sdf = box_distance(p, cursor_center, cursor_half_size);
    if (cursor_sdf <= 0.0) {
        return color;
    }

    // Cheap analytic glow: one distance evaluation and one exponential.
    float outside_dist = max(sdf, 0.0);
    float glow = exp(-outside_dist / max(GLOW_RADIUS, 0.1)) * GLOW_STRENGTH;
    float body = 1.0 - smoothstep(-AA_WIDTH, AA_WIDTH, sdf);
    float edge = 1.0 - smoothstep(EDGE_WIDTH - AA_WIDTH, EDGE_WIDTH + AA_WIDTH, abs(sdf));

    // Fade toward the older end of the trail, using the trail's own geometry.
    float2 trail_center = (tr + br + bl + tl) * 0.25;
    float2 cursor_to_pixel = p - cursor_center;
    float2 trail_axis = trail_center - cursor_center;
    float axis_len2 = max(dot(trail_axis, trail_axis), 1.0);
    float along = clamp(dot(cursor_to_pixel, trail_axis) / axis_len2, 0.0, 1.0);
    float tail_fade = 0.30 + 0.70 * along;

    float alpha = clamp((glow + body * CORE_STRENGTH) * d.cursor_trail_color.a * tail_fade, 0.0, 0.95);
    float4 result = lerp(color, GLOW_COLOR, clamp(glow * tail_fade, 0.0, 1.0));
    result = lerp(result, EDGE_COLOR, clamp(edge * body * 0.48 * tail_fade, 0.0, 1.0));
    result = lerp(result, CORE_COLOR, clamp(body * CORE_STRENGTH * tail_fade, 0.0, 1.0));

    return lerp(color, result, alpha);
}
