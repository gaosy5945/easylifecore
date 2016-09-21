	package com.amarsoft.app.lending.bizlets;


import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.dict.als.cache.CodeCache;

/**
 * 调用核心1504接口(根据卡号返回账号)
 * @author 张万亮
 */
public class CheckClientCHNName extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception {
		//账号类型、卡号
		
		String accountIndicator = (String)this.getAttribute("AccountIndicator");
		String CardNo = (String)this.getAttribute("AccountNo");
		String AcctType = (String)this.getAttribute("AccountType");
		String CallType = (String)this.getAttribute("CallType");
		String CustomerID = "";
		String ClientNo = "";
		String ClientAcctNo = "";
		String ClientName = "";
		String OpenBranchId = "";
		String AccountBankName = "";
		if("7".equals(AcctType) || "8".equals(AcctType))
		{
			//调用核心2572接口
			try{
				
				//OCITransaction oci = CoreInstance.CorpCrnClntNameQryByAcctNo("92261005", "2261", CardNo, "01", Sqlca.getConnection());
				//ClientName = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("ClientCHNName");
				
			}catch(Exception ex)
			{
				ex.printStackTrace();
				return "false@"+ex.getMessage();
			}
		}
		else if("0".equals(AcctType) || "1".equals(AcctType))
		{
			//调用核心1504接口
			try{
				AcctType = CodeCache.getItem("AccountType", AcctType).getAttribute1();
				String AcctChar = "";
				if("0005".equals(CallType)){
					AcctChar = "0005";
				}else{
					AcctChar = "0001";
				}
				/*
				OCITransaction oci = CoreInstance.CrnAcctBalQry("92261005", "2261", "1",AcctType,"","",CardNo,"01","0",1,10,AcctChar, Sqlca.getConnection());
				List<Message> message = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldByTag("CrnBalDtlInfo").getFieldArrayValue();
				ClientNo = message.get(0).getFieldValue("ClientNo");
				ClientAcctNo = message.get(0).getFieldValue("ClientAcctNo");
				ClientName = message.get(0).getFieldValue("ClientCHNName");
				OpenBranchId = message.get(0).getFieldValue("OpenBranchId");
				AccountBankName = Sqlca.getString(new SqlObject("select OrgName from ORG_INFO where OrgID=:OrgID").setParameter("OrgID", OpenBranchId));
				CustomerID = Sqlca.getString(new SqlObject("select CustomerID from CUSTOMER_INFO where MFCustomerID=:MFCustomerID").setParameter("MFCustomerID", ClientNo));
				if(CustomerID == null) CustomerID="";
				*/
			}catch(Exception ex)
			{
				ex.printStackTrace();
				return "false@"+ex.getMessage();
			}
		}
		return "true@"+ClientAcctNo+"@"+ClientName+"@"+CustomerID+"@"+ClientNo+"@"+OpenBranchId+"@"+AccountBankName;
	}
}
