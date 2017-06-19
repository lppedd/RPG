       //***********************************************************************
       // Prototype for the QBNLSPGM API.
       //
       // @link https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_71/apis/qbnlspgm.htm
       // @author Edoardo Luppi
       //***********************************************************************
       dcl-pr listServiceProgramInformation extpgm('QBNLSPGM');
         qualifiedUserSpaceName char(20) const;
         formatName char(8) const;
         qualifiedServiceProgramName char(20) const;
         apiError char(32767) options(*varsize);
       end-pr;

