       //***********************************************************************
       // Funzioni di utilita' varia.
       //
       // @author Edoardo Luppi
       //***********************************************************************
       dcl-pr toUppercase varchar(32767) extproc('TOUPPERCASE');
         string varchar(32767) const;
       end-pr;

       dcl-pr toLowercase varchar(32767) extproc('TOLOWERCASE');
         string varchar(32767) const;
       end-pr;

       dcl-pr allocSpace extproc('ALLOCSPACE');
         ptr pointer;
         bytes uns(10) const;
       end-pr;

       dcl-pr deallocSpace extproc('DEALLOCSPACE');
         ptr pointer;
       end-pr;

