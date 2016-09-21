package com.amarsoft.app.check.apply;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class SelectAcctSum {
    private String objectNo;
    private String objectType;
    
	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String selectAcctSum(Transaction Sqlca) throws Exception{
		String sum = Sqlca.getString(new SqlObject("select count(*) from ACCT_BUSINESS_ACCOUNT where ObjectNo = :ObjectNo and ObjectType = :ObjectType and AccountIndicator = '07'").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType));
	    String max = Sqlca.getString(new SqlObject("select ATTRIBUTE1 from CODE_LIBRARY where CodeNo = 'FlowMaxAccount' and ItemNo = '1'"));
		if(sum == null) sum = "0";
		if(max == null) max = "0";
		int Sum = Integer.parseInt(sum);
		int Max = Integer.parseInt(max);
		if(Sum >= Max){
			return "false";
		}
		return "true";
	}
}
