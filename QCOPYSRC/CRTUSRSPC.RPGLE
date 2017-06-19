       //***********************************************************************
       // Prototype for the QUSCRTUS API.
       //
       // @link https://www.ibm.com/support/knowledgecenter/ssw_ibm_i_71/apis/quscrtus.htm
       // @author Edoardo Luppi
       //***********************************************************************
       dcl-pr createUserSpace extpgm('QUSCRTUS');
         qualifiedUserSpaceName char(20) const;
         extendedAttribute char(10) const;
         initialSize int(10) const;
         initialValue char(1) const;
         publicAuthority char(10) const;
         textDescription char(50) const;
         replace char(10) const options(*nopass);
         apiError char(32767) options(*nopass:*varsize);
         domain char(10) const options(*nopass);
         transferSizeRequest int(10) const options(*nopass);
         optimumSpaceAlignment char(1) const options(*nopass);
       end-pr;

