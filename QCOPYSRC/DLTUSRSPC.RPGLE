       //***********************************************************************
       // Prototype for the QUSDLTUS API.
       //
       // @link https://www.ibm.com/support/knowledgecenter/ssw_ibm_i_71/apis/qusdltus.htm
       // @author Edoardo Luppi
       //***********************************************************************
       dcl-pr deleteUserSpace extpgm('QUSDLTUS');
         qualifiedUserSpaceName char(20) const;
         apiError char(32767) options(*varsize);
       end-pr;

