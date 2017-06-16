       //***********************************************************************
       // Copia i bytes, definiti da length, dall'area di memoria puntata da
       // sourcePtr all'area di memoria puntata da targetPtr.
       //
       // @link https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_71/rtref/memcpy.htm
       //***********************************************************************
       dcl-pr memcpy extproc('__memcpy');
         targetPtr pointer value;
         sourcePtr pointer value;
         length uns(10) value;
       end-pr;

