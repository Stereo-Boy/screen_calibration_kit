function showBinoBlankScreenNoFlip(window, backGrndColor)
% show blank screen to both eye in stereoMode 10
% scr should contain scr.w (the window)
% backGrndColor the background color or lum
% We only draw and do not flip
Screen('SelectStereoDrawBuffer', window, 1);
Screen('FillRect',window, backGrndColor);
Screen('SelectStereoDrawBuffer', window, 0);
Screen('FillRect',window, backGrndColor);