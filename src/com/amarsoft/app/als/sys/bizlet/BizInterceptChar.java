package com.amarsoft.app.als.sys.bizlet;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class BizInterceptChar extends Bizlet{
   public Object run(Transaction arg0) throws Exception{
	   String sStr = (String)this.getAttribute("str");
	   String sChar = (String)this.getAttribute("char");
	   String sType = (String)this.getAttribute("type");

	   String[] sResult = sStr.split(sChar);

	   String sReturn = null;
	   if((sResult==null||"".equals(sResult))){
		   if("transaction".equals(sType))
			   sReturn = "/Accounting/js/transaction/transaction.js";
	   }else{
		   sReturn = sResult[0];
	   }
	   
	   return sReturn;
   }
}
