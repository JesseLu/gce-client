function code = my_replace (code, varargin)

code = sprintf(code);
for k = 2 : 2 : length(varargin)
    if (isnumeric(varargin{k}))
        code = strrep(code, varargin{k-1}, num2str(varargin{k}));
    else
        code = strrep(code, varargin{k-1}, varargin{k});
    end

end
