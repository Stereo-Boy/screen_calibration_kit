# screen_calibration_kit

Goal:
Matlab Psychtoolbox codes displayed luminance with a bit coding gray between 0 and 255.
You want to display a precise luminance in candela/m².

Solution: 
1) Use run_screen_calibration.m: it shows a series of uniform screens, measure each of them with the photometer
(from where your observer will look at the screen) and input the value when requested on command window.
At the end, it issues figure 1 with the gamma fit and your 2 parameters on command window.
2) Then it tries to validate those parameters by showing you uniform screens, but passing a luminance through the sc
function, using your 2 parameters. Measure and input again. You should get a straight line on figure 2.

3) Those two parameters (paramOptim) can be used with the function sc.m each time you needeach time you want a specific luminance. 
Ex for 10 cd.m-2: 
Screen('FillRect',scr.w,sc(10,paramOptim));

paramOptim follows the function: luminance = paramOptim(1).*(bit.^paramOptim(2)));
