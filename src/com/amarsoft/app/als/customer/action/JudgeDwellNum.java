package com.amarsoft.app.als.customer.action;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class JudgeDwellNum {
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
	public String judgeDwellNum(JBOTransaction tx) throws Exception{
		String BirthDay = (String)inputParameter.getValue("BirthDay");
		String DwellNum = (String)inputParameter.getValue("DwellNum");
		String Today = DateHelper.getBusinessDate();
		int Years = (int) Math.ceil(DateHelper.getMonths(BirthDay,Today)/12);
		int DwellNumYears = Integer.valueOf(DwellNum);
		
		if(DwellNumYears > Years){
			return "Over";
		}else{
			return "Comfortable";
		}
	}
}
