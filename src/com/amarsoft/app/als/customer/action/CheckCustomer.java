package com.amarsoft.app.als.customer.action;

/**
 * 1、客户新增时，对证件编号进行重复校验
 * 2、校验成功后，进行相应表的新增操作。
 * 说明：合作方客户新增时，首先向CUSTOMER_INFO表中新增，获得CI的流水号后，将此流水号赋给ENT_INFO的CustomerID，并做该表的新增操作；
 *    然后将CI的流水号返回，并将返回的流水号放进map中，CUSTOMER_LIST表则获得此流水号，并进行新增操作
 * @author 柳显涛
 *
 */

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.dict.als.manage.NameManager;

public class CheckCustomer{
	
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
	
	public String CheckCustomer(JBOTransaction tx) throws Exception{
		this.tx = tx;
		
		String certIDTemp = (String)inputParameter.getValue("CertID");
		String certID = certIDTemp.replace(" ", "");
		String customerType = (String)inputParameter.getValue("CustomerType");
		String certType = (String)inputParameter.getValue("CertType");
		String inputUserID = (String)inputParameter.getValue("InputUserID");
		String inputOrgID = (String)inputParameter.getValue("InputOrgID");
		String customerTypeName=NameManager.getItemName("CustomerType", customerType);
		
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> list = bomanager.loadBusinessObjects("jbo.customer.CUSTOMER_INFO", " certID=:certID and certType=:certType", "certID",certID,"certType",certType);
		
		if(list==null || list.size() == 0){
			return "true";
		}else{
			String customerid = list.get(0).getString("CustomerID");
			List<BusinessObject> listCB = bomanager.loadBusinessObjects("jbo.customer.CUSTOMER_BELONG", " CustomerID=:CustomerID and OrgID=:OrgID and UserID=:UserID", "CustomerID", customerid,"OrgID", inputOrgID,"OrgID", inputOrgID,"OrgID", inputOrgID,"UserID", inputUserID);
			if(listCB == null || listCB.size() == 0){
				return "CBEmpty@"+customerid+"@"+customerTypeName+"@"+customerType;
			}
			return "false@"+customerTypeName+"@"+customerid;
		}
	}

	public String CheckCustomerListAndInfo(JBOTransaction tx) throws Exception{
		this.tx = tx;
		
		String certType = (String)inputParameter.getValue("CertType");
		String certID = (String)inputParameter.getValue("CertID");	
		String customerName = (String)inputParameter.getValue("CustomerName");
		String listType = (String)inputParameter.getValue("ListType");
		String countryCode = (String)inputParameter.getValue("CountryCode");
		String inputOrgID = (String)inputParameter.getValue("InputOrgID");
		String inputUserID = (String)inputParameter.getValue("InputUserID");
		String inputDate= (String)inputParameter.getValue("InputDate");
		String listTypeName=NameManager.getItemName("CustomerListType", listType);
		
		
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> customerListCheck = bomanager.loadBusinessObjects("jbo.customer.CUSTOMER_LIST", "CertType=:CertType and CertID=:CertID and ListType like '00%'", "CustomerName", customerName,"CertType", certType,"CertID", certID);
		List<BusinessObject> customerInfoCheck = bomanager.loadBusinessObjects("jbo.customer.CUSTOMER_INFO", "CertType=:CertType and CertID=:CertID", "CustomerName", customerName,"CertType", certType,"CertID", certID);
		if((customerListCheck == null || customerListCheck.size() == 0) && (customerInfoCheck == null || customerInfoCheck.size() == 0)){
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_LIST");
			CreateCInfoAndEInfo aa = new CreateCInfoAndEInfo();
			CreateCustomerList bb = new CreateCustomerList();
			HashMap<String,Object> map = new HashMap<String,Object>();
			map.put("CertID", certID);
			map.put("CertType", certType);
			map.put("CustomerName", customerName);
			map.put("ListType", listType);
			map.put("CountryCode", countryCode);
			map.put("InputOrgID", inputOrgID);
			map.put("InputUserID", inputUserID);
			map.put("InputDate", inputDate);
			
			aa.setData(map);
			String ccai = aa.CreateCustomerAddInfo(tx);
			String[] tempCcai = ccai.split("@");
			String customerid = tempCcai[1];
			String CustomerName = tempCcai[2];
			
			map.put("CustomerID", customerid);
			bb.setData(map);
			String ccal = bb.CreateCustomerAddList(bm);			
			String[] tempCcal = ccal.split("@");
			String listtype = tempCcal[1];
			
			CreateCustomerInfo createCB = new CreateCustomerInfo();
			String resultBelong = createCB.SelectCustomerBelong(customerid, inputOrgID, inputUserID, inputDate,tx);
			
			return "true@"+customerid+"@"+CustomerName+"@"+listtype;
		}else if((customerInfoCheck != null || customerInfoCheck.size() != 0 || !(customerInfoCheck.isEmpty()))&&(customerListCheck == null || customerListCheck.size() == 0)){
			String CustomerID = customerInfoCheck.get(0).getString("CUSTOMERID");
			
			BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
			tx.join(table);

			BizObjectQuery q = table.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", CustomerID);
			BizObject pr = q.getSingleResult(false);
			String  CustomerNameOld = "";
			if(pr!=null)
			{
				CustomerNameOld = pr.getAttribute("CustomerName").getString();
			}
			String result = ImportCustomerList(CustomerID,certType,certID,CustomerNameOld,listType,countryCode,inputOrgID,inputUserID,inputDate);
			
			String[] tempResult = result.split("@");
			String customerid = tempResult[0];
			String customername = tempResult[1];
			String listtype = tempResult[2];
			
			return "Import@"+customerid+"@"+customername+"@"+listtype;
		}else if((customerInfoCheck != null || customerInfoCheck.size() != 0 || !(customerInfoCheck.isEmpty()))&&(customerListCheck != null || customerListCheck.size() != 0)){
			String CustomerID = customerListCheck.get(0).getString("CUSTOMERID");
			String CustomerName = customerListCheck.get(0).getString("CUSTOMERNAME");
			String listtype = customerListCheck.get(0).getString("LISTTYPE");
			
			CreateCustomerInfo createCB = new CreateCustomerInfo();
			String resultBelong = createCB.SelectCustomerBelong(CustomerID, inputOrgID, inputUserID, inputDate,tx);
			if(resultBelong == "false"){
				return "false@"+listType;
			}else{
					return "Import@"+CustomerID+"@"+CustomerName+"@"+listtype;
			}
		}else{
			return "false@"+listType;
		}
	}

	public String ImportCustomerList(String CustomerID,String certType,String certID,String customerName,String listType,String countryCode,String inputOrgID,String inputUserID,String inputDate) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_LIST");
		tx.join(bm);
		
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CUSTOMERID", CustomerID);
		bo.setAttributeValue("CUSTOMERNAME", customerName);
		bo.setAttributeValue("CERTID", certID);
		bo.setAttributeValue("CERTTYPE", certType);
		bo.setAttributeValue("LISTTYPE", listType);
		bo.setAttributeValue("COUNTRYCODE", countryCode);
		bo.setAttributeValue("INPUTORGID", inputOrgID);
		bo.setAttributeValue("INPUTUSERID", inputUserID);
		bo.setAttributeValue("INPUTDATE", inputDate);
		
		bm.saveObject(bo);
		String customerid = bo.getAttribute("CustomerID").toString();
		String CustomerName = bo.getAttribute("CustomerName").toString();		
		String ListType = bo.getAttribute("listType").toString();
		
		return customerid+"@"+CustomerName+"@"+ListType;
	}
	
	
	

}