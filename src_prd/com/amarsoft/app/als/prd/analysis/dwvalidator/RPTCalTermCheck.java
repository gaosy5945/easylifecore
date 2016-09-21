package com.amarsoft.app.als.prd.analysis.dwvalidator;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.dw.ui.validator.CustomValidator;


/**
 * @author t-zhangq2
 * 日期不晚于今天
 */
public class RPTCalTermCheck extends CustomValidator{

	public String valid(String calTermString) throws Exception{
		int calTerm=Integer.parseInt(calTermString);
		if(calTerm==0) return "";
		String productID = this.getInputValue("ProductID");
		String businessType = this.getInputValue("BusinessType");
		if(StringX.isEmpty(businessType))return "";
		
		BusinessObject businessData=BusinessObject.createBusinessObject();
		businessData.setAttributeValue("ProductID", productID);
		businessData.setAttributeValue("BusinessType", businessType);
		double maxTerm = ProductAnalysisFunctions.getComponentMaxValue(businessData, "PRD02-01", "BusinessTerm", "0010", "02");
		double minTerm = ProductAnalysisFunctions.getComponentMinValue(businessData, "PRD02-01", "BusinessTerm", "0010", "02");
		if(calTerm<minTerm||calTerm>maxTerm){
			return "期供计算期限不符合产品约定！产品约定范围为："+(int)minTerm+"-"+(int)maxTerm;
		}
		return "";
	}
	
}
