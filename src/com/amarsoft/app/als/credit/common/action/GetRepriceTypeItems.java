package com.amarsoft.app.als.credit.common.action;

import java.sql.SQLException;

import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

public class GetRepriceTypeItems {
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
	
	public String getItems(JBOTransaction tx) throws Exception{
		this.tx=tx;
		
		BusinessObject pdInfo = BusinessComponentConfig.getComponent("RAT01");
		
		String data = "";
		BusinessObject pr = pdInfo.getBusinessObjectBySql(BusinessComponentConfig.BUSINESS_COMPONENT_PARAMETER, "ParameterID=:ParameterID","ParameterID", "RepriceType");
		if(pr != null ) data = pr.getString("OptionalValue");
		
		String dataTemp = "";
		String[] Temp = data.split(",");
		for(int i = 0;i < Temp.length;i++){
			BusinessObject bo = CashFlowConfig.getRepriceTypeConfig(Temp[i]);
			if(bo == null) continue;
			dataTemp += bo.getString("Name")+","+Temp[i]+",";
		}
		
		data = dataTemp.substring(0,dataTemp.length()-1);
		
		return data;
	}
}
