package com.amarsoft.app.als.project;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;

public class SelectProductAndParticipate {
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
	
	public String selectProductAndParticipate(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String prjSerialNo = (String)inputParameter.getValue("prjSerialNo");
		String productList = (String)inputParameter.getValue("productList");
		String participateOrg = (String)inputParameter.getValue("participateOrg");
		String CompareProductList = productList.replace("@","");
		String CompareParticipateOrg = participateOrg.replace("@","");
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> listCL = bomanager.loadBusinessObjects("jbo.prj.PRJ_BASIC_INFO", "SerialNo=:SerialNo", "SerialNo", prjSerialNo);
		if(listCL == null || listCL.isEmpty()){
			return "Empty";
		}else{
			String productListLast = listCL.get(0).getString("PRODUCTLIST");
			String participateOrgLast = listCL.get(0).getString("PARTICIPATEORG");
			String CompareProductListLast = productListLast.replace(",","");
			String CompareParticipateOrgLast = participateOrgLast.replace(",","");
			
			if((productListLast == null || productListLast.isEmpty())||(participateOrgLast == null || participateOrgLast.isEmpty())){
				return "Empty";
			}else if((!CompareParticipateOrg.equals(CompareParticipateOrgLast))&&(CompareProductList.equals(CompareProductListLast))){
				return "ProductSame";
			}else if((CompareParticipateOrg.equals(CompareParticipateOrgLast))&&(!CompareProductList.equals(CompareProductListLast))){
				return "ParticipateSame";
			}else if((CompareParticipateOrg.equals(CompareParticipateOrgLast))&&(CompareProductList.equals(CompareProductListLast))){
				return "Same";
			}else{
				return "Different";
			}
		}
	}
}
