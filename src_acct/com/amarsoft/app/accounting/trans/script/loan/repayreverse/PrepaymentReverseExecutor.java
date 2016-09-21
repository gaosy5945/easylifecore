package com.amarsoft.app.accounting.trans.script.loan.repayreverse;

import java.util.List;

import com.amarsoft.app.accounting.trans.script.common.executor.BookKeepExecutor;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.lang.StringX;

/**
 * 执行冲放款交易逻辑
 * 
 */
public final class PrepaymentReverseExecutor  extends BookKeepExecutor{
	
	public int run() throws Exception {
		BusinessObject oldDocumentObject = documentObject.getBusinessObject(documentObject.getString("DocumentType"));
		String flag;
		if("2".equals(oldDocumentObject.getString("PrepayType")))
		{
			flag = "1";
		}
		else
			flag = "2";
		// 取贷款的还款明细
		List<BusinessObject> paymengLogs = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_log,"TransSerialNo=:TransSerialNo and Status=:Status","TransSerialNo",documentObject.getKeyString(),"Status","1");
		for (BusinessObject paymentLog : paymengLogs) {
			BusinessObject paymentSchedule = relativeObject.getBusinessObjectByKey(paymentLog.getString("ObjectType"), paymentLog.getString("ObjectNo"));
			if(paymentSchedule == null) throw new ALSException("ED2014");
			
			List<BusinessObject> rptList=relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, 
					"Status='1' and PSType like :PSType", "PSType",paymentSchedule.getString("PSType"),"BusinessDate",relativeObject.getString("BusinessDate"));
			for(BusinessObject rpt:rptList){
				rpt.setAttributeValue("PSRestructureFlag", flag);
				rpt.setAttributeValue("CurrentPeriod", rpt.getInt("CurrentPeriod")-1);
				this.bomanager.updateBusinessObject(rpt);
			}
			
			bomanager.deleteBusinessObject(paymentSchedule);
			paymentLog.setAttributeValue("Status", "2");
			bomanager.updateBusinessObject(paymentLog);
		}
		
		//取计息信息
		List<BusinessObject> interestLogs = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.interest_log, "TransSerialNo=:TransSerialNo", "TransSerialNo",documentObject.getKeyString());
		for(BusinessObject interestLog:interestLogs)
		{
			String serialNo = interestLog.getString("SerialNo");
			String nextSerialNo = interestLog.getString("NextSerialNo");
			if(!StringX.isEmpty(nextSerialNo) && !nextSerialNo.equals(serialNo))
			{
				throw new ALSException("ED2015");
			}
			else{
				BusinessObject lastInterestLog = relativeObject.getBusinessObjectBySql(BUSINESSOBJECT_CONSTANTS.interest_log, "NextSerialNo=:NextSerialNo", "NextSerialNo",serialNo);
				if(lastInterestLog != null){
					lastInterestLog.setAttributeValue("NextSerialNo", "");
					bomanager.updateBusinessObject(lastInterestLog);
				}
				bomanager.deleteBusinessObject(interestLog);
			}
		}
		
		
		documentObject.setAttributeValue("TransStatus", "2");
		this.bomanager.updateBusinessObject(documentObject);
		return 1;
	}
}
