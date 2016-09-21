package com.amarsoft.acct.accounting.web;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.trans.TransactionHelper;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;

/**
 * ��ǰ�������
 * 
 * @author Amarsoft�����Ŷ�
 * 
 */
public class AheadPaymentCalculate {
	private String transactionSerialNo;

	public String getTransactionSerialNo() {
		return transactionSerialNo;
	}

	public void setTransactionSerialNo(String transactionSerialNo) {
		this.transactionSerialNo = transactionSerialNo;
	}

	public BusinessObject run() throws Exception {
		if (transactionSerialNo == null || "".equals(transactionSerialNo))
			throw new Exception("������ˮΪ�գ�");
		BusinessObjectManager bomanager = BusinessObjectManager
				.createBusinessObjectManager();
		BusinessObject transaction = TransactionHelper.loadTransaction(
				transactionSerialNo, bomanager);
		BusinessObject loan = transaction.getBusinessObject(transaction
				.getString("RelativeObjectType"));
		String sTransDate = transaction.getString("TransDate");
		// ������Ч���ڲ����ڵ���Ľ��л��ս��׵Ĵ���
		if (sTransDate.compareTo(loan.getString("BusinessDate")) > 0) {
			/*
			 * String date_9090=DateFunctions.getRelativeDate(sTransDate,
			 * DateFunctions.TERM_UNIT_DAY, -1); LoanEOD_BOD
			 * changeLoanDateScript = (LoanEOD_BOD
			 * )TransactionConfig.getTransactionSript("9090",bom);
			 * BusinessObject eodTransaction =
			 * changeLoanDateScript.createTransaction
			 * ("9090",null,loan,"",date_9090);
			 * changeLoanDateScript.setTransaction(eodTransaction);
			 * changeLoanDateScript.run();
			 */
		}

		TransactionHelper.executeTransaction(transaction, bomanager);
		Double suspenseAmt = 0d;
		BusinessObject payment = transaction.getBusinessObject(transaction
				.getString("DocumentType"));
		String flag = payment.getString("PrePayAmtFlag");
		// ����������Ϊ����ʱ����ɽ����㷽ʽ
		if (flag.equals("1")) {
			Double prePayprincipalAmt = payment.getDouble("PREPAYPRINCIPALAMT");
			Double prePayamt = payment.getDouble("PREPAYAMT");
			Double payPrincipalAmt = payment.getDouble("PAYPRINCIPALAMT");
			if (prePayamt > prePayprincipalAmt + payPrincipalAmt)
				suspenseAmt = prePayamt - prePayprincipalAmt - payPrincipalAmt;
		} else {// ����������Ϊ����+��Ϣʱ����ɽ����㷽ʽ
			List<BusinessObject> psList = loan
					.getBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule);
			for (BusinessObject ps : psList) {
				Double amt = ps.getDouble("PRINCIPALBALANCE");
				if (amt < 0d)
					suspenseAmt -= amt;
			}
		}
		// ����������Ϊ����ʱ����ɽ����㷽ʽ

		payment.setAttributeValue("SUSPENSEAMT", suspenseAmt);
		bomanager.clear();

		bomanager.updateBusinessObject(payment);
		bomanager.updateDB();
		return payment;
	}
}
