package com.amarsoft.app.als.guaranty.model;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;

public class AssetTypeCheck {
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

	//押品类型，评估方法检查
	public String checkTypeInfo(JBOTransaction tx) throws Exception{
		this.tx=tx;
		getBusinessObjectManager();
		String assetType = (String)inputParameter.getValue("AssetType");
		String evaluateMethod = (String)inputParameter.getValue("EvaluateMethod"); //估值方式
		String evaluateModel = (String)inputParameter.getValue("EvaluateModel");   //估值方法
		
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> evaList = bomanager.loadBusinessObjects("jbo.sys.CODE_LIBRARY", 
				"CodeNo='AssetType' and ItemNo =:ItemNo and isinuse='1'",
				"ItemNo",assetType);
		if(evaList == null || (evaList != null && evaList.size() != 1)) return "false@当前押品类型不存在！";
		BusinessObject eva = evaList.get(0);
		String itemDescribe= eva.getString("ItemDescribe");    //估值方式
		String arr[] = itemDescribe.split("@");
		String method = arr[0];
		String model = "";  //估值方法
		if(arr.length == 2) model = arr[1];
		
		if(method.contains(evaluateMethod)) {
			if("4".equals(evaluateMethod)) {
				return "true@保存成功！";
			} else {
				if(model.contains(evaluateModel)) {
					return "true@保存成功！";
				}
			}
		}
		
		return "false@当前押品类型与所选评估方式，评估方法不匹配！";
	}
}