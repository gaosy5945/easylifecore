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
					return "false@��������ʽ��Ѳ����޷������ʽ�תȷ�ϡ�";
				}
				
				
				ci.setAttributeValue("ORGID","9800"); //�ϼ�����
				ci.setAttributeValue("OCCURDATE",DateHelper.getBusinessDate()); //��������
				ci.setAttributeValue("suborgid",ob.getString("AccountingOrgID")); //�¼�����
				ci.setAttributeValue("direction","1"); //�������� �»�
				ci.setAttributeValue("amount",ob.getDouble("BusinessSum")); //�������
				ci.setAttributeValue("inputuserid",userID); //¼����
				ci.setAttributeValue("inputorgid",orgID); //¼�����
				ci.setAttributeValue("INPUTDATE",DateHelper.getBusinessDate()); //¼������
				ci.setAttributeValue("OBJECTTYPE",this.objectType); //��������
				ci.setAttributeValue("OBJECTNO",this.objectNo); //������
				
				ob.setAttributeValue("TransferStatus", "2");
				bomanager.updateBusinessObject(ob);
				bomanager.updateBusinessObject(ci);
				bomanager.updateDB();
				return "true@�ʽ𻮲�ȷ�ϳɹ���";
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return "false@�ʽ𻮲�ȷ��ʧ�ܡ�ԭ��"+e.getMessage()+"��";
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
