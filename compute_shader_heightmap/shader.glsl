#[compute]
#version 460

layout(local_size_x  = 8, local_size_y =8, local_size_z=1) in;
layout(r8, binding = 0) restrict uniform image2D heightmap;
layout(rgb8, binding = 1) restrict readonly uniform image2D gradient;
void main(){
    ivec2 coords = ivec2(gl_GlobalInvocationID.xy)
    ivec2 dimension = imageSize(heightmap)
    ivec2 center = dimension / 2
    int smallest_radius = min(center.x, center.y)
    float dist = distance(coords, center)
    int gradient_max_x = imageSize(gradient).x -1
}