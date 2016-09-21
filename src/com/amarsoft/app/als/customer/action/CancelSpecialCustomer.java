package com.amarsoft.app.als.customer.action;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class CancelSpecialCustomer {
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
	//更新Customer_List表使用状态
	public String cancelSpecialCustomer(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_LIST");
		tx.join(bm);
		
		String serialNos = (String)inputParameter.getValue("SerialNos");
		String[] serialNosArray = serialNos.split("@");
		for(int i = 0; i < serialNosArray.length; i++){
			bm.createQuery("update O set Status=:Status,UpdateDate=:UpdateDate Where SerialNo=:SerialNo")
			  .setParameter("Status","2").setParameter("UpdateDate",DateHelper.getBusinessDate()).setParameter("SerialNo", serialNosArray[i]).executeUpdate();
		}
		
		return "SUCCEED";
	}
}
