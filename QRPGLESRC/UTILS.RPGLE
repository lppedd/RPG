       //***********************************************************************
       // Funzioni di utilita' varia.
       //
       // @author Edoardo Luppi
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

