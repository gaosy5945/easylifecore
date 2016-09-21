package com.amarsoft.app.als.project;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;

public class SelectCutCL {
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
	public String selectCutCL(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String CLSerialNo = (String)inputParameter.getValue("CLSerialNo");
		String DivideType = (String)inputParameter.getValue("DivideType");
		return this.selectCutCL(CLSerialNo,DivideType);
	}
	
	public String selectCutCL(String CLSerialNo,String DivideType) throws Exception{
		
		if("00".equals(DivideType)){
			return "Empty";
		}else if("10".equals(DivideType)){
			BusinessObjectManager bomanager = this.getBusinessObjectManager();
			List<BusinessObject> listProduct = bomanager.loadBusinessObjects("jbo.cl.CL_INFO", "DivideType=:DivideType and ParentSerialNo=:ParentSerialNo", "DivideType", DivideType,"ParentSerialNo", CLSerialNo);
			if(listProduct == null || listProduct.isEmpty()){
				return "EmptyProduct";
			}else{
				return "FullProduct";
			}
		}else{
			BusinessObjectManager bomanager = this.getBusinessObjectManager();
			List<BusinessObject> listOrg = bomanager.loadBusinessObjects("jbo.cl.CL_INFO", "DivideType=:DivideType and ParentSerialNo=:ParentSerialNo", "DivideType", DivideType,"ParentSerialNo", CLSerialNo);
			if(listOrg == null || listOrg.isEmpty()){
				return "EmptyOrg";
			}else{
				return "FullOrg";
			}
		}				
	}
}
