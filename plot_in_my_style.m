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
%   |                    |   {'exist_figure', iFig}, where iFig is the   |                            
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
%       % Can also write: 'xAxis', 'xLab', 'xL', 'yAxis', 'yLab', 'yL'
% 
%       % e. Case d., but for black-white page, and with explicit units:
%       plot_in_my_style(...
%           X, Y, 'fig',...
%           'leg',      {'signal_1', 'signal_2'}, ...
%           'sepY',...
%           'xLab',     {'t'},...
%           'yLab',     {'v_1', 'v_2'},...
%           'units',    {'s', 'm/s', 'm/s^2'},...
%           'dark',...
%           'black-white');
%       % Can also write: 'black_and_white', 'black_white', 'black-white'
%       f. Case e., but plotting on an existing figure (i.e. not generating a new one)
%       plot_in_my_style(...
%           X, Y, 'fig',...
%           'leg',      {'signal_1', 'signal_2'}, ...
%           'sepY',...
%           'xLab',     {'t'},...
%           'yLab',     {'v_1', 'v_2'},...
%           'units',    {'s', 'm/s', 'm/s^2'},...
%           'dark',...
%           'black-white',...
%           'exist-fig', 1);
%       % Can also write: 'existing_fig', 'existing_figure', 'exist_fig', 'exist_figure' 'exist-fig', 'fig-exist'




% Gather frequently used functions ========================================
asc = @(x)any(strcmp(varargin, x));
fsc = @(x)find(strcmp(varargin, x));

func.asc0 = @(x, y)any(strcmp(y, x));
func.fsc0 = @(x, y)find(strcmp(y, x));
len = @(x)length(x);

% \==================================================\==================================================

% Create a map of variable arguments (left column of 'usr_map') and
% function related variables that will be used in order to achieve the
% command imposed by the variable argument:
% More specifically, the 1st (or left) column of 'usr_map' specifies all
% viable variable arguments of the function.When the ith element of the 1st
% column usr_map{i, 1} has dimension larger than one, this means that the
% user can write the variable argument in different ways, making the
% program more intuitive.
% Examples:
% 1. If the user provides the argument: 'exist_fig' followed by an integer,
% this tells the function not to create a new figure, but to instead plot
% in an existing one (specified by the integer)
usr_map = {
    {{'existing_fig', 'existing_figure', 'exist_fig', 'exist_figure',...
    'exist-fig', 'fig-exist', 'fig', 'FIG', 'Fig'},...
                                    {'existing_fig', 'fig_num'}}
    {{'xAxis', 'xLab', 'xL', 'xl'},	{'~', 'xLab'}}
    {{'yAxis', 'yLab', 'yL', 'yl'},	{'~', 'yLab'}}
    {{'legend', 'leg', 'Leg', 'Legend'},...
                                    {'~', 'legTxt'}}
    {{'sepY', 'separate-Y'},        {'has_separate_Y_axes', '~'}}
    {{'has_reference_signal'},      {'has_reference_signal', '~'}}
    {{'special_case'},              {'has_special_case', 'special_case'}}
    {{'subplot'},                   {'use_subplot', '~'}}
    {{'dark', 'black', 'night'},    {'dark_plot', '~'}}
    {{'style'},                     {'has_usr_style', 'stylePlt'}}
    {{'LineWidth', 'width'},        {'has_lnwdth', 'lnwdth'}}
    {{'units', 'unit'},             {'has_units', 'units'}}
    {{'black_and_white', 'black_white', 'black-white'}, ...
                                    {'is_black_white', '~'}}
    {{'bar'},                       {'is_bar', '~'}}
    {{'txtbox'},                    {'has_txtbox', 'Stxtbox'}}
    };

% \==================================================\==================================================


% Default Properties
% =\==================================================\==================================================
fontSize        = 30;
lnwdth0         = 3;
special_case    = 'none';
figPos = [10 118 981 651];
figColor_dark = [0.650980392156863 0.650980392156863 0.650980392156863];
darkColor = [0 0 0];
lnWdth_special_case = 0.5;
legTxtClr = [0 0 0];
legEdgeClr = [0 0 0];
legClr = [1 1 1];
% \==================================================\==================================================

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
    if dark_plot
        set(h, 'Color', figColor_dark)
    end
end

if ~is_black_white
%     clr = {'', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''};
    clr      = {'b', 'k', 'r', 'm', 'g', 'k',  'b'};
    stylePlt = {'-', '-', '-', '-', '-', '--', '--'};
else
    % add colors that are very different, so that they can be easily
    % distinguished in a black-white scale for PDF printing
    if ~dark_plot 
        clr0 = 'k';
    else
        clr0 = 'w';
        legTxtClr = [1 1 1];
        legEdgeClr = [1 1 1];
        legClr = [0 0 0];
    end
    clr = {clr0, clr0, clr0, clr0, clr0, clr0, clr0, clr0};
    stylePlt = {'-', '--', '.', 'o', 'anythingelse'};
end

trigered_special_case = 0;
Lx = length(x);


Ly = length(y);
for j = 1:Ly
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
        if Ly == 2
            if mod(j, 2) == 1
                yyaxis left
            else
                yyaxis right
            end
        elseif Ly == 3
            if j < Ly
                yyaxis left
            else
                yyaxis right
            end
        elseif Ly == 4
            if j <= 2
                yyaxis left
            else
                yyaxis right
            end
        end
    end
    stylePlt{j} = [clr{j}, stylePlt{j}];
    if j > Lx
        jx = Lx;
    else
        jx = j;
    end
    
    
    if use_subplot
       subplot(Lx, j, 1); 
    end
    
    if ~is_bar
        plot(x{jx}, y{j}, stylePlt{j}, 'LineWidth', lnwdth);
    else
        bar(x{jx}, y{j}, 'LineWidth', lnwdth);
    end
    hold on; grid on;
end

if has_txtbox
    dim = [.0 .5 .0 .3];
    annotation('textbox', dim, 'String', Stxtbox, 'FitBoxToText', 'on');
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
        if has_separate_Y_axes
            yyaxis left
            ylabel(yLab{1})
            yyaxis right
            ylabel(yLab{2})
        else
            ylabel(yLab{1})
        end
    case 1
        ylabel(yLab{1})
    case 0
        ylabel('')
    otherwise
        error('Nothing coded here')
end

if ~strcmp(legTxt, '')
    
%     legend1 = legend(axes1,'show');

% set(legend,'TextColor',[1 1 1],...
%     'Position',[0.749041664282483 0.731490784993324 0.139500002384186 0.102261308809021],...
%     'FontSize',18,...
%     'EdgeColor',[1 1 1]);
    legend(legTxt, 'FontSize', 18, 'Color', legClr,...
        'TextColor', legTxtClr, 'EdgeColor', legEdgeClr)
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
        if strcmp(figFormat{i_dum}, 'pdf')
            set(h,'PaperPositionMode','Auto','PaperUnits',...
                'Inches','PaperSize',[pos(3), pos(4)]);
            print(h,figNameSave,'-dpdf','-r0')
        end
        name_save = [folderSave, figNameSave, '.', figFormat{i_dum}];
        saveas(gca, fullfile(name_save), figFormat{i_dum});
    end
end
end

function [cond, varargout] = get_plot_attrib(in, S, func, varargin)

cond = false;
vout2 = '';
if ~iscell(S)
   S = {S}; 
end
asc = func.asc0; %@(x, y)any(strcmp(y, x));
fsc = func.fsc0; %@(x, y)find(strcmp(y, x));
for i = 1:length(S)
    if asc(in, S{i})
        cond = true;
        if ~isempty(varargin)
            if asc(varargin, 'position')
                pos_last = fsc(in, S{i});
                vout2 = in{pos_last+1};
            end
        end
        break;
    end
end
varargout{1} = vout2;
end
