package com.amarsoft.app.accounting.trans.script.loan.repay.prepay;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.cashflow.due.DueDateScript;
import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.interest.accrue.InterestAccruer;
import com.amarsoft.app.base.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.json.JSONElement;
import com.amarsoft.are.util.json.JSONObject;

public abstract class PrepayScript {
	protected BusinessObject transaction;
	protected String psType;
	protected BusinessObjectManager bomanager;

	public void setTransaction(BusinessObject transaction) {
		this.transaction = transaction;
	}
	
	public void setPsType(String psType) {
		this.psType = psType;
	}

	public void setBomanager(BusinessObjectManager bomanager) {
		this.bomanager = bomanager;
	}

	public abstract int run() throws Exception;
	
	/**
	 * 获取提前还款当前贷款余额
	 * @return
	 * @throws Exception
	 */
	protected double getPrepayPrincipal_All() throws Exception {
		String NormalPrincipalBalanceAccountCodeNo=CashFlowConfig.getAmountCodeAttibute(CashFlowConfig.getPaymentScheduleAttribute(psType, "PrincipalAmountCode"),"NormalBalanceAccountCode");
		BusinessObject subledger = transaction.getBusinessObject(BUSINESSOBJECT_CONSTANTS.loan).getBusinessObjectBySql(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, "AccountCodeNo=:AccountCodeNo and Status=:Status", "AccountCodeNo",NormalPrincipalBalanceAccountCodeNo,"Status","1");
		double normalBalance=AccountCodeConfig.getSubledgerBalance(subledger,AccountCodeConfig.Balance_DateFlag_CurrentDay);
		return normalBalance;
	}
	
	
	/**
	 * 获取提前还款还款金额类型为本金的本金金额
	 * @return
	 * @throws Exception
	 */
	protected double getPrepayPrincipal_P() throws Exception {
		String NormalPrincipalBalanceAccountCodeNo=CashFlowConfig.getAmountCodeAttibute(CashFlowConfig.getPaymentScheduleAttribute(psType, "PrincipalAmountCode"),"NormalBalanceAccountCode");
		BusinessObject subledger = transaction.getBusinessObject(BUSINESSOBJECT_CONSTANTS.loan).getBusinessObjectBySql(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, "AccountCodeNo=:AccountCodeNo and Status=:Status", "AccountCodeNo",NormalPrincipalBalanceAccountCodeNo,"Status","1");
		double normalBalance=AccountCodeConfig.getSubledgerBalance(subledger,AccountCodeConfig.Balance_DateFlag_CurrentDay);
		double d= transaction.getBusinessObject(transaction.getString("DocumentType")).getDouble("PrepayAmt");
		
		if(normalBalance<d) return normalBalance;
		else return d;
	}
	
	/**
	 * 获取提前还款还款金额类型为本金+利息的本金金额，按照提前还款金额和传入日期计算利息
	 * @return
	 * @throws Exception
	 */
	protected double getPrepayPrincipal_PI(String settleDate) throws Exception {
		double prepayAmt= transaction.getBusinessObject(transaction.getString("DocumentType")).getDouble("PrepayAmt");
		double prepayPrincipal=0d;
		BusinessObject loan = transaction.getBusinessObject(BUSINESSOBJECT_CONSTANTS.loan);
		double interestBase = 0d;// 周期利率
		String[] interestAmountCodes= CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode").split(",");
		for(String interestAmountCode:interestAmountCodes){//汇总利息金额
			String interestType = CashFlowConfig.getAmountCodeAttibute(interestAmountCode, "InterestType");
			if(StringX.isEmpty(interestType))continue;
			String[] rateTypes=CashFlowConfig.getRateTypes(interestType);
			for(String rateType:rateTypes){
				List<InterestAccruer> interestAccruers = InterestAccruer.getInterestAccruer(loan,interestType,rateType,psType,bomanager);
				for(InterestAccruer interestAccruer : interestAccruers)
				{
					if(interestAccruer.getInterestObjects().contains(loan))
					{
						interestBase+=interestAccruer.getInterestRate(loan, interestAccruer.getLastSettleDate(loan), settleDate);
					}
				}
			}
		}
		
		prepayPrincipal=prepayAmt/(1+interestBase);
		double prepayInterest = Arith.round(prepayPrincipal*interestBase,CashFlowHelper.getMoneyPrecision(loan));
		prepayPrincipal = Arith.round(prepayAmt - prepayInterest,CashFlowHelper.getMoneyPrecision(loan));
		return prepayPrincipal;
	}
	
	/**
	 * 获取提前还款还款金额类型为本金+利息的本金金额，按照余额和传入日期计算利息
	 * @return
	 * @throws Exception
	 */
	protected double getPrepayPrincipal_PB(String settleDate) throws Exception {
		double prepayAmt= transaction.getBusinessObject(transaction.getString("DocumentType")).getDouble("PrepayAmt");
		double prepayPrincipal=this.getPrepayPrincipal_All();
		BusinessObject loan = transaction.getBusinessObject(BUSINESSOBJECT_CONSTANTS.loan);
		double interestBase = 0d;// 周期利率
		String[] interestAmountCodes= CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode").split(",");
		for(String interestAmountCode:interestAmountCodes){//汇总利息金额
			String interestType = CashFlowConfig.getAmountCodeAttibute(interestAmountCode, "InterestType");
			if(StringX.isEmpty(interestType))continue;
			String[] rateTypes=CashFlowConfig.getRateTypes(interestType);
			for(String rateType:rateTypes){
				List<InterestAccruer> interestAccruers = InterestAccruer.getInterestAccruer(loan,interestType,rateType,psType,bomanager);
				for(InterestAccruer interestAccruer : interestAccruers)
				{
					if(interestAccruer.getInterestObjects().contains(loan))
					{
						interestBase+=interestAccruer.getInterestRate(loan, interestAccruer.getLastSettleDate(loan), settleDate);
					}
				}
			}
		}
		
		double prepayInterest = Arith.round(prepayPrincipal*interestBase,CashFlowHelper.getMoneyPrecision(loan));
		if(prepayAmt < prepayInterest) throw new ALSException("ED2013");
		return Arith.round(prepayAmt - prepayInterest,CashFlowHelper.getMoneyPrecision(loan));
	}
	
	
	/**
	 * 获取提前还款计息截止日期为贷款下次还款日
	 * @return
	 * @throws Exception
	 */
	protected String getSettleDate_NextDueDate() throws Exception {
		return DueDateScript.getNextDueDate(transaction.getBusinessObject(BUSINESSOBJECT_CONSTANTS.loan),psType);
	}
	
	/**
	 * 获取提前还款计息截止日期为当前日期
	 * @return
	 * @throws Exception
	 */
	protected String getSettleDate_TransDate() throws Exception {
		return transaction.getString("TransDate");
	}
	
	/**
	 * 计算提前还款相关利息
	 * @param settleDate
	 * @param prepayPrincipalAmt
	 * @throws Exception
	 */
	public void settleInterest(String settleDate,double prepayPrincipalAmt,double baseAmount) throws Exception {
		BusinessObject loan=transaction.getBusinessObject(BUSINESSOBJECT_CONSTANTS.loan);
		BusinessObject documentObject = transaction.getBusinessObject(transaction.getString("DocumentType"));
		
		String[] amountCodeArray= CashFlowConfig.getPaymentScheduleAttribute(psType,"AmountCode").split(",");
		for(String amountCode:amountCodeArray){
			String interestType=CashFlowConfig.getAmountCodeAttibute(amountCode, "InterestType");
			if(StringX.isEmpty(interestType)) continue;
			String[] rateTypes=CashFlowConfig.getRateTypes(interestType);
			double interestAmt=0d;
			for(String rateType:rateTypes){
				List<InterestAccruer> interestAccruers = InterestAccruer.getInterestAccruer(loan,interestType,rateType,psType,bomanager);
				for(InterestAccruer interestAccruer : interestAccruers)
				{
					if(interestAccruer.getInterestObjects().contains(loan))
					{
						BusinessObject interestLog = interestAccruer.settleInterest(loan,baseAmount,settleDate);
						interestLog.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));
						this.bomanager.updateBusinessObject(interestLog);
						interestAmt+=interestLog.getDouble("InterestAmt")+interestLog.getDouble("InterestSuspense");
						interestLog.setAttributeValue("InterestSuspense", 0.0d);
					}
				}
			}
			String prepayInteAttributeID=CashFlowConfig.getAmountCodeAttibute(amountCode, "TP.PrepayAttributeID");
			documentObject.setAttributeValue(prepayInteAttributeID, Arith.round(interestAmt,CashFlowHelper.getMoneyPrecision(loan)));
		}
		
		String[] principalAmountCodeArray = CashFlowConfig.getPaymentScheduleAttribute(psType, "PrincipalAmountCode").split(",");
		for(String principalAmountCode:principalAmountCodeArray)
		{
			String prepayInteAttributeID=CashFlowConfig.getAmountCodeAttibute(principalAmountCode, "TP.PrepayAttributeID");
			documentObject.setAttributeValue(prepayInteAttributeID,  Arith.round(prepayPrincipalAmt,CashFlowHelper.getMoneyPrecision(loan)));
		}
	}

	/**
	 * 创建一期提前还款计划，并创建对应的还款日志
	 * 
	 * @throws Exception
	 */
	protected void createPaymentSchedule() throws Exception {
		BusinessObject loan=transaction.getBusinessObject(BUSINESSOBJECT_CONSTANTS.loan);
		BusinessObject documentObject = transaction.getBusinessObject(transaction.getString("DocumentType"));
		String businessDate = loan.getString("BusinessDate");
		
		BusinessObject paymentSchedule = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.payment_schedule);
		bomanager.updateBusinessObject(paymentSchedule);
		paymentSchedule.setAttributeValue("ObjectType", loan.getBizClassName());
		paymentSchedule.setAttributeValue("ObjectNo", loan.getKeyString());
		paymentSchedule.setAttributeValue("RelativeObjectType", loan.getBizClassName());
		paymentSchedule.setAttributeValue("RelativeObjectNo", loan.getKeyString());
		paymentSchedule.setAttributeValue("Currency", loan.getString("Currency"));
		paymentSchedule.setAttributeValue("PayDate", businessDate);
		paymentSchedule.setAttributeValue("InteDate", businessDate);
		paymentSchedule.setAttributeValue("PSType", psType);
		
		int currentPeriod = 1;
		List<BusinessObject> rptList = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, "Status='1' and PSType like :PSType ","PSType",psType);
		for(BusinessObject rptSegment:rptList)
		{
			currentPeriod = Math.max(currentPeriod, rptSegment.getInt("CurrentPeriod"));
		}
		paymentSchedule.setAttributeValue("PeriodNo", currentPeriod);
		for(BusinessObject rptSegment:rptList)
		{
			rptSegment.setAttributeValue("CurrentPeriod", currentPeriod+1);
			bomanager.updateBusinessObject(rptSegment);
		}

		String[] amountCodeArray=CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode").split(",");
		for(String amountCode:amountCodeArray){
			String payAttributeID=CashFlowConfig.getAmountCodeAttibute(amountCode, "PS.PayAttributeID");
			String prepayAttributeID=CashFlowConfig.getAmountCodeAttibute(amountCode, "PS.ActualPayAttributeID");
			String TP_PrepayAttributeID=CashFlowConfig.getAmountCodeAttibute(amountCode, "TP.PrepayAttributeID");
			paymentSchedule.setAttributeValue(payAttributeID, documentObject.getDouble(TP_PrepayAttributeID));
			paymentSchedule.setAttributeValue(prepayAttributeID, documentObject.getDouble(TP_PrepayAttributeID));
		}
		
		//设置剩余本金字段
		String NormalPrincipalBalanceAccountCodeNo=CashFlowConfig.getAmountCodeAttibute(CashFlowConfig.getPaymentScheduleAttribute(psType, "PrincipalAmountCode"),"NormalBalanceAccountCode");
		BusinessObject subLedger=loan.getBusinessObjectBySql(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, "AccountCodeNo=:AccountCodeNo", "AccountCodeNo",NormalPrincipalBalanceAccountCodeNo);
		double normalbalance = AccountCodeConfig.getSubledgerBalance(subLedger,AccountCodeConfig.Balance_DateFlag_CurrentDay);
		paymentSchedule.setAttributeValue("PrincipalBalance",
				Arith.round(normalbalance - documentObject.getDouble("PrePayPrincipalAmt"),ACCOUNT_CONSTANTS.Number_Precision_Money));
		paymentSchedule.setAttributeValue("FinishDate", businessDate);
		loan.appendBusinessObject(BUSINESSOBJECT_CONSTANTS.payment_schedule, paymentSchedule);
		paymentSchedule.setAttributeValue("AutoPayFlag", CashFlowConfig.getPaymentScheduleAttribute(psType, "AutoPayFlag"));
		paymentSchedule.setAttributeValue("PayItemCode", CashFlowConfig.getPaymentScheduleAttribute(psType, "PayItemCode"));
		paymentSchedule.setAttributeValue("Direction", CashFlowConfig.getPaymentScheduleAttribute(psType, "Direction"));
		paymentSchedule.setAttributeValue("Status", "1");
		bomanager.updateBusinessObject(paymentSchedule);

		BusinessObject paymentLog = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.payment_log);
		bomanager.updateBusinessObject(paymentLog);
		loan.appendBusinessObject(BUSINESSOBJECT_CONSTANTS.payment_log, paymentLog);
		paymentLog.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));
		paymentLog.setAttributeValue("RelativeObjectType", paymentSchedule.getString("ObjectType"));
		paymentLog.setAttributeValue("RelativeObjectNo", paymentSchedule.getString("ObjectNo"));
		paymentLog.setAttributeValue("ObjectType", paymentSchedule.getBizClassName());
		paymentLog.setAttributeValue("ObjectNo", paymentSchedule.getKeyString());
		paymentLog.setAttributeValue("PSType", paymentSchedule.getString("PSType"));
		paymentLog.setAttributeValue("Currency", loan.getString("Currency"));
		paymentLog.setAttributeValue("Status", "1");
		paymentLog.setAttributeValue("PayDate", paymentSchedule.getString("PayDate"));
		paymentLog.setAttributeValue("ActualPayDate", businessDate);
		for(String amountCode:amountCodeArray){
			String payAttributeID=CashFlowConfig.getAmountCodeAttibute(amountCode, "PL.PayAttributeID");
			String actualPayAttributeID=CashFlowConfig.getAmountCodeAttibute(amountCode, "PL.ActualPayAttributeID");
			String TP_PrepayAttributeID=CashFlowConfig.getAmountCodeAttibute(amountCode, "TP.PrepayAttributeID");
			paymentLog.setAttributeValue(payAttributeID, documentObject.getDouble(TP_PrepayAttributeID));
			paymentLog.setAttributeValue(actualPayAttributeID, documentObject.getDouble(TP_PrepayAttributeID));
		}
	}

	/**
	 * 设置 只算还款计划计算期供和还款计划标示
	 * @throws Exception
	 */
	protected void setPSRestructureFlag(String flag) throws Exception {
		BusinessObject loan = transaction.getBusinessObject(BUSINESSOBJECT_CONSTANTS.loan);
		List<BusinessObject> rptList=loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, 
				"Status='1' and PSType like :PSType", "PSType",psType,"BusinessDate",loan.getString("BusinessDate"));
		for(BusinessObject rpt:rptList){
			rpt.setAttributeValue("PSRestructureFlag", flag);
			this.bomanager.updateBusinessObject(rpt);
		}
	}
	
	
	/**
	 * 记录日志
	 * @throws JBOException
	 */
	protected void createJSONLog() throws JBOException{//记录日志，用于冲账时恢复原始状态使用，提前还款不在改变上次还款日和下次还款日，后续上次计息日期都采用interestlog中数据
		JSONObject jsonLog = JSONObject.createObject();
		jsonLog.appendElement(JSONElement.valueOf("PSType", psType));
		jsonLog.appendElement(JSONElement.valueOf("OldMaturityDate", transaction.getBusinessObject(BUSINESSOBJECT_CONSTANTS.loan).getString("MaturityDate")));
		transaction.getBusinessObject(transaction.getString("DocumentType")).setAttributeValue("Log", jsonLog.toString());
	}
}
