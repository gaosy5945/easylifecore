package com.amarsoft.app.als.project;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class GetBusinessAppAmt {
	private double sum = 0.0;
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
	
	public String getBusinessAppAmt(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String parentSerialNo = (String)inputParameter.getValue("ParentSerialNo");
		String divideType = (String)inputParameter.getValue("DivideType");
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> listCL = bomanager.loadBusinessObjects("jbo.cl.CL_INFO", "parentSerialNo=:parentSerialNo", "parentSerialNo",parentSerialNo);
		List<BusinessObject> listDivideType = bomanager.loadBusinessObjects("jbo.cl.CL_INFO", "SerialNo=:SerialNo", "SerialNo",parentSerialNo);

		if(listDivideType == null || listDivideType.isEmpty()){
			return "CLParentEmpty";
		}else{
			if(listCL == null || listCL.isEmpty()){
				return "CLEmpty";
			}else{
				String divideTypeParent = listDivideType.get(0).getString("DIVIDETYPE");
				if(!divideType.equals(divideTypeParent)){
					return "SameNotSave";
				}else{
					for(BusinessObject bo: listCL){
						 double amount = bo.getDouble("BUSINESSAPPAMT");
						 sum += amount;	
					}
					return String.valueOf(sum);
				}
			}
		}
	}	
}
