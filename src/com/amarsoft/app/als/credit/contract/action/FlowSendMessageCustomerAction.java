package com.amarsoft.app.als.credit.contract.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.credit.apply.action.SendMessageToCustomerAction;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.dict.als.manage.NameManager;

public class FlowSendMessageCustomerAction {
	private String messageID;
	private String objectType;
	private String objectNo;
	
	
	public String getMessageID() {
		return messageID;
	}


	public void setMessageID(String messageID) {
		this.messageID = messageID;
	}


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


	public String sendMessage(JBOTransaction tx) throws Exception{
		
		//查询flow对象
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		
		//查询流程对象信息
		BusinessObject flowobjectInfo = bom.keyLoadBusinessObject(this.objectType, this.objectNo);
		if(flowobjectInfo == null ) throw new Exception("未找到对应流程对象信息，请检查对象编号：{"+this.objectType+"}，对象类型：{"+this.objectNo+"},是否存在！");
		
		if("jbo.app.BUSINESS_APPLY".equals(this.objectType))
		{
			
			String customerID =flowobjectInfo.getString("CustomerID");
			//CI信息，jbo.customer.CUSTOMER_INFO
			BusinessObject customer = bom.keyLoadBusinessObject("jbo.customer.CUSTOMER_INFO", customerID);
			if(customer == null ) throw new Exception("未找到对应的客户信息，请检查客户编号为：{"+customerID+"}，客户信息是否存在！");
			
			//客户联系电话信息，jbo.customer.CUSTOMER_TEL
			List<BusinessObject>  indTelList = bom.loadBusinessObjects("jbo.customer.CUSTOMER_TEL", " customerID=:CustomerID and teltype='PB2004' and isnew='1' ","CustomerID", customerID);
			String phoneNo = "";
			for(BusinessObject idtbo : indTelList){
				String telphone = idtbo.getString("Telephone");
				if(telphone!=null&&telphone.length()>0)
					phoneNo = telphone;
			}
			flowobjectInfo.setAttributeValue("PhoneNo", phoneNo);//放置客户接收短信电话号码
			
			//客户电邮信息，jbo.customer.CUSTOMER_ECONTACT
			String mailAddress = "";
			List<BusinessObject>  eAddList = bom.loadBusinessObjects("jbo.customer.CUSTOMER_ECONTACT","customerID=:CustomerID and contacttype='01' ","CustomerID", customerID);
			for(BusinessObject emabo : eAddList){
				String emailAddress = emabo.getString("AccountNo");
				if(emailAddress!=null&&emailAddress.length()>0)
					mailAddress = emailAddress;
			}
			flowobjectInfo.setAttributeValue("MailAddress", mailAddress);//放置客户接收邮件email
			String businesstype = NameManager.getBusinessName(flowobjectInfo.getAttribute("BusinessType").toString());
			flowobjectInfo.setAttributeValue("BusinessTypeName", businesstype);
		}
		flowobjectInfo.setAttributeValue("MailFlag", "1");//是否发送邮件
		flowobjectInfo.setAttributeValue("MessFlag", "1");//是否发送短信
		
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
