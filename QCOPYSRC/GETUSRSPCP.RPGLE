       //***********************************************************************
       // Prototype for the QUSPTRUS API.
       //
       // @link https://www.ibm.com/support/knowledgecenter/ssw_ibm_i_71/apis/qusptrus.htm
       // @author Edoardo Luppi
       //***********************************************************************
       dcl-pr getUserSpacePtr extpgm('QUSPTRUS');
         qualifiedUserSpaceName char(20) const;
         returnedPtr pointer;
         apiError char(32767) options(*nopass:*varsize);
       end-pr;

