       //***********************************************************************
       // Compara due aree di memoria, referenziate dai due puntatori in ingresso,
       // per il numero di byte specificato, e ritorna un valore < 0, > 0, o 0 se uguali.
       //
       // @link https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_71/rtref/memcmp.htm
       //***********************************************************************
       dcl-pr memcmp int(10) extproc('__memcmp');
         ptr1 pointer value;
         ptr2 pointer value;
         length uns(10) value;
       end-pr;

