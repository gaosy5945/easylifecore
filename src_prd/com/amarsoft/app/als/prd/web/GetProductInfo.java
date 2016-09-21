package com.amarsoft.app.als.prd.web;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;

public class GetProductInfo {
	private String productType3;
	private String productID;
	public String getProductType3() {
		return productType3;
	}
	public void setProductType3(String productType3) {
		this.productType3 = productType3;
	}
	
	public String getProductID() {
		return productID;
	}
	public void setProductID(String productID) {
		this.productID = productID;
	}
	public String getProductID(JBOTransaction tx) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.prd.PRD_PRODUCT_LIBRARY",tx);
		BizObjectQuery boq = bom.createQuery("ProductType3=:productType3 and status='1'").setParameter("productType3", productType3);
		if(boq==null) return"fasle";
		@SuppressWarnings("unchecked")
		List<BizObject> list = boq.getResultList(false);
		String returnValue= "true";
		for(BizObject bo:list)
			returnValue+="@"+bo.getAttribute("PRODUCTID").getString();
		return returnValue;
	}
	
	/*转换产品名称*/
	public String getProductNames(JBOTransaction tx) throws Exception{
		if(productID==null||productID.equals("")) return "";
		String productName="";
		try{
				BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.prd.PRD_PRODUCT_LIBRARY",tx);
				
				productID=StringFunction.replace(productID, "@", "','");
				
				@SuppressWarnings("unchecked")
				List<BizObject> lst = bm.createQuery("PRODUCTID in ('"+productID+"')").getResultList(false); 
				for(BizObject bo:lst){
					if(productName.equals("")){
						productName+=bo.getAttribute("PRODUCTNAME").getString();
					}else{
						productName+="@"+bo.getAttribute("PRODUCTNAME").getString();
					}
				}
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return productName;
	}
}
