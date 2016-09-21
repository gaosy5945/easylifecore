package com.amarsoft.app.als.customer.action;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;

public class JudgeIndDate {
	private JSONObject inputParameter;
	private BusinessObjectManager businessObjectManager;
	private String birthDay = "";
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	public void setInputParameter(String key,Object value) {
		if(this.inputParameter == null)
			inputParameter = JSONObject.createObject();
		com.amarsoft.are.lang.Element a = new com.amarsoft.are.util.json.JSONElement(key);
		a.setValue(value);
		inputParameter.add(a);
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
	
	public String judgeIndDate(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String CustomerID = (String)inputParameter.getValue("CustomerID");
		String jboYears = (String)inputParameter.getValue("jboYears");
		return this.judgeIndDate(CustomerID,jboYears);
	}
	
	public String judgeIndDate(String CustomerID,String jboYears) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		//查出该客户的出生日期，请做处理
		List<BusinessObject> listII = bomanager.loadBusinessObjects("jbo.customer.IND_INFO", "CustomerID=:CustomerID", "CustomerID",CustomerID);
		String birthDayTemp = listII.get(0).getString("BIRTHDAY");
		int bo = birthDayTemp.length();
		if(bo == 8){
				birthDay = birthDayTemp.substring(0, 4)+birthDayTemp.substring(4, 6)+birthDayTemp.substring(6, 8);
				String jboYearsTemp = jboYears.substring(0, 4)+jboYears.substring(5, 7)+jboYears.substring(8, 10);
			return "true@"+birthDay+"@"+jboYearsTemp;
		}else{
			if("".equals(birthDayTemp)){
				birthDay = "";
			}else{
				birthDay = birthDayTemp.substring(0, 4)+birthDayTemp.substring(5, 7)+birthDayTemp.substring(8, 10);
			}

				String jboYearsTemp = jboYears.substring(0, 4)+jboYears.substring(5, 7)+jboYears.substring(8, 10);

			return "true@"+birthDay+"@"+jboYearsTemp;
		}
		
	}
}
