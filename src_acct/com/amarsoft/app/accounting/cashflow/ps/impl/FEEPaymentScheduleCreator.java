package com.amarsoft.app.accounting.cashflow.ps.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.cashflow.pmt.PMTScript;
import com.amarsoft.app.accounting.cashflow.ps.PaymentScheduleCreator;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.interest.accrue.InterestAccruer;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * 通用的还款计划生成类
 * 
 */
public class FEEPaymentScheduleCreator extends PaymentScheduleCreator {
	public List<BusinessObject> createPaymentScheduleList(BusinessObject loan_T,int futurePeriod) throws Exception {
		ArrayList<BusinessObject> paymentScheduleList = new ArrayList<BusinessObject>();// 新还款计划
		
		BusinessObject loan = loan_T.clone();// 首先克隆
		String businessDate = loan.getString("BusinessDate");
		List<BusinessObject> oldPSList = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, "PayDate>:BusinessDate and FinishDate=null and PSType=:PSType and FixPayPrincipalAmt=0 and FixPayInstalmentAmt=0", 
				"BusinessDate",businessDate,"PSType",psType);
		loan.removeBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule, oldPSList);
		
		
		double loanBalance = loan.getDouble("BusinessSum");// 取贷款金额信息
		String nextDueDate = "";
		
		int x = 0;
		while (x < 1000 && loanBalance > 0d) {// 防止死循环
			x++;
			if (loanBalance <= 0d) break;
			
			List<BusinessObject> rptList=loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, 
					"(SegFromDate=null or SegFromDate='' or SegFromDate<= :BusinessDate) and (SegToDate=null or SegToDate='' or SegToDate > :BusinessDate) and PSType like :PSType and Status=:Status and NextDueDate>=:BusinessDate "
					, "PSType",psType,"Status","1","BusinessDate",loan.getString("BusinessDate"));
			String nextDueDateTmp = (String)BusinessObjectHelper.getMinValue(rptList, "NextDueDate");
			if(nextDueDate.equals(nextDueDateTmp)) break;//还款日期不在变化时，则认为已经计划结束
			nextDueDate = nextDueDateTmp;
			
			TreeSet<String> interestAmountCodes=new TreeSet<String>();
			String[] amountCodes=CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode").split(",");
			for(String amountCode:amountCodes){
				interestAmountCodes.add(amountCode);
			}
			double instalmentPrincipalAmt = 0d;//计算期供本金
			List<BusinessObject> currentRPTList = BusinessObjectHelper.getBusinessObjectsByAttributes(rptList, "NextDueDate",nextDueDate);
			int currentPeriod = 1;//当前期次
			String autoPayFlag = "";
			for (BusinessObject rptSegment : currentRPTList) {
				currentPeriod = Math.max(currentPeriod, rptSegment.getInt("CurrentPeriod"));
				PMTScript p = PMTScript.getPMTScript(loan, rptSegment, psType,bomanager);
				double d = Arith.round(p.getPrincipalAmount(), CashFlowHelper.getMoneyPrecision(loan));// 贷款本金
				instalmentPrincipalAmt += d;
				p.nextInstalment();// 进入下一个还款期次，并更新下次还款日及其他属性
				autoPayFlag = rptSegment.getString("AutoPayFlag");
			}
			loan.setAttributeValue("BusinessDate", nextDueDate);

			instalmentPrincipalAmt = Arith.round(instalmentPrincipalAmt, CashFlowHelper.getMoneyPrecision(loan));
			// 新建还款计划
			BusinessObject paymentSchedule = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.payment_schedule);
			paymentSchedule.generateKey();
			paymentSchedule.setAttributeValue("ObjectType", loan.getBizClassName());
			paymentSchedule.setAttributeValue("ObjectNo", loan.getString("SerialNo"));
			paymentSchedule.setAttributeValue("RelativeObjectType", loan.getBizClassName());
			paymentSchedule.setAttributeValue("RelativeObjectNo", loan.getString("SerialNo"));
			paymentSchedule.setAttributeValue("PeriodNo", currentPeriod);
			paymentSchedule.setAttributeValue("Currency", loan.getString("Currency"));
			paymentSchedule.setAttributeValue("PSType", psType);
			paymentSchedule.setAttributeValue("PayDate", nextDueDate);
			
			List<BusinessObject> parents = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, "PSType=:PSType and Status=:Status and PeriodNo=:PeriodNo", "PSType","1","Status","1","PeriodNo",currentPeriod);
			if(parents != null && !parents.isEmpty())
			{
				paymentSchedule.setAttributeValue("ParentSerialNo", parents.get(0).getKeyString());
			}
			
			
			for(String interestAmountCode:interestAmountCodes){//汇总利息金额
				String interestType = CashFlowConfig.getAmountCodeAttibute(interestAmountCode, "InterestType");
				String interestPayAttributeID=CashFlowConfig.getAmountCodeAttibute(interestAmountCode, "PS.PayAttributeID");
				if(StringX.isEmpty(interestType))continue;
				String interestObjectType=CashFlowConfig.getInterestAttribute(interestType, "InterestObjectType");
				if(!loan.getBizClassName().equals(interestObjectType)) continue;
				String[] rateTypes=CashFlowConfig.getRateTypes(interestType);
				double interestAmt = 0.0d;
				for(String rateType:rateTypes){
					List<InterestAccruer> interestAccruers = InterestAccruer.getInterestAccruer(loan,interestType,rateType,psType,null);
					for(InterestAccruer interestAccruer : interestAccruers)
					{
						if(interestAccruer.getInterestObjects().contains(loan))
						{
							BusinessObject interestLog = interestAccruer.settleInterest(loan,nextDueDate);
							interestLog.setAttributeValue("SettleDate", nextDueDate);
							interestAmt = interestLog.getDouble("InterestAmt")+interestLog.getDouble("InterestSuspense")+interestAmt;
							interestLog.setAttributeValue("InterestSuspense", 0.0d);
						}
					}
				}
				
				paymentSchedule.setAttributeValue(interestPayAttributeID, Arith.round(interestAmt,CashFlowHelper.getMoneyPrecision(loan)));
			}
			
			paymentSchedule.setAttributeValue("AutoPayFlag", (StringX.isEmpty(autoPayFlag) ? CashFlowConfig.getPaymentScheduleAttribute(psType, "AutoPayFlag") : autoPayFlag));
			paymentSchedule.setAttributeValue("PayItemCode", CashFlowConfig.getPaymentScheduleAttribute(psType, "PayItemCode"));
			paymentSchedule.setAttributeValue("Direction", CashFlowConfig.getPaymentScheduleAttribute(psType, "Direction"));
			paymentSchedule.setAttributeValue("Status", "1");
			
			paymentScheduleList.add(paymentSchedule);
			
			loan.setAttributeValue("CurrentPeriodNo", currentPeriod);
			loanBalance = Arith.round(loanBalance - instalmentPrincipalAmt, CashFlowHelper.getMoneyPrecision(loan));
			
			if(futurePeriod > 0 && paymentScheduleList.size() >= futurePeriod) break; //根据配置要求生成指定未来几期还款计划
			
		}
		loan.appendBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule, paymentScheduleList);
		
		return paymentScheduleList;
	}

}
