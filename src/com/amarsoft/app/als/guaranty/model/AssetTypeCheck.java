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

	//ѺƷ���ͣ������������
	public String checkTypeInfo(JBOTransaction tx) throws Exception{
		this.tx=tx;
		getBusinessObjectManager();
		String assetType = (String)inputParameter.getValue("AssetType");
		String evaluateMethod = (String)inputParameter.getValue("EvaluateMethod"); //��ֵ��ʽ
		String evaluateModel = (String)inputParameter.getValue("EvaluateModel");   //��ֵ����
		
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> evaList = bomanager.loadBusinessObjects("jbo.sys.CODE_LIBRARY", 
				"CodeNo='AssetType' and ItemNo =:ItemNo and isinuse='1'",
				"ItemNo",assetType);
		if(evaList == null || (evaList != null && evaList.size() != 1)) return "false@��ǰѺƷ���Ͳ����ڣ�";
		BusinessObject eva = evaList.get(0);
		String itemDescribe= eva.getString("ItemDescribe");    //��ֵ��ʽ
		String arr[] = itemDescribe.split("@");
		String method = arr[0];
		String model = "";  //��ֵ����
		if(arr.length == 2) model = arr[1];
		
		if(method.contains(evaluateMethod)) {
			if("4".equals(evaluateMethod)) {
				return "true@����ɹ���";
			} else {
				if(model.contains(evaluateModel)) {
					return "true@����ɹ���";
				}
			}
		}
		
		return "false@��ǰѺƷ��������ѡ������ʽ������������ƥ�䣡";
	}
}