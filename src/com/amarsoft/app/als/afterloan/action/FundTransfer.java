package com.amarsoft.app.als.afterloan.action;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class FundTransfer {
	
	private String userID;
	private String orgID;
	private String objectNo;
	private String objectType;
	
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getOrgID() {
		return orgID;
	}
	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}
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
	
	public String fundFransfer(JBOTransaction tx) {
		
			try {
				BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
				
				BusinessObject ob = bomanager.keyLoadBusinessObject(objectType, objectNo);
				
				BusinessObject ci = BusinessObjectFactory.createBusinessObject("jbo.app.FUND_TRANSFER", true, bomanager);
				
				
				Transaction Sqlca = Transaction.createTransaction(tx);
				String month = DateHelper.getBusinessDate().substring(0,7);
				String lastMonthDate = DateHelper.getEndDateOfMonth(DateHelper.getRelativeDate(DateHelper.getBusinessDate(), DateHelper.TERM_UNIT_MONTH, -1));
				String orgID = "9800";
				double lastBalance = DataConvert.toDouble(Sqlca.getString(new SqlObject("select balance from FUND_USE where OrgID=:OrgID and OccurDate = :OccurDate").setParameter("OccurDate", lastMonthDate).setParameter("OrgID", orgID)));
				double btocAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where (OrgID=:OrgID or subOrgID=:OrgID) and OccurDate like :CurMonth and Direction=:Direction").setParameter("CurMonth", month+"%").setParameter("Direction", "4").setParameter("OrgID", orgID)));
				double ctobAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where (OrgID=:OrgID or subOrgID=:OrgID) and OccurDate like :CurMonth and Direction=:Direction").setParameter("CurMonth", month+"%").setParameter("Direction", "3").setParameter("OrgID", orgID)));
				double btosbAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where (OrgID=:OrgID or subOrgID=:OrgID) and OccurDate like :CurMonth and Direction=:Direction").setParameter("CurMonth", month+"%").setParameter("Direction", "1").setParameter("OrgID", orgID)));
				double sbtobAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where (OrgID=:OrgID or subOrgID=:OrgID) and OccurDate like :CurMonth and Direction=:Direction").setParameter("CurMonth", month+"%").setParameter("Direction", "2").setParameter("OrgID", orgID)));

				double balance = lastBalance - btocAmt+ctobAmt-btosbAmt+sbtobAmt;

				
				if(balance < ob.getDouble("BusinessSum"))
				{
					return "false@基金可用资金已不足额，无法进行资金划转确认。";
				}
				
				
				ci.setAttributeValue("ORGID","9800"); //上级机构
				ci.setAttributeValue("OCCURDATE",DateHelper.getBusinessDate()); //发生日期
				ci.setAttributeValue("suborgid",ob.getString("AccountingOrgID")); //下级机构
				ci.setAttributeValue("direction","1"); //发生方向 下划
				ci.setAttributeValue("amount",ob.getDouble("BusinessSum")); //发生金额
				ci.setAttributeValue("inputuserid",userID); //录入人
				ci.setAttributeValue("inputorgid",orgID); //录入机构
				ci.setAttributeValue("INPUTDATE",DateHelper.getBusinessDate()); //录入日期
				ci.setAttributeValue("OBJECTTYPE",this.objectType); //对象类型
				ci.setAttributeValue("OBJECTNO",this.objectNo); //对象编号
				
				ob.setAttributeValue("TransferStatus", "2");
				bomanager.updateBusinessObject(ob);
				bomanager.updateBusinessObject(ci);
				bomanager.updateDB();
				return "true@资金划拨确认成功。";
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return "false@资金划拨确认失败。原因【"+e.getMessage()+"】";
			}		
	}
	
	public String updateStatus(JBOTransaction tx){
		try
		{
			BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
			
			BusinessObject ob = bomanager.keyLoadBusinessObject(objectType, objectNo);
			String transferStatus = ob.getString("TransferStatus");
			if("2".equals(transferStatus))
			{
				ob.setAttributeValue("TransferStatus", "3");
			}
			else
			{
				ob.setAttributeValue("TransferStatus", "1");
			}
			
			bomanager.updateBusinessObject(ob);
			bomanager.updateDB();
			return "true";
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			return "false";
		}
	}
}
