package com.amarsoft.app.als.activeCredit.customerBase;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class LoseEfficacy {
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
	
	public String lose(JBOTransaction tx) throws Exception{
		String updateSerialNos = (String)inputParameter.getValue("updateSerialNos");
		String updateDate = (String)inputParameter.getValue("updateDate");
		
		String[] serialNoArray = updateSerialNos.split("@");
		for(int i = 0;i < serialNoArray.length;i++){
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_LIST_RELATIVE");
			tx.join(bm);
			bm.createQuery("UPDATE O SET BusinessStatus =:BusinessStatus,ExpifyDate=:ExpifyDate WHERE SerialNo = :SerialNo")
				  .setParameter("BusinessStatus", "2").setParameter("ExpifyDate", updateDate).setParameter("SerialNo", serialNoArray[i])
				  .executeUpdate();
		}
		return "SUCCEED";
	}
	
}
