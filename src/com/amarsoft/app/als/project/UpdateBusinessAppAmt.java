package com.amarsoft.app.als.project;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class UpdateBusinessAppAmt {
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
	public String updateBusinessAppAmt(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(bm);
		String SerialNoGroup = (String)inputParameter.getValue("SerialNoGroup");
		String dataGroup = (String)inputParameter.getValue("DataGroup");
		String parentSerialNo = (String)inputParameter.getValue("ParentSerialNo");
		String[] ArraySerialNo = SerialNoGroup.split("@");
		String[] ArrayDataGroup = dataGroup.split("@");
		for(int i = 0; i < ArrayDataGroup.length; i++){
			bm.createQuery("update O set BusinessAppAmt=:BusinessAppAmt Where SerialNo=:SerialNo and ParentSerialNo=:ParentSerialNo")
			 .setParameter("BusinessAppAmt",ArrayDataGroup[i]).setParameter("SerialNo", ArraySerialNo[i]).setParameter("ParentSerialNo", parentSerialNo).executeUpdate();
		}
		
		return "SUCCEED";

	}
}
