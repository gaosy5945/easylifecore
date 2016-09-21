package com.amarsoft.app.als.prd.analysis.dwvalidator;


import com.amarsoft.app.als.businesscomponent.analysis.BusinessComponentAnalysisFunctions;
import com.amarsoft.app.als.businesscomponent.analysis.checkmethod.ParameterChecker;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.dw.ui.validator.CustomValidator;


/**
 * @author t-zhangq2
 * 日期不晚于今天
 */
public class ProductParameterCheck extends CustomValidator{

	public String valid(String parameterValue) throws Exception{
		if(StringX.isEmpty(parameterValue)) return "";
		
		String productID = this.getInputValue("ProductID");
		String businessType = this.getInputValue("BusinessType");
		if(StringX.isEmpty(businessType))return "";
		String parameterID = this.getConstValue("ParameterID");
		String termID = this.getConstValue("TermID");
		if(StringX.isEmpty(termID)){
			termID = this.getInputValue("TermID");
		}
		BusinessObject parameter=null;
		BusinessObject businessData=BusinessObject.createBusinessObject();
		businessData.setAttributeValue("BusinessType", businessType);
		businessData.setAttributeValue("ProductID", productID);
		if(StringX.isEmpty(termID)){
			parameter=ProductAnalysisFunctions.getProductParameter(businessData, parameterID, "", "02");
		}
		else{
			BusinessObject component = ProductConfig.getSpecific(businessType, productID).getBusinessObjectBySql(BusinessComponentConfig.BUSINESS_COMPONENT
					, "ID=:ID","ID",termID);
			parameter=BusinessComponentAnalysisFunctions.getValidParameter(businessData, component, parameterID, 
					"", "02", BusinessObjectManager.createBusinessObjectManager());
		}
		
		if(parameter==null) return "";
		ParameterChecker pc =ParameterChecker.getParameterChecker(parameterID);
		Object value=BusinessComponentAnalysisFunctions.convertParameterValue(parameterValue,parameter);
		BusinessObject result =pc.checkParameterValue(value, parameter);
		if(!"true".equalsIgnoreCase(result.getString("CheckResult"))){
			return result.getString("Message");
		}
		return "";
	}
	
	
	
}
