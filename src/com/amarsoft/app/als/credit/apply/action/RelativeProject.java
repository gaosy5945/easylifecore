package com.amarsoft.app.als.credit.apply.action;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.credit.guaranty.guarantycontract.GetGCContractNo;
import com.amarsoft.app.als.guaranty.model.GuarantyFunctions;
import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.json.JSONObject;

public class RelativeProject {
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}

	public String deleteProject(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String serialNo = (String)inputParameter.getValue("SerialNo");
		return this.deleteProject(serialNo);
	}
	
	public String deleteProject(String serialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject prjRelative = bomanager.keyLoadBusinessObject("jbo.prj.PRJ_RELATIVE", serialNo);
		
		//删除担保信息
		String objectType = prjRelative.getString("ObjectType");
		String objectNo = prjRelative.getString("ObjectNo");
		
		String[] tables = GuarantyFunctions.getRelativeTable(objectType);
		
		String projectSerialNo = prjRelative.getString("ProjectSerialNo");
		List<BusinessObject> boList = bomanager.loadBusinessObjects("jbo.guaranty.GUARANTY_CONTRACT", 
				"ProjectSerialNo=:ProjectSerialNo and SerialNo in(select B.objectno from "+tables[0]+" B where B."+tables[1]+" = :SerialNo and B.ObjectType='jbo.guaranty.GUARANTY_CONTRACT')", "ProjectSerialNo",projectSerialNo,"SerialNo",objectNo);
		if(boList != null){
			for(BusinessObject o : boList){
				bomanager.deleteBusinessObject(o);
				
				List<BusinessObject> miList = bomanager.loadBusinessObjects("jbo.guaranty.CLR_MARGIN_INFO", " objecttype=:ObjectType and objectno=:ObjectNo ", "ObjectType", "jbo.guaranty.GUARANTY_CONTRACT","ObjectNo", o.getKeyString());
				for(BusinessObject mi:miList){
					String miSerialNo = mi.getKeyString();
					
					List<BusinessObject> acctnoList = bomanager.loadBusinessObjects("jbo.acct.ACCT_BUSINESS_ACCOUNT", " objecttype=:ObjectType and objectno=:ObjectNo ", "ObjectType", "jbo.guaranty.CLR_MARGIN_INFO","ObjectNo", miSerialNo);
					for(BusinessObject actno:acctnoList){
						bomanager.deleteBusinessObject(actno);
					}
					
					bomanager.deleteBusinessObject(mi);
				}
			}
		}
		bomanager.deleteBusinessObject(prjRelative);

		bomanager.updateDB();
		return "true";
	}
	
	public String importProjects(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String projectSerialNo = (String)inputParameter.getValue("SerialNo");
		String objectType = (String)inputParameter.getValue("ObjectType");
		String objectNo = (String)inputParameter.getValue("ObjectNo");
		String relativeType = (String)inputParameter.getValue("RelativeType");
		String orgID = (String)inputParameter.getValue("OrgID");
		String userID = (String)inputParameter.getValue("UserID");
		String customerID = (String)inputParameter.getValue("CustomerID");
		String SerialNo = (String)inputParameter.getValue("SerialNo");
		
		return this.importProjects(projectSerialNo,objectType,objectNo,relativeType,userID,customerID,SerialNo);
	}
	
	public String importProjects(String projectSerialNo,String objectType,String objectNo,String relativeType,String userID,String customerID,String SerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject prjRelative = BusinessObject.createBusinessObject("jbo.prj.PRJ_RELATIVE");
		ASUserObject user = ASUserObject.getUser(userID);

		BusinessObject main = bomanager.keyLoadBusinessObject(objectType, objectNo);
		
		List<BusinessObject> boList = bomanager.loadBusinessObjects("jbo.prj.PRJ_RELATIVE", "ProjectSerialNo=:ProjectSerialNo and ObjectType=:ObjectType and ObjectNo=:ObjectNo  and RelativeType=:RelativeType","ProjectSerialNo", SerialNo,"ObjectNo", objectNo,"ObjectType", objectType,"RelativeType", relativeType);
		if(boList != null && !boList.isEmpty()) return "已经存在该合作项目，请重新选择！";	

		prjRelative.setAttributeValue("ProjectSerialNo", SerialNo);
		prjRelative.setAttributeValue("ObjectType", objectType);
		prjRelative.setAttributeValue("ObjectNo", objectNo);
		prjRelative.setAttributeValue("RelativeType", relativeType);
		prjRelative.generateKey();
		bomanager.updateBusinessObject(prjRelative);
		
		//若合作项目有担保额度，则引入
		List<BusinessObject> prjRelaList = bomanager.loadBusinessObjects("jbo.prj.PRJ_RELATIVE", "ProjectSerialNo=:ProjectSerialNo and ObjectType='jbo.guaranty.GUARANTY_CONTRACT'", "ProjectSerialNo",projectSerialNo);
		if(prjRelaList != null && prjRelaList.size()!=0){
			for(BusinessObject prjRela:prjRelaList)
			{
				String gcSerialNo = prjRela.getString("ObjectNo");
				
				BusinessObject prGCInfo = bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", gcSerialNo); 
				
				if(!"02".equals(prGCInfo.getString("ContractStatus"))) continue;
				
				BusinessObject gcInfo = BusinessObject.createBusinessObject("jbo.guaranty.GUARANTY_CONTRACT");
				gcInfo.setAttributesValue(prGCInfo);
				gcInfo.setAttributeValue("ContractType", "010");
				gcInfo.setAttributeValue("ContractNo", GetGCContractNo.getCeilingGCContractNo(gcInfo));
				gcInfo.setAttributeValue("SerialNo", "");
				gcInfo.setAttributeValue("contractstatus", "01");
				gcInfo.setAttributeValue("GuarantyValue", Arith.round(main.getDouble("BusinessSum"),2));
				gcInfo.setAttributeValue("InputOrgID", user.getOrgID());
				gcInfo.setAttributeValue("InputuserID", userID);
				gcInfo.setAttributeValue("Inputdate", DateHelper.getBusinessDate());
				gcInfo.setAttributeValue("UpdateDate", DateHelper.getBusinessDate());
				gcInfo.setAttributeValue("UpdateOrgID", user.getOrgID());
				gcInfo.setAttributeValue("UpdateUserID", user.getUserID());
				gcInfo.generateKey();
				bomanager.updateBusinessObject(gcInfo);
				String newgcSerialNo = gcInfo.getKeyString();
				
				List<BusinessObject> prMIList = bomanager.loadBusinessObjects("jbo.guaranty.CLR_MARGIN_INFO", " objecttype=:ObjectType and objectno=:ObjectNo ", "ObjectType", "jbo.prj.PRJ_BASIC_INFO","ObjectNo", projectSerialNo);
				for(BusinessObject o: prMIList){
					BusinessObject mi = BusinessObject.createBusinessObject("jbo.guaranty.CLR_MARGIN_INFO");
					mi.setAttributesValue(o);
					mi.setAttributeValue("ObjectType","jbo.guaranty.GUARANTY_CONTRACT");
					mi.setAttributeValue("ObjectNo",newgcSerialNo);
					mi.setAttributeValue("SerialNo","");
					mi.setAttributeValue("InputOrgID", user.getOrgID());
					mi.setAttributeValue("InputuserID", userID);
					mi.setAttributeValue("Inputdate", DateHelper.getBusinessDate());
					mi.setAttributeValue("UpdateDate", DateHelper.getBusinessDate());
					mi.setAttributeValue("UpdateOrgID", user.getOrgID());
					mi.setAttributeValue("UpdateUserID", user.getUserID());
					mi.setAttributeValue("CONTRACTAMOUNT",Arith.round(main.getDouble("BusinessSum")*o.getDouble("INDIVIDUALPERCENT")/100d,2));
					
					mi.generateKey();
					bomanager.updateBusinessObject(mi);
					String miSerialNo = mi.getKeyString();
					
					List<BusinessObject> pacctnoList = bomanager.loadBusinessObjects("jbo.acct.ACCT_BUSINESS_ACCOUNT", " objecttype=:ObjectType and objectno=:ObjectNo ", "ObjectType", "jbo.guaranty.CLR_MARGIN_INFO","ObjectNo", o.getKeyString());
					for(BusinessObject pacctnoInfo:pacctnoList){
						BusinessObject acctnoInfo = BusinessObject.createBusinessObject("jbo.acct.ACCT_BUSINESS_ACCOUNT");
						acctnoInfo.setAttributesValue(pacctnoInfo);
						acctnoInfo.setAttributeValue("ObjectType", "jbo.guaranty.CLR_MARGIN_INFO");
						acctnoInfo.setAttributeValue("ObjectNo", miSerialNo);
						acctnoInfo.setAttributeValue("SerialNo","");
						acctnoInfo.setAttributeValue("InputOrgID", user.getOrgID());
						acctnoInfo.setAttributeValue("InputuserID", userID);
						acctnoInfo.setAttributeValue("Inputdate", DateHelper.getBusinessDate());
						acctnoInfo.setAttributeValue("UpdateDate", DateHelper.getBusinessDate());
						acctnoInfo.setAttributeValue("UpdateOrgID", user.getOrgID());
						acctnoInfo.setAttributeValue("UpdateUserID", user.getUserID());
						acctnoInfo.generateKey();
						bomanager.updateBusinessObject(acctnoInfo);
					}
				}
				
				String[] relativeTables=com.amarsoft.app.als.guaranty.model.GuarantyFunctions.getRelativeTable(objectType);
				String jboName = relativeTables[0];
				BusinessObject applyRelative = BusinessObject.createBusinessObject(jboName);//jbo.app.APPLY_RELATIVE
				applyRelative.setAttributeValue(relativeTables[1], objectNo);
				applyRelative.setAttributeValue("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT");
				applyRelative.setAttributeValue("ObjectNo", newgcSerialNo);
				applyRelative.setAttributeValue("RelativeType", "05");
				applyRelative.generateKey();
				bomanager.updateBusinessObject(applyRelative);
			}
		}
		
		bomanager.updateDB();
		return "true";
	}
	
	public String importCustomers(JBOTransaction tx)throws Exception{
		String customerID = inputParameter.getValue("CustomerID").toString();
		String prjSerialNo = inputParameter.getValue("prjSerialNo").toString();
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO", tx);
		@SuppressWarnings("unchecked")
		List<BizObject> bos = bom.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",customerID).getResultList(false);
		if(bos==null||bos.size()<1){
			return "请重新选择合作客户！";
		}
		BusinessObject bo = BusinessObject.convertFromBizObject(bos.get(0));
		
		//插入关联关系,判断是否重复引入
		BizObjectManager bomRelative = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE", tx);
		@SuppressWarnings("unchecked")
		List<BizObject> bosRelative = bomRelative.createQuery("ObjectType='jbo.customer.CUSTOMER_INFO' and ProjectSerialNo=:ProjectSerialNo and ObjectNo=:ObjectNo")
										.setParameter("ProjectSerialNo",prjSerialNo)
										.setParameter("ObjectNo",customerID)
										.getResultList(false);
		if(bosRelative.size()>0) return "true";
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject prjRelative = BusinessObject.createBusinessObject("jbo.prj.PRJ_RELATIVE");

		prjRelative.setAttributeValue("ProjectSerialNo", prjSerialNo);
		prjRelative.setAttributeValue("ObjectType", bo.getBizClassName());
		prjRelative.setAttributeValue("ObjectNo", customerID);
		prjRelative.setAttributeValue("RelativeType", "03");
		prjRelative.generateKey();
		bomanager.updateBusinessObject(prjRelative);
		bomanager.updateDB();
		return "true";
	}
	
}