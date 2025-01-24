function measureMaxDualScreens
% a function to use to help you measure the maximum luminance dispayed on each screen of a dual screen display

    scr.stereoMode = 10;  % set stereoMode for dual monitor setup
    Screen('Preference', 'SkipSyncTests', 2);  % This will need to be changed eventually but temporary, for demo, we skip tests
    scr.w = PsychImaging('OpenWindow', 1, 255, [], [], [], scr.stereoMode);
    Screen('OpenWindow', 2, 255, [], [], [], scr.stereoMode);

end
