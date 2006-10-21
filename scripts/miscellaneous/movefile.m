## Copyright (C) 2005 John W. Eaton
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
## @deftypefn {Function File} {[@var{status}, @var{msg}, @var{msgid}] =} movefile (@var{f1}, @var{f2})
## Move the file @var{f1} to the new name @var{f2}.  The name @var{f1}
## may contain globbing patterns.  If @var{f1} expands to multiple file
## names, @var{f2} must be a directory.
##
## If successful, @var{status} is 1, with @var{msg} and @var{msgid} empty\n\
## character strings.  Otherwise, @var{status} is 0, @var{msg} contains a\n\
## system-dependent error message, and @var{msgid} contains a unique\n\
## message identifier.\n\
## @seealso{glob}
## @end deftypefn

function [status, msg, msgid] = movefile (f1, f2, force)

  status = true;
  msg = "";
  msgid = "";

  if (nargin == 2 || nargin == 3)
    if (nargin == 3 && strcmp (force, "f"))
      cmd = "/bin/mv -f";
    else
      cmd = "/bin/mv";
    endif

    ## Allow cell input and protect the file name(s).
    if (iscellstr (f1))
      f1 = sprintf("\"%s\" ", f1{:});
    else
      f1 = sprintf("\"%s\" ", f1);
    endif

    [err, msg] = system (sprintf ("%s %s \"%s\"", cmd, f1, f2));
    if (err < 0)
      status = false;
      msgid = "movefile";
    endif
  else
    print_usage ();
  endif

###   status = true;
###   msg = "";
###   msgid = "movefile";
### 
###   if (nargin == 2)
### 
###     flist = glob (f1);
###     nfiles = numel (flist);
###     if (nfiles > 1)
###       [f2info, err, msg] = stat (f2);
###       if (err < 0)
### 	status = false;
###       else
### 	if (S_ISDIR (f2info.mode))
### 	  for i = 1:nfiles
### 	    [err, msg] = rename (flist{i}, f2);
### 	    if (err < 0)
### 	      status = false;
### 	      break;
### 	    endif
### 	  endfor
### 	else
### 	  status = false;
### 	  msg = "when moving multiple files, destination must be a directory";
### 	endif
###       endif
###     else
###       [err, msg] = rename (f1, f2);
###       if (err < 0)
### 	status = false;
### 	break;
###       endif
###     endif
### 
###   else
###     usage ("movefile (f1, f2)");
###   endif
### 
###   if (status)
###     msgid = "";
###   endif

endfunction
