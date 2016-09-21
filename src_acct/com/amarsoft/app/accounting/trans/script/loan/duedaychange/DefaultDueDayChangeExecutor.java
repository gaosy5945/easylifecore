package com.amarsoft.app.accounting.trans.script.loan.duedaychange;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.due.DueDateScript;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.are.lang.StringX;

/**
 * 默认还款日变更执行
 */
public class DefaultDueDayChangeExecutor extends TransactionProcedure{

	public int run() throws Exception { 
		String newPayDate = documentObject.getString("DefaultDueDay");
		if (StringX.isEmpty(newPayDate)) {
			throw new Exception("没有新的还款日，请检查!");
		}
		if (newPayDate.length() < 2) {
			newPayDate = "0" + newPayDate;
		}
		String psType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "PSType");
		String businessDate = relativeObject.getString("BusinessDate");
		List<BusinessObject> rptList = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment,
				"Status='1' and PSType like :PSType and (SegToDate = null or SegToDate='' or SegToDate>:BusinessDate)" ,"PSType",psType,"BusinessDate",businessDate);
		
		if ( rptList ==null || rptList.size()<=0) {
			throw new Exception("未找到贷款{" + relativeObject.getKeyString() + "}有效的还款定义!");
		}

		for (BusinessObject rptSegment : rptList) {
			if (!("1".equals(rptSegment.getString("Status")))) {
				continue;
			}

			rptSegment.setAttributeValue("DefaultDueDay", newPayDate);

			String segFromDate = rptSegment.getString("SegFromDate");
			if ((!StringX.isEmpty(segFromDate))
					&& (segFromDate.compareTo(relativeObject.getString("BusinessDate")) > 0)) {
				continue;
			}

			String segToDate = rptSegment.getString("SegToDate");
			if ((!StringX.isEmpty(segToDate))
					&& (segToDate.compareTo(relativeObject.getString("BusinessDate")) < 0)) {
				continue;
			}
			String newNextDueDate =DueDateScript.getDueDateScript(relativeObject, rptSegment, psType).generateNextDueDate();
 			
 		
 			if(newNextDueDate.compareTo(transaction.getString("TransDate")) <= 0){
 				BusinessObject rptSegmentTemp = BusinessObject.createBusinessObject(); 
 				rptSegmentTemp.setAttributes(rptSegment);
 				int i = 0;
 				while(true){
 					rptSegmentTemp.setAttributeValue("LastDueDate", newNextDueDate);
 					newNextDueDate =DueDateScript.getDueDateScript(relativeObject, rptSegment, psType).generateNextDueDate();
 					++i;
 					if(newNextDueDate.compareTo(transaction.getString("TransDate")) > 0){
 						break;
 					}
 					if (i > 100) {
 						break;
 					}
 				}
 			}
			 

			if (newNextDueDate.compareTo(transaction.getString("TransDate")) > 0)
				rptSegment.setAttributeValue("nextDueDate", newNextDueDate);
			else {
				throw new Exception("交易日期不能大于变更后的下次还款日，请确认变更生效日期！");
			}
  			rptSegment.setAttributeValue("PSRestructureFlag", "1");//重算计划
			bomanager.updateBusinessObject(rptSegment);
		}

		return 1;
	}

}