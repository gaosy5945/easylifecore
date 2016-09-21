package com.amarsoft.app.als.prd.analysis.checker;


import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;

public class PRDComponentCheckBeforeDelete {
	private JSONObject inputParameter;
	
	public JSONObject getInputParameter() {
		return inputParameter;
	}

	public JBOTransaction getTx() {
		return tx;
	}

	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public String checkComponent(JBOTransaction tx)throws Exception
	{
		this.tx=tx;
		/* ´úÂë´íÎóÆÁ±Î
		String serialno = (String) inputParameter.getValue("SerialNo");
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		
		BusinessObject paraInfo = bom.keyLoadBusinessObject("jbo.prd.PRD_COMPONENT_LIBRARY", serialno);
		
		String selectShere = " ComponentID=:ComponentID  and objecttype='jbo.prd.PRD_SPECIFIC_LIBRARY' "
							+ "and exists (select 1 from jbo.prd.PRD_SPECIFIC_LIBRARY psl where psl.serialno=O.objectno ) ";
		List<BusinessObject> productParaList = bom.loadBusinessObjects("jbo.prd.PRD_COMPONENT_LIBRARY", selectShere, "ComponentID", paraInfo.getString("ComponentID"));
		if(productParaList!=null&&productParaList.size()>0){
			return "false";
		}
		*/
		return "true";
	}

}
