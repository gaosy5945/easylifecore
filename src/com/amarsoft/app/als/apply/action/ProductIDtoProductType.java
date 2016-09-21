package com.amarsoft.app.als.apply.action;

/**
 * √Ë ˆ£∫
 * @author fengcr
 * @2015/3/5 
 */

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class ProductIDtoProductType {
	private JSONObject inputParameter;
	
	public void setInputParameter(JSONObject inputParameter){
		this.inputParameter = inputParameter;
	}
	
	public String getRalativeProductType(JBOTransaction tx) throws JBOException{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prd.PRD_PRODUCT_LIBRARY");
		tx.join(bm);
		String ProductID = (String)inputParameter.getValue("ProductID");
		BizObject prdbiz = bm.createQuery("O.ProductID = :ProductID").setParameter("ProductID",ProductID).getSingleResult(true);
		String ProductType3 = prdbiz.getAttribute("ProductType3").toString();
		return ProductType3;
	}
	
	public String getRalativeApplySerialNo(JBOTransaction tx) throws JBOException{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		tx.join(bm);
		String ContractSerialNO = (String)inputParameter.getValue("ContractSerialNO");
		BizObject bcbiz = bm.createQuery("O.SerialNo = :ContractSerialNO").setParameter("ContractSerialNO",ContractSerialNO).getSingleResult(true);
		String ApplySerialNo = bcbiz.getAttribute("APPLYSERIALNO").toString();
		return ApplySerialNo;
	}
}
