function [code] = my_import(filename, varargin)
% Imports code from a text file, replaces terms as necessary.

fid = fopen(filename, 'r');
code = fread(fid, 'uint8=>char');
code = sprintf('%s', code);
fclose(fid);

for k = 2 : 2 : length(varargin)
    if (isnumeric(varargin{k}))
        code = strrep(code, varargin{k-1}, num2str(varargin{k}));
    else
        code = strrep(code, varargin{k-1}, varargin{k});
    end

end

% fprintf('%s', code); % Use this to debug.
