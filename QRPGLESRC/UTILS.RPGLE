       //***********************************************************************
       // MIT License
       //
       // Copyright (c) 2017 Edoardo Luppi
       //
       // Permission is hereby granted, free of charge, to any person obtaining a copy
       // of this software and associated documentation files (the "Software"), to deal
       // in the Software without restriction, including without limitation the rights
       // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
       // copies of the Software, and to permit persons to whom the Software is
       // furnished to do so, subject to the following conditions:
       //
       // The above copyright notice and this permission notice shall be included in all
       // copies or substantial portions of the Software.
       //
       // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
       // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
       // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
       // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
       // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
       // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
       // SOFTWARE.
       //
       // @author Edoardo Luppi
       // @description Utility functions
       //***********************************************************************
       ctl-opt nomain option(*srcstmt);

       dcl-c UPPER 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
       dcl-c LOWER 'abcdefghijklmnopqrstuvwxyz';

       //***********************************************************************
       // toUppercase
       //***********************************************************************
       dcl-proc toUppercase export;

         dcl-pi *n varchar(32767);
           string varchar(32767) const;
         end-pi;

         return %xlate(LOWER:UPPER:string);

       end-proc;

       //***********************************************************************
       // toLowercase
       //***********************************************************************
       dcl-proc toLowercase export;

         dcl-pi *n varchar(32767);
           string varchar(32767) const;
         end-pi;

         return %xlate(UPPER:LOWER:string);

       end-proc;

       //***********************************************************************
       // allocSpace
       //***********************************************************************
       dcl-proc allocSpace export;

         dcl-pi *n;
           ptr pointer;
           bytes uns(10) const;
         end-pi;

         if (ptr = *null);
           ptr = %alloc(bytes);
         else;
           ptr = %realloc(ptr:bytes);
         endif;

       end-proc;

       //***********************************************************************
       // deallocSpace
       //***********************************************************************
       dcl-proc deallocSpace export;

         dcl-pi *n;
           ptr pointer;
         end-pi;

         if (ptr <> *null);
           dealloc(n) ptr;
         endif;

       end-proc;

