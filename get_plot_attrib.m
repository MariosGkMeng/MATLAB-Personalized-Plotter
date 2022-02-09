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