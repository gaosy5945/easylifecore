package com.amarsoft.app.check.apply;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class InitProjectBailAccount {
    private String objectType;
    private String objectNo;
	public String getObjectType() {
		return objectType;
	}
	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}
	public String getObjectNo() {
		return objectNo;
	}
	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}
    
	/**
	 * 对于只有一个合作项目的申请，当支付方式选合作商时，自动反显合作商保证金账户信息
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String initAccount(Transaction Sqlca) throws Exception{
		   
		String AccountType = "",AccountNo = "",AccountName = "",AccountNo1 = "",CustomerID = "",MFCustomerID = "",INDIVIDUALPERCENT = "";
		//保证金信息
		String sSql = "select AccountType,AccountNo,AccountName from ACCT_BUSINESS_ACCOUNT AAI,CLR_MARGIN_INFO CMI  where "+
		  " AAI.ObjectType='jbo.guaranty.CLR_MARGIN_INFO' and AAI.ObjectNo = CMI.SerialNo and CMI.ObjectType='jbo.prj.PRJ_BASIC_INFO' and CMI.ObjectNo = :ProjectSerialNo ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ProjectSerialNo", objectNo));
		if(rs.next()){
			AccountType = DataConvert.toString(rs.getString("AccountType"));
			AccountNo = DataConvert.toString(rs.getString("AccountNo"));
			AccountName = DataConvert.toString(rs.getString("AccountName"));
		}
		rs.close();
	   
		return "true"+"@"+AccountType+"@"+AccountNo+"@"+AccountName+"@"+AccountNo1+"@"+CustomerID+"@"+MFCustomerID+"@"+INDIVIDUALPERCENT;
	}
}
