package com.amarsoft.app.accounting.trans.script.loan.rptchange;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.due.DueDateScript;
import com.amarsoft.app.accounting.cashflow.pmt.PMTScript;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

/**
 * 还款方式变更执行
 */
public class RPTChangeExecutor extends TransactionProcedure{

	public int run() throws Exception {
		String psType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "PSType");
		String businessDate = relativeObject.getString("BusinessDate");
		List<BusinessObject> rptList = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment,
				"Status='1' and PSType like :PSType and (SegToDate = null or SegToDate='' or SegToDate>:BusinessDate)" ,"PSType",psType,"BusinessDate",businessDate);
		List<BusinessObject> newRPTList = documentObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment,"Status='1' and PSType like :PSType ","PSType",psType);
		//取贷款原还款定义置为到期
		for (BusinessObject rptSegment : rptList) {
			rptSegment.setAttributeValue("SegToDate", rptSegment.getString("LastDueDate"));
			this.bomanager.updateBusinessObject(rptSegment);
		}
		String lastDueDate=(String)BusinessObjectHelper.getMaxValue(rptList, "LastDueDate");
		int currentPeriod=(Integer)BusinessObjectHelper.getMaxValue(rptList, "CurrentPeriod");
		String defaultDueDay = (String)BusinessObjectHelper.getMaxValue(rptList, "DefaultDueDay");
		
		if(businessDate.compareTo(lastDueDate) < 0) lastDueDate = businessDate;
		
		for (BusinessObject rptSegment : newRPTList) {
			// 新建对象并将变更对象值赋予新对象
			BusinessObject newRPTSegment = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment);
			newRPTSegment.setAttributes(rptSegment);
			newRPTSegment.generateKey(true);
			newRPTSegment.setAttributeValue("Status", "1");
			newRPTSegment.setAttributeValue("ObjectNo", relativeObject.getKeyString());
			newRPTSegment.setAttributeValue("ObjectType", relativeObject.getBizClassName());
			newRPTSegment.setAttributeValue("AmountCode", CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode"));
			if (StringX.isEmpty(newRPTSegment.getString("SegFromDate"))) {
				newRPTSegment.setAttributeValue("SegFromDate", lastDueDate);
				newRPTSegment.setAttributeValue("LastDueDate", lastDueDate);
			} else {
				newRPTSegment.setAttributeValue("LastDueDate", newRPTSegment.getString("SegFromDate"));
			}
			if(StringX.isEmpty(newRPTSegment.getString("SegToDate")))
				newRPTSegment.setAttributeValue("SegToDate","");
			newRPTSegment.setAttributeValue("SEGRPTBalance", newRPTSegment.getDouble("SEGRPTAmount"));
			if(StringX.isEmpty(newRPTSegment.getString("DefaultDueDay"))){
				newRPTSegment.setAttributeValue("DefaultDueDay", defaultDueDay);
			}

			relativeObject.appendBusinessObject(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, newRPTSegment);;

			PMTScript.getPMTScript(relativeObject, newRPTSegment, psType, bomanager).initRPTSegment();
			String nextDueDate = DueDateScript.getDueDateScript(relativeObject, newRPTSegment, psType).generateNextDueDate();

			PMTScript pmtScript = PMTScript.getPMTScript(relativeObject, newRPTSegment, psType,this.bomanager);
			while (nextDueDate.compareTo(businessDate) <= 0
					&& nextDueDate.compareTo(relativeObject.getString("MaturityDate")) < 0) {
				pmtScript.nextInstalment();
				nextDueDate = newRPTSegment.getString("NextDueDate");
			}
			newRPTSegment.setAttributeValue("NextDueDate", nextDueDate);
			newRPTSegment.setAttributeValue("FirstDueDate", nextDueDate);
			newRPTSegment.setAttributeValue("PSRestructureFlag", "1");//重算计划
			
			bomanager.updateBusinessObject(newRPTSegment);
		}

		return 1;
	}

}