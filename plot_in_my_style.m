function plot_in_my_style(x, y, figName, varargin)

% plot_in_my_style(x, y, figName, variable_arguments): Personalize MATLAB plotting 
% with a more intuitive and less "talkative" command style
%   -----------------------------------------------------------------------
%   ------------------------------ ARGUMENTS ------------------------------
%   -----------------------------------------------------------------------
%   |     Input argument | Explanation                                   |
%   | ----------------- :|: -------------------------------------------- |
%   | ----------------- :|: -------------------------------------------- |
%   |                  x | cell containing vectors of the x-axis signals |
%   | ------------------------------------------------------------------ |
%   |                  y | cell containing vectors of the y-axis signals |
%   | ------------------------------------------------------------------ |
%   |            figName | Name of the figure and title                  |
%   | ------------------------------------------------------------------ |
%   | variable_arguments | * {'existing_fig', iFig} or                   |
%   |                    |   {'existing_figure', iFig} or                |
%   |                    |   {'exist_fig', iFig} or                      |
%   |                    |   {'exist_figure', iFig}, where iFig is the   |                                            |
%   |                    |   number of the existing figure               |                     
%   |                    | * {'save', folderSave, figName, figFormat}    |
%   |                    |                                               |
%   |                    |                                               |
%   |                    |                                               |
%   -----------------------------------------------------------------------
%   ------------------------------ EXAMPLES -------------------------------
%   -----------------------------------------------------------------------
%   Example #0: 
%   -----------
%       x1 = 0:0.01:5; 
%       x2 = 0:0.01:10; 
%       y1 = sin(2*x1);
%       y2 = cos(x2);
%       X = {x1, x2};
%       Y = {y1, y2};
%       % a. Simple plot, without any variable arguments:
%       plot_in_my_style(X, Y, 'fig');
%         
%       % b. Add legend:
%       plot_in_my_style(X, Y, 'fig', 'legend', {'signal_1', 'signal_2'});
%       % Can also write: 'legend', 'leg', 'Leg' or 'Legend' as well 
%
%       % c. Bring plot in dark mode:
%       plot_in_my_style(X, Y, 'fig', 'legend', {'signal_1', 'signal_2'}, 'dark');  
%       % Can also write: 'dark', 'black', 'night'
%         
%       % d. Use two separate y-plots and add axes labels:
%       Y = {y1, 100*y2}; % signals with different orders of magnitude and/or units
%       plot_in_my_style(...
%           X, Y, 'fig',...
%           'legend', {'signal_1', 'signal_2'}, ...
%           'sepY',...
%           'xLab', {'t [s]'},...
%           'yLab', {'v_1 [m/s]', 'v_2 [mm/s]'});
%       % Can also write: 'xAxis', 'xLab', 'yAxis', 'yLab'







asc = @(x)any(strcmp(varargin, x));
fsc = @(x)find(strcmp(varargin, x));

func.asc0 = @(x, y)any(strcmp(y, x));
func.fsc0 = @(x, y)find(strcmp(y, x));

usr_map = {
    {{'existing_fig', 'existing_figure', 'exist_fig', 'exist_figure'},...
                                {'existing_fig', 'fig_num'}}
    {{'xAxis', 'xLab'},         {'~', 'xLab'}}
    {{'yAxis', 'yLab'},         {'~', 'yLab'}}
    {{'legend', 'leg', 'Leg', 'Legend'},...
                                {'~', 'legTxt'}}
    {{'sepY'},                  {'has_separate_Y_axes', '~'}}
    {{'has_reference_signal'},  {'has_reference_signal', '~'}}
    {{'special_case'},          {'has_special_case', 'special_case'}}
    {{'subplot'},               {'use_subplot', '~'}}
    {{'dark', 'black', 'night'},{'dark_plot', '~'}}
    {{'style'},                 {'has_usr_style', 'stylePlt'}}
    {{'LineWidth', 'width'},    {'has_lnwdth', 'lnwdth'}}
    {{'units', 'unit'},         {'has_units', 'units'}}
    {{'black_and_white', 'black_white', 'black-white'}, ...
                                {'is_black_white', '~'}}
    };

len = @(x)length(x);

% Write default values
fontSize        = 30;
lnwdth0         = 3;
special_case    = 'none';
%

switch nargin
    case 0
        % do nothing
    otherwise

        tmpStr = 'save';
        if asc(tmpStr)
            saveImg = 1;
            pos_last = fsc(tmpStr);
            folderSave = varargin{pos_last + 1};
            figNameSave = varargin{pos_last + 2};
            figFormat = varargin{pos_last + 3};
        else
            saveImg = 0;
        end

        for iS = 1:length(usr_map)
            tmpI = usr_map{iS}; tmpI2 = tmpI{2};
            
            if ~strcmp(tmpI2{2}, '~')
                hasPos = ", 'position'";
            else
                hasPos = {''};
            end
            Cmd = ['[', tmpI2{1}, ', ', tmpI2{2}, '] = ',...
                'get_plot_attrib(varargin, tmpI{1}, func', hasPos{1}, ');'];
            eval(Cmd);
        end
        
        if has_separate_Y_axes && use_subplot
            has_separate_Y_axes = 0;
        end
        
        
        if has_usr_style
            stylePlt = stylePlt{1};
        else
            stylePlt = {};
            for i = 1:20
                stylePlt{i} = ['-'];
            end
        end

end


% Properties
% =\==================================================\==================================================
figPos = [10 118 981 651];
figColor_dark = [0.741176470588235 0.666666666666667 0.666666666666667];
darkColor = [0 0 0];
lnWdth_special_case = 0.5;
% \==================================================\==================================================

if ~has_lnwdth
   lnwdth = lnwdth0; 
end


if ~existing_fig
    if ~dark_plot
        h = figure('Name', figName, 'Position', figPos);
    else
        h = figure('Name', figName, 'Position', figPos, 'Color', figColor_dark);
    end
    set(h,'Units','Inches');
    pos = get(h,'Position');
else
    h = figure(fig_num);
end

if ~is_black_white
    
    clr = {'', '', ''};
    
else
    % add colors that are very different, so that they can be easily
    % distinguished in a black-white scale for PDF printing
    if ~dark_plot
        clr0 = 'k';
    else
        clr0 = 'w';
    end
    clr = {clr0, clr0, clr0, clr0, clr0, clr0, clr0, clr0};
    stylePlt = {'-', '--', 'o', 'dot', 'anythingelse'};
    
end


trigered_special_case = 0;
Lx = length(x);

for j = 1:length(y)
    trig_special_case = strcmp(special_case, 'has_predicted_signals')...
        && (j >= 2 + has_reference_signal); 
    if trig_special_case
        lnwdth = lnWdth_special_case;
        trigered_special_case = 1;
    end
    if has_reference_signal && j == 2
        stylePlt{j} = 'r--';
    end
    if trigered_special_case
        stylePlt{j} = 'k-';
    end
    if has_separate_Y_axes
        if mod(j, 2) == 1
            yyaxis left
        else
            yyaxis right
        end
        stylePlt{j} = [clr{j}, stylePlt{j}];
    end
    
    if j > Lx
        jx = Lx;
    else
        jx = j;
    end
    
    
    if use_subplot
       subplot(Lx, j, 1); 
    end
    
    plot(x{jx}, y{j}, stylePlt{j}, 'LineWidth', lnwdth);
    hold on; grid on;
end

title(figName)
hold off
Ly_lab = len(yLab);
if has_units
    for iL = 1:Ly_lab
        iL1 = 1+iL;
        if 1+iL > len(units)
            iL1 = len(units);
        end
        yLab{iL} = [yLab{iL}, ' [', units{iL1}, ']'];
    end
    xLab{1} = [xLab{1}, ' [', units{1}, ']'];
end
xlabel(xLab)
switch len(yLab)
    case 2
        yyaxis left
        ylabel(yLab{1})
        yyaxis right
        ylabel(yLab{2})
    case 1
        ylabel(yLab{1})
    case 0
        ylabel('')
    otherwise
        error('Nothing coded here')
end

if ~strcmp(legTxt, '')
    legend(legTxt, 'FontSize', 18)
end


if dark_plot
    set(gca,'FontSize',fontSize,'FontWeight','bold','Color',darkColor,...
        'GridColor', 'green')
else
    set(gca,'FontSize',fontSize,'FontWeight','bold')
    
end

if saveImg
    folderSave = [folderSave, '\'];
    for i_dum = 1:length(figFormat)
        if ~strcmp(figFormat{i_dum}, 'pdf')
            name_save = [folderSave, figNameSave, '.', figFormat{i_dum}];
            saveas(gca, fullfile(name_save), figFormat{i_dum});
        else
            set(h,'PaperPositionMode','Auto','PaperUnits',...
                'Inches','PaperSize',[pos(3), pos(4)]);
            print(h,figNameSave,'-dpdf','-r0')
            name_save = [folderSave, figNameSave, '.', figFormat{i_dum}];
            saveas(gca, fullfile(name_save), figFormat{i_dum});     
        end
    end
end


