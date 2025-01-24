function [keypressed, secs] = wait4spaceKeyPress(expe, scr)
% Wait for a space key or escape key press. This function waits for a space key press or an escape key press and returns
% the key code and the time in seconds when the key was pressed.
% Input:
% expe structure that should have at least have for fields
%   - space: The key code for the space key.
%   - escape: The key code for the escape key.
% Output:
%   - keypressed: The key code of the pressed key (space or escape).
%   - secs: The time in seconds when the key was pressed.
  while true
        [keyIsDown, secs, keyCode] = KbCheck; % Check for key press
        FlushEvents('keyDown'); % Clear the event queue for key-down events
        if keyIsDown
            nKeys = sum(keyCode); % Count the number of keys pressed
            if nKeys == 1
                if keyCode(expe.space) % Check if the space key is pressed
                    keypressed = find(keyCode); % Get the key code of the pressed key
                    break; % Exit the loop
                elseif keyCode(expe.escape) % Check if the escape key is pressed
                    disp('Escape key pressed: exiting.');
                    keypressed = find(keyCode); % Get the key code of the pressed key
                    break;
                end
            end
        end
  end
end