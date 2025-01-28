# screen_calibration_kit

## Goal:
Matlab Psychtoolbox codes displayed luminance with a bit coding gray between 0 and 255.
You want to display a precise luminance in candela/m².

## Solution #1 
1) Use run_screen_calibration.m: it shows a series of uniform screens, measure each of them with the photometer
(from where your observer will look at the screen) and input the value when requested on command window.
At the end, it issues figure 1 with the gamma fit and your 2 parameters on command window.
2) Then it tries to validate those parameters by showing you uniform screens, but passing a luminance through the sc
function, using your 2 parameters. Measure and input again. You should get a straight line on figure 2.

3) Those two parameters (paramOptim) can be used with the function sc.m each time you needeach time you want a specific luminance. 
Ex for 10 cd.m-2: 
Screen('FillRect',scr.w,sc(10,paramOptim));

paramOptim follows the function: luminance = paramOptim(1).*(bit.^paramOptim(2)));

## Solution #2 (for dual screens)
### Step 1: Photometer setup 
Photometer Settings for a Minolta CS-100
* Calibration: preset
* Measuring Mode: Abs.
* Response: Slow
* Switch On
* Photometer camera should be placed where the left eye will be placed (when measuring left side) and the light path/distance should match the actual light path/distance in your experiment
* Put a visual marker on the screen center and check the alignment with the marker in the photometer aiming

### Step 2: optimize screen settings
To allow for luminance to go from a minimum value (close to 0 cd.m2) to the highest maximum value, we need to modify the screen settings. Using the buttons on the screen, navigate the menus to brightness and contrast settings and increase them both to 100%.

### Step 3: measure max displayed luminances for each screen
In case of multiple screens, the first thing to do is to make sure the maximum for each screen is as close a possible. For doing that:
* run the program called measureMaxDualScreens.m located in [https://github.com/Stereo-Boy/screen_calibration_kit this Github repository]
```
>> cd('where the screen_calibration_kit folder is located'); <br>
>> measureMaxDualScreens()
```
* put the photometer where an eye would be and aim at the center of the first screen, take a measure. Do this in conditions similar to what a subject will experience, for example, with room light off
* repeat with the second screen
* go back to the screen with the highest measured luminance and use the screen setting to decrease brightness so that the measured luminance matches the one from the other screen.

### Step 4: measure displayed luminances
From here, a code will create equal steps from 0 - 255 CLUT values upon which we will measure luminance for each screen and deduce the gamma table to use:
* Run CalibrateMonitorPhotometerDual.m from [https://github.com/Stereo-Boy/screen_calibration_kit this Github repository]
```
>> gammaTable_LE = CalibrateMonitorPhotometerDual
```
* For each screen luminance presented
** measure the luminance for the left screen and note it on a paper
** enter it with the keyboard (you will not be able to see your input)
** press enter
** repeat with the next screen luminance
This operation will generate gammaTable_LE, that will contain the gamma normalization table using a spline interpolation (using gammaTable2).
* Open params.m in matlab and modify min_lum_LE, max_lum_LE and gammaTable_LE to match what you have measured.
* Repeat the whole thing for the right screen using the same function and modify min_lum_RE, max_lum_RE and gammaTable_RE.
```
>> gammaTable_RE = CalibrateMonitorPhotometerDual
```
* Run params.m once to generate the correct params.mat file.
```
>> params()
```

### Step 5: verify calibration
* Run 
```
>> test_gamma
```
* shows the screen you want to test
* test_gamma.m loads gammaTable for each screen and shows increasing luminance step screens: measure the luminance of these presentations and note them on a paper
* enter the measured luminances when prompted, in the right order
* it will plot the relationship between luminance presented (black) and measured (red) - it should be linear.
* repeat for the other screen

### Step 6: use calibration tables
* Your code should use params.mat to load the gamma tables and LoadNormalizedGammaTable to use them.
* We then use min_lum_LE and max_lum_LE values to manually scale the requested clut to the luminances that we want to present. For example:
```
  luminance = min_lum_LE + (max_lum_LE-min_lum_LE)*requested_clut/255; 
  clut = 255*(requested_luminance - min_lum_LE)/(max_lum_LE-min_lum_LE);
```
* Alternatively, you can work directly with the CLUT, assuming that min and max are the same and that screens are perfectly linear.
