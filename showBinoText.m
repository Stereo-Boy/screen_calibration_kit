function onset = showBinoText(window, text, black)
% draw stereotext in stereoMode 10 with 2 screens, black on gray, with flip
Screen('SelectStereoDrawBuffer', window, 0); % AG
DrawFormattedText(window, text, 'center', 'center', black) ;
Screen('SelectStereoDrawBuffer', window, 1); % AG     
DrawFormattedText(window, text, 'center','center', black) ; % AG
onset = Screen('Flip', window) ; % AG