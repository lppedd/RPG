       //***********************************************************************
       // Prototype for the QCLRPGMI API.
       //
       // @link https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_71/apis/qclrpgmi.htm
       // @author Edoardo Luppi
       //***********************************************************************
       dcl-pr getProgramInformation extpgm('QCLRPGMI');
         receiver char(32767) options(*varsize);
         receiverLength int(10) const;
         formatName char(8) const;
         qualifiedProgramName char(20) const;
         apiError char(32767) options(*varsize);
       end-pr;

