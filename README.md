# Surface Stable Fractal Dithering

An implementation of surface stable fractal dithering based off of [this video](https://www.youtube.com/watch?v=HPqGaIMVuLs). The main differences from that video include adding an obliqueness correction factor based on the dot product of the surface normal and the viewing direction, using screen space coordinates for sizing the dots, and adding additional random jitter to the dots (to smooth out the grid structure).

![A scene rendered using surface stable fractal dithering](images/vid.gif)

The algorithm works as follows:
1. Starting in a spatial fragment shader for each object, we do the following.
2. Calculate the model space coordinates of the fragment.
3. Calculate the dot product of the surface normal and the viewing direction.
4. Calculate the distance in model space between the fragment and the viewing plane.
5. Use `log2(dist / pow(cosAngle,0.3))` (with additional factors for overall scale and window size) to calculate the fractal level. The reason for the `pow` there is because we want the cosine to directly scale the density of dots on the surface, or in other words scale the surface area per dot. Thus we need to take the square root to get a linear scale factor. (Using `0.3` instead of `0.5` seems to create more uniform dot densities at oblique angles.)
6. Take the largest power of two smaller than the level, and round each of the coordinates of the model space coords to multiples of that power.
7. Add some random jitter proportional to that power to the rounded coordinates.
8. Calculate the screen space coordinates of those offset coordinates.
9. Calculate a shade based on the distance between those screen space coordinates and the screen space coordinates of the fragment.
10. Repeat steps 6-9 for the next power of two, and interpolate between the shades based on the fractional part of the log from step 5. Note that it uses power corrected interpolation, which evens out the visual banding between fractal levels.
11. The interpolated shade of gray becomes the albedo for the fragment.
12. Regular 3D lighting is then applied to the scene.
13. In a post-process filter, a threshold is applied. Any pixels below the threshold are made one color, while any above are a different color.

Note: A previous commit (`06079f4`) used a different algorithm with three separate fractal levels per model space axis. This corrected for obliqueness along those axes, however diagonals still had some squashing of the dither pattern.
