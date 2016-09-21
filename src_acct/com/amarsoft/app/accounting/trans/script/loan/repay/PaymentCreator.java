package com.amarsoft.app.accounting.trans.script.loan.repay;

import java.util.List;

import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.accounting.util.LoanHelper;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

/**
 * 还款信息交易单据处理默认值
 * @author Amarsoft核算团队
 */
public final class PaymentCreator extends TransactionProcedure {
	
	public int run() throws Exception {
		BusinessObject paymentBill = transaction.getBusinessObject(transaction.getString("DocumentType"));
		BusinessObject loan = transaction.getBusinessObject(transaction.getString("RelativeObjectType"));
		paymentBill.setAttributeValue("ObjectNo", loan.getString("SerialNo"));
		paymentBill.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTANTS.loan);
		paymentBill.setAttributeValue("Currency", loan.getString("Currency"));
		paymentBill.setAttributeValue("AccountingOrgID", loan.getString("AccountingOrgID"));
		
		
		List<BusinessObject> subledgers = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, "RelativeObjectType=:RelativeObjectType and RelativeObjectNo=:RelativeObjectNo and Status=:Status", "RelativeObjectType",relativeObject.getBizClassName(),"RelativeObjectNo",relativeObject.getKeyString(),"Status","1");
		double normalBalance = LoanHelper.getSubledgerBalance(subledgers, "AccountCodeNo","Customer01");
		double overdueBalance = LoanHelper.getSubledgerBalance(subledgers, "AccountCodeNo","Customer02");
		double accrueInterestBalance = LoanHelper.getSubledgerBalance(subledgers, "AccountCodeNo","Customer11");//计提利息
		double interestBalance = LoanHelper.getSubledgerBalance(subledgers, "AccountCodeNo","Customer12");//欠还利息
		double principalPenaltyBalance = LoanHelper.getSubledgerBalance(subledgers, "AccountCodeNo","Customer13");//本金罚息
		double interestPenaltyBalance = LoanHelper.getSubledgerBalance(subledgers, "AccountCodeNo","Customer14");//利息罚息
		
		if(paymentBill.getDouble("PayAmt") == 0) paymentBill.setAttributeValue("PayAmt", normalBalance+overdueBalance+accrueInterestBalance+interestBalance+principalPenaltyBalance+interestPenaltyBalance);
		if(paymentBill.getDouble("ActualPayAmt") == 0) paymentBill.setAttributeValue("ActualPayAmt", 0.0d);
		if(paymentBill.getDouble("PayPrincipalAmt")==0d)	paymentBill.setAttributeValue("PayPrincipalAmt", overdueBalance);
		if(paymentBill.getDouble("ActualPayPrincipalAmt")==0d)	paymentBill.setAttributeValue("ActualPayPrincipalAmt", 0d);
		if(paymentBill.getDouble("PayInterestAmt")==0d)	paymentBill.setAttributeValue("PayInterestAmt", interestBalance);
		if(paymentBill.getDouble("ActualPayInterestAmt")==0d)	paymentBill.setAttributeValue("ActualPayInterestAmt", 0d);
		if(paymentBill.getDouble("PayPrincipalPenaltyAmt")==0d)	paymentBill.setAttributeValue("PayPrincipalPenaltyAmt", principalPenaltyBalance);
		if(paymentBill.getDouble("ActualPayPrincipalPenaltyAmt")==0d)	paymentBill.setAttributeValue("ActualPayPrincipalPenaltyAmt", 0d);
		if(paymentBill.getDouble("PayInterestPenaltyAmt")==0d)	paymentBill.setAttributeValue("PayInterestPenaltyAmt", interestPenaltyBalance);
		if(paymentBill.getDouble("ActualPayInterestPenaltyAmt")==0d)	paymentBill.setAttributeValue("ActualPayInterestPenaltyAmt", 0d);
		
		if(StringX.isEmpty(paymentBill.getString("PayRuleType"))) 
			paymentBill.setAttributeValue("PayRuleType", TransactionConfig.getScriptConfig(transactionCode, scriptID, "PayRuleType"));//默认还款规则
		
		
		//还款账户设置
		List<BusinessObject> accounts = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.business_account, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status and AccountIndicator=:AccountIndicator order by PriorityFlag", 
										"ObjectType",BUSINESSOBJECT_CONSTANTS.loan,
										"ObjectNo",loan.getKeyString(),
										"Status","1","AccountIndicator","01");
		if(accounts != null && !accounts.isEmpty())
		{
			paymentBill.setAttributeValue("AutoPayFlag", "1");
			paymentBill.setAttributeValue("PayAccountFlag", accounts.get(0).getString("AccountFlag"));
			paymentBill.setAttributeValue("PayAccountType", accounts.get(0).getString("AccountType"));
			paymentBill.setAttributeValue("PayAccountNo", accounts.get(0).getString("AccountNo"));
			paymentBill.setAttributeValue("PayAccountName", accounts.get(0).getString("AccountName"));
			paymentBill.setAttributeValue("PayAccountCurrency", accounts.get(0).getString("AccountCurrency"));
			paymentBill.setAttributeValue("PayAccountOrgID", accounts.get(0).getString("AccountOrgID"));
		}
		
		return 1;
	}
}
