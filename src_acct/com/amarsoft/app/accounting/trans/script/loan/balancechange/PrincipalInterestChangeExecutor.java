package com.amarsoft.app.accounting.trans.script.loan.balancechange;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;
/**
 * 本息调整
 * */
public class PrincipalInterestChangeExecutor extends TransactionProcedure{

	@Override
	public int run() throws Exception {
		
		if(!StringX.isEmpty(documentObject.getString("ObjectNo")))
		{
		
			//取利息调整对应的还款计划
			BusinessObject paymentSchedule = relativeObject.getBusinessObjectByKey(BUSINESSOBJECT_CONSTANTS.payment_schedule, documentObject.getString("ObjectNo"));
			if(paymentSchedule == null) throw new Exception("还款计划未找到，请检查！");
			//获取贷款交易日期
			String businessDate = relativeObject.getString("BusinessDate");
			//检查期供本金
			double waivePrincipalAmt = documentObject.getDouble("WaivePrincipalAmt");
			double principalAmt = paymentSchedule.getDouble("PayPrincipalAmt")-paymentSchedule.getDouble("ActualPayPrincipalAmt");
			if(waivePrincipalAmt+principalAmt < 0) throw new Exception("减免期供本金金额不能超过未还本金金额，请检查！");
			if(businessDate.compareTo(paymentSchedule.getString("PayDate")) >= 0 && waivePrincipalAmt >  paymentSchedule.getDouble("PrincipalBalance")+paymentSchedule.getDouble("WaivePrinaipalAmt"))
				throw new Exception("增加本金金额不能超过剩余本金余额（不包含本期次）！");
			//检查期供利息
			double waiveInteAmt = documentObject.getDouble("WaiveInterestAmt");
			double inteAmt = paymentSchedule.getDouble("PayInterestAmt")-paymentSchedule.getDouble("ActualPayInterestAmt");
			if(waiveInteAmt+inteAmt < 0) throw new Exception("减免期供利息金额不能超过未还期供利息金额，请检查！");
			//检查逾期罚息
			double waiveFineAmt = documentObject.getDouble("WaivePrincipalPenaltyAmt");
			double fineAmt = paymentSchedule.getDouble("PayPrincipalPenaltyAmt")-paymentSchedule.getDouble("ActualPayPrincipalPenaltyAmt");
			if(waiveFineAmt+fineAmt < 0) throw new Exception("减免逾期罚息金额不能超过未还逾期罚息金额，请检查！");
			//检查逾期复利
			double waiveCompdInteAmt = documentObject.getDouble("WaiveInterestPenaltyAmt");
			double compdInteAmt = paymentSchedule.getDouble("PayInterestPenaltyAmt")-paymentSchedule.getDouble("ActualPayInterestPenaltyAmt");
			if(waiveCompdInteAmt+compdInteAmt < 0) throw new Exception("减免逾期复利金额不能超过未还逾期复利金额，请检查！");
			
			paymentSchedule.setAttributeValue("PayPrincipalAmt", Arith.round(paymentSchedule.getDouble("PayPrincipalAmt")+waivePrincipalAmt,2));
			paymentSchedule.setAttributeValue("PayInterestAmt", Arith.round(paymentSchedule.getDouble("PayInterestAmt")+waiveInteAmt,2));
			paymentSchedule.setAttributeValue("PayPrincipalPenaltyAmt", Arith.round(paymentSchedule.getDouble("PayPrincipalPenaltyAmt")+waiveFineAmt,2));
			paymentSchedule.setAttributeValue("PayInterestPenaltyAmt", Arith.round(paymentSchedule.getDouble("PayInterestPenaltyAmt")+waiveCompdInteAmt,2));
			paymentSchedule.setAttributeValue("WaivePrincipalAmt", Arith.round(paymentSchedule.getDouble("WaivePrincipalAmt")+waivePrincipalAmt,2));
			paymentSchedule.setAttributeValue("WaiveInterestAmt",  Arith.round(paymentSchedule.getDouble("WaiveInterestAmt")+waiveInteAmt,2));
			paymentSchedule.setAttributeValue("WaivePrincipalPenaltyAmt",  Arith.round(paymentSchedule.getDouble("WaivePrincipalPenaltyAmt")+waiveFineAmt,2));
			paymentSchedule.setAttributeValue("WaiveInterestPenaltyAmt",  Arith.round(paymentSchedule.getDouble("WaiveInterestPenaltyAmt")+waiveCompdInteAmt,2));
			bomanager.updateBusinessObject(paymentSchedule);
			
			//调整未来还款计划则重新生成还款计划
			if(Math.abs(waivePrincipalAmt) >= 0.0d)
			{
				//设置重新生成期供和还款计划
				List<BusinessObject> rptList = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, "Status='1'");
				for(BusinessObject rptSegment:rptList)
				{
					rptSegment.setAttributeValue("PSRestructureFlag", "2");
				}
			}
		}
		else
		{
			
		}
		
		
		return 1;
	}
	
}
