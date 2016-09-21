package com.amarsoft.app.als.prd.analysis.dwvalidator;

import com.amarsoft.app.als.businesscomponent.analysis.checkmethod.ParameterChecker;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.dw.ui.validator.CustomValidator;


/**
 * @author t-zhangq2
 * 日期不晚于今天
 */
public class BusinessTermCheck extends CustomValidator{

	public String valid(String parameterValue) throws Exception{
		String year=this.getInputValue("BusinessTermYear");
		String month=this.getInputValue("BusinessTermMonth");
		String day=this.getInputValue("BusinessTermDay");
		String maturityDate=this.getInputValue("MaturityDate");
		double businessTerm=(StringX.isEmpty(year)?0:Integer.parseInt(year))*12
				+(StringX.isEmpty(month)?0:Integer.parseInt(month))
				+(StringX.isEmpty(day)?0:Integer.parseInt(day)/30.0);
		if(!StringX.isEmpty(maturityDate)){
			businessTerm=DateHelper.getMonths(DateHelper.getBusinessDate(), maturityDate);
		}
		
		if(businessTerm==0) return "";
		String productID = this.getInputValue("ProductID");
		String businessType = this.getInputValue("BusinessType");
		if(StringX.isEmpty(businessType))return "";
		String parameterID = this.getConstValue("ParameterID");
		
		BusinessObject businessData=BusinessObject.createBusinessObject();
		businessData.setAttributeValue("BusinessType", businessType);
		businessData.setAttributeValue("ProductID", productID);
		
		BusinessObject parameter=ProductAnalysisFunctions.getProductParameter(businessData, parameterID, "", "02");
		if(parameter==null) return "";
		
		BusinessObject result =ParameterChecker.getParameterChecker(parameterID).checkParameterValue(businessTerm, parameter);
		if(!"true".equalsIgnoreCase(result.getString("CheckResult"))){
			//return "期限不符合产品定义！产品约定范围为："+minTerm+"-"+maxTerm;
			return result.getString("Message");
		}
		return "";
	}
	
}
