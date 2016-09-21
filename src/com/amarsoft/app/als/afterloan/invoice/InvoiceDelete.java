package com.amarsoft.app.als.afterloan.invoice;

import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class InvoiceDelete {

	private String SerialNo;

	public String getSerialNo() {
		return SerialNo;
	}

	public void setSerialNo(String serialNo) {
		SerialNo = serialNo;
	}
	
	public String InvoiceDelete(JBOTransaction tx) throws JBOException{
		BizObjectManager bmAID = JBOFactory.getBizObjectManager("jbo.acct.ACCT_INVOICE_DETAIL");
		tx.join(bmAID);
		BizObjectQuery bqAID = bmAID.createQuery("delete from O where invoiceSerialNo = :invoiceSerialNo");
		bqAID.setParameter("invoiceSerialNo", SerialNo);
		bqAID.executeUpdate();
		
		BizObjectManager bmAIR = JBOFactory.getBizObjectManager("jbo.acct.ACCT_INVOICE_RELATIVE");
		tx.join(bmAIR);
		BizObjectQuery bqAIR = bmAIR.createQuery("delete from O where invoiceSerialNo = :invoiceSerialNo");
		bqAIR.setParameter("invoiceSerialNo", SerialNo);
		bqAIR.executeUpdate();
		return "success";
	}
}
