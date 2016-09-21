package com.amarsoft.app.als.credit.putout.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;
/**
 * 
 * @author xjzhao
 * 功能：调用核心受益帐户绑定信息申请 E766
 * 
 */
public class SendAccountInfo {
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



	public String send(JBOTransaction tx) throws Exception{
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		
		BusinessObject bo = bomanager.keyLoadBusinessObject(this.objectType, this.objectNo);
		if(bo == null) return "未找到对应账户信息！";
		
		List<BusinessObject> accountList = bomanager.loadBusinessObjects("jbo.acct.ACCT_BUSINESS_ACCOUNT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status in('0','1') and AccountIndIcator=:AccountIndIcator ", "ObjectType",bo.getString("ObjectType"),"ObjectNo",bo.getString("ObjectNo"),"AccountIndIcator","07");
		if(accountList == null || accountList.isEmpty()) return "未取到受益方账户信息！";
		
		String duebillNo = "";
		
		if("jbo.app.BUSINESS_CONTRACT".equals(this.objectType))
		{
			duebillNo = bo.getString("ContractArtificialNo");
		}
		else if("jbo.acct.ACCT_TRANSACTION".equals(this.objectType))
		{
			duebillNo = bo.getString("RELATIVEOBJECTNO");
		}
		else
		{
			duebillNo = bo.getString("DuebillSerialNo");
		}
		
		
		ArrayList<Map<String,String>> array = new ArrayList<Map<String,String>>();
		
		for(BusinessObject account:accountList)
		{
			String payeeAcctNo = account.getString("AccountNo");
			//if(payeeAcctNo == null || "".equals(payeeAcctNo)) payeeAcctNo = account.getString("AccountNo");
			String accountType = account.getString("AccountType");
			
			String ownBankFlag = "";
			
			String acctType = "";
			Item item = CodeCache.getItem("AccountType", accountType);
			if(item != null) acctType = item.getAttribute3();
			
			if("5".equals(accountType)) //行外账户
			{
				ownBankFlag = "2";
			}
			else
			{
				ownBankFlag = "1";
			}
			
			
			String accountName = account.getString("AccountName");
			String bankID = account.getString("ACCOUNTBANKID");
			String bankName = account.getString("AccountBankName");
			String dstrAmt = account.getString("AccountAmt");
			
			Map<String,String> hashMap = new HashMap<String,String>();
			hashMap.put("PayeeAcctNo", payeeAcctNo);
			hashMap.put("OwnBankFlag", ownBankFlag);
			hashMap.put("AcctType", acctType);
			hashMap.put("PayeeName", accountName);
			hashMap.put("InstName", bankName);
			hashMap.put("ComphEstLevel", bankID);
			hashMap.put("DstrAmt", dstrAmt);
			hashMap.put("CurrencyId", "01");
			hashMap.put("CashRateFlag", "0");
			
			array.add(hashMap);
		}
		
			return "";
	}
}
