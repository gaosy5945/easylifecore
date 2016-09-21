package com.amarsoft.app.als.credit.apply.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.object.Item;

public class CollateralTemplate {
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

	public String getTemplate(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String itemNo = (String)inputParameter.getValue("ItemNo");
		return this.getTemplate(itemNo);
	}
	
	public String getTemplate(String itemNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
	
		String templateNo = "";
		Item temp = CodeManager.getItem("AssetType", itemNo);
		if(temp == null){
			return "false";
		}else{
			templateNo = temp.getAttribute1();
		}
		if(templateNo == null) return "false";
		
		return "true@"+templateNo;
	}
	
	public String getJBOName(String itemNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject assetTypeCode = bomanager.loadBusinessObjects("jbo.sys.CODE_LIBRARY", "CodeNo='AssetType' and "
				+ "ItemNo=:ItemNo", "ItemNo",itemNo).get(0);
		
		String jboName = assetTypeCode.getString("Attribute2");
		if(jboName == null) return "";
		
		return jboName;
	}
	
	//担保比例的要求
	public double getGuarantyPercent(String itemNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject assetTypeCode = bomanager.loadBusinessObjects("jbo.sys.CODE_LIBRARY", "CodeNo='AssetType' and "
				+ "ItemNo=:ItemNo", "ItemNo",itemNo).get(0);
		
		double perct = assetTypeCode.getDouble("Attribute6");
		
		return perct;
	}
	
	public String getRightCert(String itemNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject assetTypeCode = bomanager.loadBusinessObjects("jbo.sys.CODE_LIBRARY", "CodeNo='AssetType' and "
				+ "ItemNo=:ItemNo", "ItemNo",itemNo).get(0);
		
		String cert = assetTypeCode.getString("Attribute4");  //该类押品的权证号在模板中的字段
		if(cert == null) return "";
		
		return cert;
	}
}