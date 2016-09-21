package com.amarsoft.app.contentmanage.action;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdateType extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		String sSerialNo = (String)this.getAttribute("SerialNo");
		String sTypeNo = (String)this.getAttribute("TypeNo");
		if(sSerialNo == null) sSerialNo = "";
		if(sTypeNo == null) sTypeNo = "";
		int iCount = 0;
		String sReturn = "";
		
		String [] serialNo= sSerialNo.split("\\|");
		for(int i = 0;i<serialNo.length;i++){
			iCount += Sqlca.executeSQL("update ECM_PAGE set typeno = '"+sTypeNo+"' where SerialNo = '"+serialNo[i]+"'");
		}
		
		if(iCount > 0){
			sReturn = "Sesses";
		}else{
			sReturn = "Error";
		}
		return sReturn;
	}

}
