package com.amarsoft.acct.systemconfig;

import java.util.List;

import com.amarsoft.app.accounting.util.LoanHelper;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.DataConvert;

public class ModelReturn {
	//得到单个金额
	public static String getReturnValue(String relativeObjectType,String relativeObjectNo,String accountCodeNo) throws Exception{
		double value = LoanHelper.getSubledgerBalance(relativeObjectType,relativeObjectNo,accountCodeNo);
		if("Customer01".equalsIgnoreCase(accountCodeNo)  || "Customer02".equalsIgnoreCase(accountCodeNo) || "Customer12".equalsIgnoreCase(accountCodeNo))
		{
			BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
			BusinessObject loan = bomanager.keyLoadBusinessObject(relativeObjectType, relativeObjectNo); 
			List<BusinessObject> pss = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule, "RelativeObjectNo=:RelativeObjectNo and RelativeObjectType=:RelativeObjectType and PayDate=:PayDate and Status=:Status",
											"RelativeObjectNo",relativeObjectNo,"RelativeObjectType",relativeObjectType,"PayDate",loan.getString("BusinessDate"),"Status","1");
			for(BusinessObject ps:pss)
			{
				if("Customer01".equalsIgnoreCase(accountCodeNo) )
					value -= ps.getDouble("PayPrincipalAmt")-ps.getDouble("ActualPayPrincipalAmt");
				else if("Customer02".equalsIgnoreCase(accountCodeNo) )
					value += ps.getDouble("PayPrincipalAmt")-ps.getDouble("ActualPayPrincipalAmt");
				else if("Customer12".equalsIgnoreCase(accountCodeNo) )
					value += ps.getDouble("PayInterestAmt")-ps.getDouble("ActualPayInterestAmt");
			}
		}
		return DataConvert.toMoney(value);
	}
	//得到组建编号对应名称
	public static String getReturnValue(String termid) throws JBOException, Exception{
		if(StringX.isEmpty(termid)) return "未定义组件";
		String termName =BusinessComponentConfig.getComponent(termid).getString("name");
		return termName;
	}
	//得到两个金额的和
	public static String getReturnValue(String relativeObjectType,String relativeObjectNo,String accountCodeNo1,String accountCodeNo2) throws Exception{
		Double value1 = LoanHelper.getSubledgerBalance(relativeObjectType,relativeObjectNo,accountCodeNo1);
		Double value2 = LoanHelper.getSubledgerBalance(relativeObjectType,relativeObjectNo,accountCodeNo2);
		Double value = value1+value2;
		return Double.toString(value);
	}
	
}