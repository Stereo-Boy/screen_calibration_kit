function paramOptim=ScreenCalibration(mode, viewPixx, bit_list, gammaParam)
%-----------------------------------------------------------------------
% Goal of the function: find the gamma parameters for screen gamma correction
% to make the screen luminance vary linearly with the bit values.
% It can then be used with the sc function each time you want a specific
% luminance. ex for 10 cd.m-2: Screen('FillRect',scr.w,sc(10,paramOptim));
% 
%  paramOptim follows the function: luminance = paramOptim(1).*(bit.^paramOptim(2)));
%-----------------------------------------------------------------------
%Outputs: optimized gamma parameters to use with 'sc' function
%
% Mode is either 1 or 2:
%       1: measure mode - show the screen, take the measures, issue the calibration parameters
%       2: test just one specific value ( for the value in sc(), use quickPhotoTest)
%       3: check mode - take the calibration parameters, show the screen, take the measure, issue error
% viewPixx = 1 (add viewPixx capability) or 0
% optional background color bit_list for mode 2 - when used, should be just one value
% optional gammaParam for mode = 3 (box parameter for the sc function in which you have input the results)
%-----------------------------------------------------------------------
%Last edit: feb 2020 (Adrien Chopin, adrien.chopin@gmail.com)
%
%-----------------------------------------------------------------------


pas=25;
paramOptim=[];
if exist('viewPixx','var')==0 || isempty(viewPixx); viewPixx = 0; end
   
if mode==1
    bit_list =  0:pas:255; fig=1;
end
scr.inputMode = 1;
if mode==3
    listLum=0:10:100; fig=2;
    bit_list=sc(listLum, gammaParam);
end

screens=Screen('Screens');
scr.screenNumber=max(screens); 
scr.res=Screen('rect', scr.screenNumber);    
Screen('Preference', 'SkipSyncTests', 2); % this is to avoid sync failure to crash the code
Screen('Preference', 'Verbosity',0);
scr.keyboard = -1; 
switch mode
  case{1,3}
      j=1;
    for i=bit_list 
        HideCursor;
        %show luminance screen
        while isfield(scr,'w')==0 % this is to avoid sync failure to crash the code
            scr = tryOpeningWin(scr);
        end
            if viewPixx==1 % this needs the usb cable plugged in
                Datapixx('Open');
                Datapixx('EnableVideoScanningBacklight');
                Datapixx('RegWrRd');
                status = Datapixx('GetVideoStatus');
                fprintf('Scanning Backling mode on = %d\n', status.scanningBacklight);
                Datapixx('Close');
            end
         Screen('FillRect',scr.w,i);
         Screen('Flip',scr.w);
        waitForKey(scr.keyboard, scr.inputMode);
        Screen('CloseAll');
        scr = rmfield(scr,'w');
        %ask for measured luminance
        ShowCursor;
        try
            lum(j) = input('Measured Luminance?');
        catch
           warning('You did something wrong, please try again:') ;
           lum(j) = input('Measured Luminance?');
        end
        j=j+1;
    end
    Screen('CloseAll');
    bit = bit_list;
    if mode==3
        bit = listLum;
    end
    %find correction
    paramOptim=fitparam(bit,lum,fig);
    if fig==1
        xlabel('Bit'); %GUN
    else
        xlabel('Luminance wanted');  
    end
        ylabel('Luminance measured');
        
    if mode==1
        disp('Screen calibration is finished');
        dispi('Gamma parameters are ',paramOptim(1),' and ', paramOptim(2));
        dispi('Max luminance for that screen: ', paramOptim(1).*(255.^paramOptim(2)),' cd.m-2'); 
    end
    if mode==3
        disp('Verification finished');
    end
   case{2}
       HideCursor
        %show luminance screen
         window=Screen('OpenWindow',0,0,[],32,2);
            if viewPixx==1 % this needs the usb cable plugged in
                Datapixx('Open');
                Datapixx('EnableVideoScanningBacklight');
                Datapixx('RegWrRd');
                status = Datapixx('GetVideoStatus');
                fprintf('Scanning Backling mode on = %d\n', status.scanningBacklight);
                Datapixx('Close');
            end
         Screen('FillRect',window,bit_list);
         Screen('Flip',window);
        KbWait;
        Screen('CloseAll');
        ShowCursor;
end

end

function scr = tryOpeningWin(scr)
    try
        scr.w=Screen('OpenWindow',0,0,[],32,2);
    catch
        scr = tryOpeningWin(scr);    
    end   

end
