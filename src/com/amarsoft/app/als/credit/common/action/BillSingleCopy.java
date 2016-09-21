package com.amarsoft.app.als.credit.common.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;

/**
 * 单个BILL_INFO 表数据复制，BILLNO 字段清空
 * @author xjzhao
 * 2011/11/20
 */
public class BillSingleCopy {
	private String SerialNo;//BILL_INFO.SerialNo
	private String UserID; //BILL_INFO.InputUserID
	private String OrgID; //BILL_INFO.InputOrgID
	private String ObjectNo;
	private String ObjectType;
	
	
	public void copy() throws Exception
    {
    	//根据票面金额更新申请金额
    	try
    	{
			BizObjectManager bm = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BILL_INFO");
	    	BizObjectQuery bq=bm.createQuery("SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType");
			bq.setParameter("SerialNo",this.SerialNo);
			bq.setParameter("ObjectNo",this.ObjectNo);
			bq.setParameter("ObjectType",this.ObjectType);
			BizObject bo = bq.getSingleResult(false);
			if(bo != null) 
			{
				BizObject boNew = bm.newObject();
				boNew.setAttributesValue(bo);
				boNew.setAttributeValue("SerialNo", null);
				boNew.setAttributeValue("BillNo", null);
				boNew.setAttributeValue("InputOrgID", this.OrgID);
				boNew.setAttributeValue("InputUserID", this.UserID);
				boNew.setAttributeValue("InputDate", DateX.format(new java.util.Date(),"yyyy/MM/dd"));
				boNew.setAttributeValue("UpdateDate", DateX.format(new java.util.Date(),"yyyy/MM/dd"));
				bm.saveObject(boNew);
			}
    	}catch(Exception ex)
    	{
    		ex.printStackTrace();
    		throw ex;
    	}
    }


	public String getOrgID() {
		return OrgID;
	}


	public void setOrgID(String orgID) {
		OrgID = orgID;
	}


	public String getSerialNo() {
		return SerialNo;
	}


	public void setSerialNo(String serialNo) {
		SerialNo = serialNo;
	}


	public String getUserID() {
		return UserID;
	}


	public void setUserID(String userID) {
		UserID = userID;
	}


	public String getObjectNo() {
		return ObjectNo;
	}


	public void setObjectNo(String objectNo) {
		ObjectNo = objectNo;
	}


	public String getObjectType() {
		return ObjectType;
	}


	public void setObjectType(String objectType) {
		ObjectType = objectType;
	}
}
