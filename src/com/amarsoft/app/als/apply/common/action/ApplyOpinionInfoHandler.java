package com.amarsoft.app.als.apply.common.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
/**
 * 签署意见显示模板页面设置默认值
 * @author lyin
 *
 */
public class ApplyOpinionInfoHandler extends CommonHandler {

	protected void initDisplayForAdd(BizObject bo) throws Exception {
		//String sObjectType = asPage.getParameter("ObjectType");
		String sObjectNo=asPage.getParameter("ObjectNo");
		String sSerialNo=asPage.getParameter("TaskNo");

		BizObject businessApply=JBOFactory.getBizObject("jbo.app.BUSINESS_APPLY", sObjectNo);
		
		if(businessApply!=null){
			//ARE.getLog().debug(sObjectNo);
			String[][] defaultFields = {
					{ "CustomerID", businessApply.getAttribute("CustomerID").getString() },
					{ "CustomerName",businessApply.getAttribute("CustomerName").getString()},
					{ "BusinessCurrency", businessApply.getAttribute("BusinessCurrency").getString()},
					{ "BusinessSum",businessApply.getAttribute("BusinessSum").getString()},
					{ "BaseRate", businessApply.getAttribute("BaseRate").getString() },
					{ "BaseRateType", businessApply.getAttribute("BaseRateType").getString() },
					{ "RateFloatType",businessApply.getAttribute("RateFloatType").getString()},
					{ "RateFloat", businessApply.getAttribute("RateFloat").getString()},
					{ "BusinessRate",businessApply.getAttribute("BusinessRate").getString()},
					{ "BailCurrency", businessApply.getAttribute("BailCurrency").getString() },
					{ "BailSum",businessApply.getAttribute("BailSum").getString()},
					{ "BailRatio", businessApply.getAttribute("BailRatio").getString()},
					{ "PdgRatio",businessApply.getAttribute("PdgRatio").getString()},
					{ "PdgSum", businessApply.getAttribute("PdgSum").getString() },
					{ "BusinessType",businessApply.getAttribute("BusinessType").getString()},
					{ "TermMonth", businessApply.getAttribute("TermMonth").getString()},
					{ "TermDay",businessApply.getAttribute("TermDay").getString()},
					{ "ObjectType", "CreditApply"},
					{ "ObjectNo",sObjectNo},
					{ "SerialNo",sSerialNo}
					
			};

			for (int i = 0; i < defaultFields.length; i++){
				try{
					bo.setAttributeValue(defaultFields[i][0], defaultFields[i][1]);
				}
				catch (Exception e){
					
				}
			}

		}
	}
}
