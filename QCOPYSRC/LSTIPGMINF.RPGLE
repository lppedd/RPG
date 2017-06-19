       //***********************************************************************
       // Prototype for the QBNLPGMI API.
       //
       // @link https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_71/apis/qbnlpgmi.htm
       // @author Edoardo Luppi
       //***********************************************************************
       dcl-pr listIleProgramInformation extpgm('QBNLPGMI');
         qualifiedUserSpaceName char(20) const;
         formatName char(8) const;
         qualifiedIleProgramName char(20) const;
         apiError char(32767) options(*varsize);
       end-pr;

