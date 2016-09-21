package com.amarsoft.app.als.customer.action;
/**
 * @柳显涛
 * 合作方客户新增类
 */
import java.util.HashMap;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class CreateCustomerList{
	private JSONObject inputParameter;
	private HashMap<String , Object> data;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	public void setData(HashMap<String , Object> map){
		this.data = map;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	public String CreateCustomerAddList(BizObjectManager bm) throws Exception{
		String customerName = (String)data.get("CustomerName");
		String listType = (String)data.get("ListType");
		String certID = (String)data.get("CertID");
		String certType = (String)data.get("CertType");
		String customerID = (String)data.get("CustomerID");
		String inputOrgID = (String)data.get("InputOrgID");
		String inputUserID = (String)data.get("InputUserID");
		String inputDate = (String)data.get("InputDate");	
		String status = (String)data.get("Status");
		if(status==null) status = "2";
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CUSTOMERNAME", customerName);
		bo.setAttributeValue("LISTTYPE", listType);
		bo.setAttributeValue("CERTID", certID);
		bo.setAttributeValue("CERTTYPE", certType);
		bo.setAttributeValue("CUSTOMERID", customerID);
		bo.setAttributeValue("INPUTORGID", inputOrgID);
		bo.setAttributeValue("INPUTUSERID", inputUserID);
		bo.setAttributeValue("INPUTDATE", inputDate);
		bo.setAttributeValue("STATUS", status);
		bm.saveObject(bo);
		String listtype = bo.getAttribute("ListType").toString();
		return "true@"+listtype;
	}
}