package com.amarsoft.app.als.afterloan.action;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class BreakContractConfirm {
	
	private String serialNo; 
	private String userID;
	private String orgID;
	private String duebillSerialNo;
	
	
	
    public String getSerialNo() {
		return serialNo;
	}



	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}



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
	

    public String getDuebillSerialNo() {
		return duebillSerialNo;
	}


	public void setDuebillSerialNo(String duebillSerialNo) {
		this.duebillSerialNo = duebillSerialNo;
	}



    public String create(JBOTransaction tx) throws Exception{
		
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject bo = bom.keyLoadBusinessObject("jbo.app.BUSINESS_DUEBILL",this.duebillSerialNo);
		
		BusinessObject boo = BusinessObject.createBusinessObject("jbo.al.DEFAULT_RECORD");

		boo.setAttributeValue("ApplyStatus", "0");
		boo.setAttributeValue("ObjectNo", duebillSerialNo);
		boo.setAttributeValue("ObjectType", "jbo.app.BUSINESS_DUEBILL");
		boo.setAttributeValue("InputOrgID", orgID);
		boo.setAttributeValue("InputUserID", userID);
		boo.setAttributeValue("InputDate", DateHelper.getBusinessDate());
		
		bom.updateBusinessObject(boo);	
		bom.updateDB();		
		return  boo.getString("SerialNo");
	}
    
    public String submitToApply(JBOTransaction tx) throws Exception{
		
    	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject boo = bom.keyLoadBusinessObject("jbo.al.DEFAULT_RECORD",this.serialNo);
	
		//修改状态
		
		return "提交成功";
	}
    
    public String submit(JBOTransaction tx) throws Exception{
		
    	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject boo = bom.keyLoadBusinessObject("jbo.al.DEFAULT_RECORD",this.serialNo);

		//修改状态
		
		
		boo.setAttributeValue("ObjectNo", duebillSerialNo);
		boo.setAttributeValue("ObjectType", "jbo.app.BUSINESS_DUEBILL");
		boo.setAttributeValue("InputOrgID", orgID);
		boo.setAttributeValue("InputUserID", userID);
		boo.setAttributeValue("InputDate", DateHelper.getBusinessDate());
		
		bom.updateBusinessObject(boo);	
		bom.updateDB();		
		return "提交成功";
	}
    
    public String submitToApprove(JBOTransaction tx) throws Exception{
		
    	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject boo = bom.keyLoadBusinessObject("jbo.al.DEFAULT_RECORD",this.serialNo);

		//修改状态
		
		
		boo.setAttributeValue("ApplyStatus", "1");
		boo.setAttributeValue("ApproveStatus", "0");
		
		bom.updateBusinessObject(boo);	
		bom.updateDB();		
		return "提交至本机构风险监控复核岗复核！";
	}
    
    public String backTask(JBOTransaction tx) throws Exception{
		
    	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject boo = bom.keyLoadBusinessObject("jbo.al.DEFAULT_RECORD",this.serialNo);

		//修改状态
		
		
		boo.setAttributeValue("ApplyStatus", "0");
		
		bom.updateBusinessObject(boo);	
		bom.updateDB();		
		return "收回成功";
	}

    public String submitOpinion(JBOTransaction tx) throws Exception{
		
    	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject boo = bom.keyLoadBusinessObject("jbo.al.DEFAULT_RECORD",this.serialNo);

		//修改状态
		
		
		boo.setAttributeValue("ApproveStatus", "1");
		
		bom.updateBusinessObject(boo);	
		bom.updateDB();		
		return "提交成功";
	}
    
    public String goBackApply(JBOTransaction tx) throws Exception{
		
    	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject boo = bom.keyLoadBusinessObject("jbo.al.DEFAULT_RECORD", this.serialNo);

		//修改状态
		
		
		boo.setAttributeValue("ApplyStatus", "0");
		
		bom.updateBusinessObject(boo);	
		bom.updateDB();		
		return "退回成功";
	}

	
    public String delete(JBOTransaction tx) throws Exception{
		
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject bo = bom.keyLoadBusinessObject("jbo.al.DEFAULT_RECORD", this.serialNo);
		bom.deleteBusinessObject(bo);	
		bom.updateDB();		
		return "删除成功！";
	}
    
    public String check(JBOTransaction tx) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.al.DEFAULT_RECORD");
		tx.join(bom);
		BizObjectQuery bq = bom.createQuery("SerialNo=:SerialNo");
		bq.setParameter("SerialNo", this.serialNo);

		BizObject cr = bq.getSingleResult(false);
		String reason = cr.getAttribute("REASON").getString();
		if("".equals(reason)||reason==null){
			return "请先保存再提交！";		
		}else{
			return "true";	
		}
	}
    
    public String checkOpinion(JBOTransaction tx) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.al.DEFAULT_RECORD");
		tx.join(bom);
		BizObjectQuery bq = bom.createQuery("SerialNo=:SerialNo");
		bq.setParameter("SerialNo", this.serialNo);

		BizObject cr = bq.getSingleResult(false);
		String approveopinion = cr.getAttribute("APPROVEOPINION").getString();
		if("".equals(approveopinion)||approveopinion==null){
			return "请先保存再提交！";		
		}else{
			return "true";	
		}
	}
}
