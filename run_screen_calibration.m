%-----------------------------------------------------------------------
% Goal of the function: find the gamma parameters for screen gamma correction
% to make the screen luminance vary linearly with the bit values.
% It can then be used with the sc function each time you want a specific
% luminance. ex for 10 cd.m-2: Screen('FillRect',scr.w,sc(10,paramOptim));
% 
%  paramOptim follows the function: luminance = paramOptim(1).*(bit.^paramOptim(2)));
%-----------------------------------------------------------------------
%
% This is the wrapper function to run the screen calibration
% Please measure the luminance each time you see a blank screen.
% We start with a calibration followed by a validation.
% This needs the PsychToolBox.
%-----------------------------------------------------------------------

viewpixx = 0; % change that to 1 if needed
paramOptim=ScreenCalibration(1,viewpixx);
ScreenCalibration(3, viewpixx,[],paramOptim)
dispi('Final gamma parameters are ',paramOptim(1),' and ', paramOptim(2))