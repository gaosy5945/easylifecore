package com.amarsoft.app.als.customer.action;

/**
 * 1、零售商客户新增时，对证件编号进行重复校验
 * 2、校验成功后，进行相应表的新增操作。
 * 说明：合作方客户新增时，首先向CUSTOMER_INFO表中新增，获得CI的流水号后，将此流水号赋给ENT_INFO的CustomerID，并做该表的新增操作；
 *    然后将CI的流水号返回，并将返回的流水号放进map中，CUSTOMER_LIST表则获得此流水号，并进行新增操作
 * @author ckxu
 *
 */

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.amarsoft.amarscript.Any;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.AmarScriptHelper;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.dict.als.manage.NameManager;

public class AddAndCheckMarketCustomer{

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
	
	public String checkCustomer(JBOTransaction tx) throws Exception{
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

	public String checkCustomerListAndInfo(JBOTransaction tx) throws Exception{
		this.tx = tx;
		BusinessObject apply = BusinessObject.createBusinessObject();
		String applyType = (String)inputParameter.getValue("ApplyType");
		if(applyType==null) applyType = "ApplyType10";
		apply.setAttributeValue("ApplyType", applyType);
		String certType = (String)inputParameter.getValue("CertType");
		if(certType==null) certType = "";
		apply.setAttributeValue("CertType", certType);
		String certID = (String)inputParameter.getValue("CertID");	
		if(certID==null) certID = "";
		apply.setAttributeValue("CertID", certID);
		String customerName = (String)inputParameter.getValue("CustomerName");
		if(customerName==null) customerName = "";
		apply.setAttributeValue("CustomerName", customerName);
		
		String listType = (String)inputParameter.getValue("ListType");
		if(listType==null) listType = "";
		apply.setAttributeValue("ListType", listType);
		
		String countryCode = (String)inputParameter.getValue("CountryCode");
		if(countryCode==null) countryCode = "";
		apply.setAttributeValue("CountryCode", countryCode);
		
		
		String inputOrgID = (String)inputParameter.getValue("InputOrgID");
		if(inputOrgID==null) inputOrgID = "";
		apply.setAttributeValue("InputOrgID", inputOrgID);
		
		String inputUserID = (String)inputParameter.getValue("InputUserID");
		if(inputUserID==null) inputUserID = "";
		apply.setAttributeValue("InputUserID", inputUserID);
		
		String inputDate= (String)inputParameter.getValue("InputDate");
		if(inputDate==null) inputDate = "";
		apply.setAttributeValue("InputDate", inputDate);
		
		String status= (String)inputParameter.getValue("Status");
		if(status==null) status = "";
		apply.setAttributeValue("Status", status);
		String customerID = null;
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> customerListCheck = bomanager.loadBusinessObjects("jbo.customer.CUSTOMER_LIST", "CertType=:CertType and CertID=:CertID and ListType =:listType", "CustomerName", customerName,"CertType", certType,"CertID", certID,"listType",listType);
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
			map.put("Status", status);
			aa.setData(map);
			String ccai = aa.CreateCustomerAddInfo(tx);
			String[] tempCcai = ccai.split("@");
			customerID = tempCcai[1];
			
			map.put("CustomerID", customerID);
			bb.setData(map);
			String ccal = bb.CreateCustomerAddList(bm);			
			String[] tempCcal = ccal.split("@");
			String listtype = tempCcal[1];
			CreateCustomerInfo createCB = new CreateCustomerInfo();//创建客户权限
			String resultBelong = createCB.SelectCustomerBelong(customerID, inputOrgID, inputUserID, inputDate,tx);
			
		}else{
			//如果该客户已经存在，那么就直接进行引入操作,首先判断是否拥有该客户的权限，如果没有该客户的管理权限，那么就发挥失败，没有权限操作，
			customerID = customerInfoCheck.get(0).getKeyString();
			//判断权限
			List<BusinessObject> listBelong = bomanager.loadBusinessObjects("jbo.customer.CUSTOMER_BELONG", "CustomerID=:CustomerID and OrgID=:OrgID and UserID=:UserID", "CustomerID", customerID,"OrgID", inputOrgID,"UserID", inputUserID);
			List<BusinessObject> listOthers = bomanager.loadBusinessObjects("jbo.customer.CUSTOMER_BELONG", "CustomerID=:CustomerID and BELONGATTRIBUTE = 1", "CustomerID",customerID);
			//不用有权限返回false，没有权限
			if(listBelong==null||listBelong.isEmpty()){
			}else{
				if(listOthers==null||listOthers.isEmpty()){
					return "false@"+inputParameter.getValue("CertID")+"@"+inputParameter.getValue("CertID")+"@没有该客户的权限";
				}else
				{
					List<BusinessObject> list = bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", "objectType='jbo.customer.CUSTOMER_INFO' and objectNo=:CustomerID and flowNo='MarketCustomerFlow'", "CustomerID",customerID);
					if(!(list==null||list.size()<1)){
						return "false@"+inputParameter.getValue("CertID")+"@"+inputParameter.getValue("CertID")+"@该客户正在申请中";
					}
				}
			}
		}
		//初始化流程信息
		String flowNo="MarketCustomerFlow";
		String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
		BusinessObjectManager bomFlow = BusinessObjectManager.createBusinessObjectManager(tx);
		FlowManager fm = FlowManager.getFlowManager(bomFlow);
		List<BusinessObject> bos = bomFlow.loadBusinessObjects("jbo.customer.CUSTOMER_INFO", "customerID = :customerID", "customerID",customerID);
		apply.setAttributeValue("customerID",customerID);
		String result = fm.createInstance("jbo.customer.CUSTOMER_INFO", bos, flowNo, inputUserID, inputOrgID, apply);
		if(result.startsWith("false")) return result;
		if(StringX.isEmpty(result)) return "false";
		//流程是否启动不影响整个数据处理
		String instanceID = result.split("@")[0];
		String phaseNo = result.split("@")[1];
		String taskSerialNo = result.split("@")[2];
		
		//functionID 处理
		String functionID = FlowConfig.getFlowPhase(flowNo, flowVersion, phaseNo).getString("FunctionID");
		if(functionID != null && !"".equals(functionID) && (functionID.indexOf("'") >-1 || functionID.indexOf("\"") > -1 || functionID.indexOf("(") > -1))
		{
			BusinessObjectManager bommanager = BusinessObjectManager.createBusinessObjectManager(tx);
			BusinessObject boo = bommanager.keyLoadBusinessObject("jbo.customer.CUSTOMER_INFO", customerID);
			functionID = StringHelper.replaceString(functionID,boo);
			functionID = StringHelper.replaceToSpace(functionID);
			Any a=AmarScriptHelper.getScriptValue(functionID, BusinessObjectManager.createBusinessObjectManager(tx));
			functionID = a.toStringValue();
		}
		return "true@"+customerID +"@"+customerID+"@"+functionID+"@"+instanceID+"@"+taskSerialNo+"@"+phaseNo+"@保存成功！";
	}

	public String importCustomerList(String CustomerID,String certType,String certID,String customerName,String listType,String countryCode,String inputOrgID,String inputUserID,String inputDate) throws Exception{
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