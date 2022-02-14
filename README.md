# MATLAB-Personalized-Plotter

This is a simple tool (both in usage and development) that serves the purpose of simplifying and generalizing the process of plotting in MATLAB.

Despite the fact that MATLAB's plotting environment and mechanics in general are highly advanced and flexible, one still needs to write a lot of lines of code in order to enrich a plot. 

## Main idea

The way to use the function has the following general structure:

plot_in_my_style(...
    {x1, ..., xn},...
    {y1, ..., yn},...
    Figure_Title,...
    arg_type_1,...            % <----- optional argument of "type 1"
    arg_type_2, identifier)   % <----- optional argument of "type 2" and its identifier
  
### Explanation:

The user first provides the fixed arguments: 
1. A **cell** variable containing all x-axis signals.  
2. A **cell** variable containing all y-axis signals that correspond to the x-axis signals (couples of (x1,y1), ..., (xn,yn)).
3. A **string** variable that represents the title of the figure.

Then, the user can provide optional/variable arguments that must adhere to only a few rules:

Both types of optional arguments (**must be of type: string**) signal to the function to include additional plot properties. 

1. The first one ('arg_type_1') does not require an identifier receding it.
2. The second one ('arg_type_2') requires an identifier receding it.

This concept is not very different than how "plot" is already used in MATLAB, however it is made much more compact. All necessary commands of a plot are inserted in the function and are activated by a variable argument that is of much simpler expression.
For example, in order to plot two signals that have vastly different orders of magnitute, therefore needing to have two distinct y-axes, in MATLAB one would need to write:

% using "plot" function to graph two signals in separate y-axes 
yyaxis left
plot(xl, y_left)
yyaxis right
plot(xr, y_right)

whereas with the "plot in my style", one can write it much more easily and intuitively:

plot_in_my_style(...
    {xl, xr}, ...
    {y_left, y_right}, 'title', ...
    'sepY')
OR
plot_in_my_style(...
    {xl, xr}, ...
    {y_left, y_right}, 'title', ...
    'separate-Y')

## Customization capabilities

It is really easy to customize the function.
If, for example, one needs to frequently plot in "dark mode", which is better for the eyes during the evening, they would only need to add:

plot_in_my_style(...
    {xl, xr}, ...
    {y_left, y_right}, 'title', ...
    'separate-Y',...
    'dark')
instead of having to remember to write:

```set(gca,[0 0 0], 'GridColor', 'green')```

which is the proper built-in way

 plot_in_my_style(...
     X, Y, 'fig',...
     'leg',      {'signal_1', 'signal_2'}, ...
     'sepY',...
     'xLab',     {'t'},...
     'yLab',     {'v_1', 'v_2'},...
     'units',    {'s', 'm/s', 'm/s^2'},...
    'dark',...
     'black-white',...
    'exist-fig', 1);


## How to use it

Open MATLAB, add the functions provided in the repository to your path and type "help plot_in_my_style" in order to run some examples.

