       //***********************************************************************
       // Prototype for the QDBRTVFD API.
       //
       // @link https://www.ibm.com/support/knowledgecenter/ssw_ibm_i_71/apis/qdbrtvfd.htm
       // @author Edoardo Luppi
       //***********************************************************************
       dcl-pr getDatabaseFileDescription extpgm('QDBRTVFD');
         receiver char(32767) options(*varsize);
         receiverLength int(10) const;
         qualifiedReturnedFileName char(20);
         formatName char(8) const;
         qualifiedFileName char(20) const;
         recordFormatName char(10) const;
         overrideProcessing char(1) const;
         system char(10) const;
         formatType char(10) const;
         apiError char(32767) options(*varsize);
       end-pr;

