package com.amarsoft.app.als.prd.analysis.dwvalidator;

import com.amarsoft.app.als.businesscomponent.analysis.BusinessComponentAnalysisFunctions;
import com.amarsoft.app.als.businesscomponent.analysis.checkmethod.ParameterChecker;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;
import com.amarsoft.awe.dw.ui.validator.CustomValidator;


/**
 * @author t-zhangq2
 * 日期不晚于今天
 */
public class LTVCheck extends CustomValidator{

	public String valid(String parameterValue) throws Exception{
		String assetType=this.getInputValue("AssetType");
		String objectType=this.getInputValue("BusinessObjectType");
		String objectNo=this.getInputValue("BusinessObjectNo");
		String assetValueString=this.getInputValue("ConfirmValue");
		if(StringX.isEmpty(parameterValue)||StringX.isEmpty(assetValueString)
				||StringX.isEmpty(objectType)||StringX.isEmpty(objectNo)||StringX.isEmpty(assetType)) return "";
		
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject business=bomanager.keyLoadBusinessObject(objectType, objectNo);
		
		String productID = business.getString("ProductID");
		String businessType = business.getString("BusinessType");
		if(StringX.isEmpty(businessType))return "";
		String parameterID = this.getConstValue("ParameterID");
		String termID = this.getConstValue("TermID");
		
		
		
		BusinessObject component = ProductConfig.getSpecific(businessType, productID).getBusinessObjectBySql(BusinessComponentConfig.BUSINESS_COMPONENT
				, "ID=:ID","ID",termID);
		
		BusinessObject parameter=BusinessComponentAnalysisFunctions.getValidParameter(component, "LTV", "CollateralType="+assetType, bomanager);
		if(parameter==null) return "";
		assetValueString=StringHelper.replaceAllIgnoreCase(assetValueString, ",", "");
		double assetValue=Double.parseDouble(assetValueString);
		if(assetValue==0)assetValue=0.000001;
		
		parameterValue=StringHelper.replaceAllIgnoreCase(parameterValue, ",", "");
		double ltv=Double.parseDouble(parameterValue)/(assetValue)*100.0;
		ltv=Arith.round(ltv, 2);
		BusinessObject result =ParameterChecker.getParameterChecker(parameterID).checkParameterValue(ltv, parameter);
		if(!"true".equalsIgnoreCase(result.getString("CheckResult"))){
			return result.getString("Message");
		}
		return "";
	}
	
}
