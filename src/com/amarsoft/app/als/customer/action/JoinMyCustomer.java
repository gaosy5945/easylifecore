package com.amarsoft.app.als.customer.action;

/**
 * 加入我的客户新增逻辑类，使用双重for循环，依次将customerid插入到object_tag_library表中， 并在插入前做重复校验
 * @author 柳显涛
 *
 */

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class JoinMyCustomer {
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	public String JoinMyCustomer(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String serialNo = (String)inputParameter.getValue("SerialNo");
		String customerID = (String)inputParameter.getValue("CustomerID");
		String inputUserID = (String)inputParameter.getValue("InputUserID");
		String inputDate = (String)inputParameter.getValue("InputDate");
		String inputOrgID = (String)inputParameter.getValue("InputOrgID");
		String[] serialNoArray = serialNo.split("~");
		String[] customerIDArray = customerID.split("@");
		
		for(int j = 0; j < serialNoArray.length; j++){
			for(int i = 0; i < customerIDArray.length; i++){
				BizObjectManager table = JBOFactory.getBizObjectManager("jbo.app.OBJECT_TAG_LIBRARY");
				tx.join(table);
				
				BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and TagSerialNo=:TagSerialNo and ObjectType='jbo.customer.CUSTOMER_INFO'")
						.setParameter("ObjectNo", customerIDArray[i]).setParameter("TagSerialNo", serialNoArray[j].split("@")[0]);
				BizObject pr = q.getSingleResult(false);
				String  flag = "";
				if(pr!=null){flag = "1";}
				
				if("".equals(flag)){
					ImportToTag(serialNoArray[j].split("@")[0],serialNoArray[j].split("@")[1],customerIDArray[i],inputUserID,inputDate,inputOrgID);
				}
		}
				
	}
		return "SUCCEED";
	}
	
	public String ImportToTag(String serialNo,String tagID,String customerID,String inputUserID,String inputDate,String inputOrgID) throws Exception{

		this.businessObjectManager=this.getBusinessObjectManager();
		List<BusinessObject> checkList = this.businessObjectManager.loadBusinessObjects("jbo.app.OBJECT_TAG_LIBRARY", "ObjectType = 'jbo.customer.CUSTOMER_INFO' and tagSerialNo = :tagSerialNo and objectNo = :objectNo", "tagSerialNo",serialNo,"objectNo",customerID);
		if(checkList == null || checkList.isEmpty()){
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.OBJECT_TAG_LIBRARY");
			tx.join(bm);
			BizObject bo = bm.newObject();
			bo.setAttributeValue("TAGSERIALNO",serialNo);
			bo.setAttributeValue("OBJECTTYPE", "jbo.customer.CUSTOMER_INFO");
			bo.setAttributeValue("OBJECTNO", customerID);
			bo.setAttributeValue("INPUTUSERID", inputUserID);
			bo.setAttributeValue("INPUTDATE", inputDate);
			bo.setAttributeValue("INPUTORGID", inputOrgID);
			bo.setAttributeValue("TAGID", tagID);
			
			bm.saveObject(bo);
			return "SUCCEED";
		}else
			return "FAILED";
				
	}
	
	public String importCustomerToTag(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.OBJECT_TAG_LIBRARY");
		tx.join(bm);
		String CustomerIDs = (String)inputParameter.getValue("CustomerIDs");
		String OTCSerialNo = (String)inputParameter.getValue("OTCSerialNo");
		String InputUserID = (String)inputParameter.getValue("InputUserID");
		String InputOrgID = (String)inputParameter.getValue("InputOrgID");
		String InputDate = (String)inputParameter.getValue("InputDate");
		String[] customerIDArray = CustomerIDs.split("~");
		for(int i = 0; i < customerIDArray.length; i++){
			BizObject bo = bm.newObject();
			
			bo.setAttributeValue("TAGSERIALNO", OTCSerialNo);
			bo.setAttributeValue("OBJECTTYPE", "jbo.customer.CUSTOMER_INFO");
			bo.setAttributeValue("OBJECTNO", customerIDArray[i]);
			bo.setAttributeValue("INPUTDATE", InputDate);
			bo.setAttributeValue("INPUTUSERID", InputUserID);
			bo.setAttributeValue("INPUTORGID", InputOrgID);
			
			bm.saveObject(bo);
		}
		return "SUCCEED";
	}
	
}
