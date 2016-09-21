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
	
		//�޸�״̬
		
		return "�ύ�ɹ�";
	}
    
    public String submit(JBOTransaction tx) throws Exception{
		
    	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject boo = bom.keyLoadBusinessObject("jbo.al.DEFAULT_RECORD",this.serialNo);

		//�޸�״̬
		
		
		boo.setAttributeValue("ObjectNo", duebillSerialNo);
		boo.setAttributeValue("ObjectType", "jbo.app.BUSINESS_DUEBILL");
		boo.setAttributeValue("InputOrgID", orgID);
		boo.setAttributeValue("InputUserID", userID);
		boo.setAttributeValue("InputDate", DateHelper.getBusinessDate());
		
		bom.updateBusinessObject(boo);	
		bom.updateDB();		
		return "�ύ�ɹ�";
	}
    
    public String submitToApprove(JBOTransaction tx) throws Exception{
		
    	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject boo = bom.keyLoadBusinessObject("jbo.al.DEFAULT_RECORD",this.serialNo);

		//�޸�״̬
		
		
		boo.setAttributeValue("ApplyStatus", "1");
		boo.setAttributeValue("ApproveStatus", "0");
		
		bom.updateBusinessObject(boo);	
		bom.updateDB();		
		return "�ύ�����������ռ�ظ��˸ڸ��ˣ�";
	}
    
    public String backTask(JBOTransaction tx) throws Exception{
		
    	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject boo = bom.keyLoadBusinessObject("jbo.al.DEFAULT_RECORD",this.serialNo);

		//�޸�״̬
		
		
		boo.setAttributeValue("ApplyStatus", "0");
		
		bom.updateBusinessObject(boo);	
		bom.updateDB();		
		return "�ջسɹ�";
	}

    public String submitOpinion(JBOTransaction tx) throws Exception{
		
    	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject boo = bom.keyLoadBusinessObject("jbo.al.DEFAULT_RECORD",this.serialNo);

		//�޸�״̬
		
		
		boo.setAttributeValue("ApproveStatus", "1");
		
		bom.updateBusinessObject(boo);	
		bom.updateDB();		
		return "�ύ�ɹ�";
	}
    
    public String goBackApply(JBOTransaction tx) throws Exception{
		
    	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject boo = bom.keyLoadBusinessObject("jbo.al.DEFAULT_RECORD", this.serialNo);

		//�޸�״̬
		
		
		boo.setAttributeValue("ApplyStatus", "0");
		
		bom.updateBusinessObject(boo);	
		bom.updateDB();		
		return "�˻سɹ�";
	}

	
    public String delete(JBOTransaction tx) throws Exception{
		
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject bo = bom.keyLoadBusinessObject("jbo.al.DEFAULT_RECORD", this.serialNo);
		bom.deleteBusinessObject(bo);	
		bom.updateDB();		
		return "ɾ���ɹ���";
	}
    
    public String check(JBOTransaction tx) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.al.DEFAULT_RECORD");
		tx.join(bom);
		BizObjectQuery bq = bom.createQuery("SerialNo=:SerialNo");
		bq.setParameter("SerialNo", this.serialNo);

		BizObject cr = bq.getSingleResult(false);
		String reason = cr.getAttribute("REASON").getString();
		if("".equals(reason)||reason==null){
			return "���ȱ������ύ��";		
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
			return "���ȱ������ύ��";		
		}else{
			return "true";	
		}
	}
}
