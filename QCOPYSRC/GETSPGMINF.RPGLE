       //***********************************************************************
       // Prototype for the QBNRSPGM API.
       //
       // @link https://www.ibm.com/support/knowledgecenter/ssw_ibm_i_71/apis/qbnrspgm.htm
       // @author Edoardo Luppi
       //***********************************************************************
       dcl-pr getServiceProgramInformation extpgm('QBNRSPGM');
         receiver char(32767) options(*varsize);
         receiverLength int(10) const;
         formatName char(8) const;
         qualifiedServiceProgramName char(20) const;
         apiError char(32767) options(*varsize);
       end-pr;

