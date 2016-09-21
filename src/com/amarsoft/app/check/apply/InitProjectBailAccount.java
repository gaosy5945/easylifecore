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
	 * ����ֻ��һ��������Ŀ�����룬��֧����ʽѡ������ʱ���Զ����Ժ����̱�֤���˻���Ϣ
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String initAccount(Transaction Sqlca) throws Exception{
		   
		String AccountType = "",AccountNo = "",AccountName = "",AccountNo1 = "",CustomerID = "",MFCustomerID = "",INDIVIDUALPERCENT = "";
		//��֤����Ϣ
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
