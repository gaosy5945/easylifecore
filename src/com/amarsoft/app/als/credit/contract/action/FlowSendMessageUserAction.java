package com.amarsoft.app.als.credit.contract.action;


import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.credit.apply.action.SendMessageToCustomerAction;
import com.amarsoft.app.als.sys.tools.SYSNameManager;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.dict.als.manage.NameManager;

public class FlowSendMessageUserAction {
	private String messageID;
	private String objectNo;
	private String objectType;
	private String userID;
	
	
	public String getMessageID() {
		return messageID;
	}


	public void setMessageID(String messageID) {
		this.messageID = messageID;
	}
	

	public String getUserID() {
		return userID;
	}


	public void setUserID(String userID) {
		this.userID = userID;
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


	public String sendMessage(JBOTransaction tx) throws Exception{
		
		//查询flow对象
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		
		//查询流程对象信息
		BusinessObject flowobjectInfo = bom.keyLoadBusinessObject(this.objectType, this.objectNo);
		if(flowobjectInfo == null ) throw new Exception("未找到对应流程对象信息，请检查对象编号：{"+this.objectType+"}，对象类型：{"+this.objectNo+"},是否存在！");
		
			
		BusinessObject user = bom.keyLoadBusinessObject("jbo.sys.USER_INFO", this.userID);
		
		flowobjectInfo.setAttributeValue("PhoneNo", user.getString("MOBILETEL"));//放置用户接收短信电话号码
		flowobjectInfo.setAttributeValue("MailAddress", user.getString("EMAIL"));//放置用户接收邮件email
		String businesstype = SYSNameManager.getProductName(flowobjectInfo.getAttribute("BusinessType").toString());
		flowobjectInfo.setAttributeValue("BusinessTypeName", businesstype);
		flowobjectInfo.setAttributeValue("MailFlag", user.getString("ATTRIBUTE7"));//是否发送邮件
		flowobjectInfo.setAttributeValue("MessFlag", user.getString("ATTRIBUTE8"));//是否发送短信
		String result="";
		
		try{
			SendMessageToCustomerAction stc = new SendMessageToCustomerAction();
			stc.setBusinessObject(flowobjectInfo);
			stc.setMessageID(messageID);
			result = stc.sendMessage(tx);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		
		return result;
	}

}
