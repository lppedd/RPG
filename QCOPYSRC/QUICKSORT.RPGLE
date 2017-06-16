       //***********************************************************************
       // Algoritmo di ordinamento quicksort.
       //
       // @link https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_71/rtref/qsort.htm
       //***********************************************************************
       dcl-pr quickSort extproc('qsort');
         arrayPtr pointer value;
         arraySize uns(10) value;
         elementSize uns(10) value;
         compareProcedure pointer(*proc) value;
       end-pr;

