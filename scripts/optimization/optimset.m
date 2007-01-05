## Copyright (C) 2007 John W. Eaton
##
## This file is part of Octave.
##
## Octave is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2, or (at your option)
## any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, write to the Free
## Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
## 02110-1301, USA.

## -*- texinfo -*-
## @deftypefn {Function File} {} optimset ()
## @deftypefnx {Function File} {} optimset (@var{par}, @var{val}, @dots{})
## @deftypefnx {Function File} {} optimset (@var{old}, @var{par}, @var{val}, @dots{})
## @deftypefnx {Function File} {} optimset (@var{old}, @var{new})
## Create options struct for optimization functions.
## @end deftypefn

function retval = optimset (varargin)

  nargs = nargin ();

  ## Add more as needed.
  persistent opts = {
    "Display", "\"off\"|\"iter\"|{\"final\"}|\"notify\"";
    "FunValCheck", "{\"off\"}|\"on\"";
    "MaxFunEvals", "positive integer";
    "MaxIter", "positive integer";
    "OutputFun", "function|{[]}";
    "TolFun", "positive scalar";
    "TolX", "positive scalar"
  };

  if (nargs == 0)
    if (nargout == 0)
      ## Display possibilities.
      tmp = opts';
      disp (struct (tmp{:}));
    else
      ## Return structure with empty values.
      t1 = opts(:,1)';
      t2 = cell (size (t1));
      tmp = [t1; t2];
      retval = struct (tmp{:});
    endif
  elseif (nargs == 1 && ischar (varargin{1}))
    ## Return defaults for named function.
    fcn = varargin{1};
    optfcn = sprintf ("__%s_defopts__", fcn);
    if (exist (optfcn))
      retval = optimset (optimset (), feval (optfcn));
    else
      error ("no defaults for function `%s'", fcn);
    endif
  elseif (nargs == 2 && isstruct (varargin{1}) && isstruct (varargin{2}))
    ## Set slots in old from nonempties in new.  Should we be checking
    ## to ensure that the field names are expected?
    old = varargin{1};
    new = varargin{2};
    fnames = fieldnames (old);
    for [val, key] = new
      mask = strcmpi (fnames, key);
      if (any (mask))
	key = fnames (mask);
      endif
      old.(key) = val;
    endfor
    retval = old;
  elseif (rem (nargs, 2) && isstruct (varargin{1}))
    ## Set values in old from name/value pairs.
    retval = optimset (varargin{1}, struct (varargin{2:end}));
  elseif (rem (nargs, 2) == 0)
    ## Create struct.  Default values are replaced by those specified by
    ## name/value pairs.
    retval = optimset (optimset (), struct (varargin{:}));
  else
    print_usage ();
  endif

endfunction
