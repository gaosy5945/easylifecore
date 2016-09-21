package com.amarsoft.app.als.afterloan.invoice;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.DBKeyHelp;

public class InvoiceRelative {

	private String SerialNo;
	private String ObjectNo;
	private String ObjectType;
	private String InvoiceContent;
	private String Sum;
	
	public String getSum() {
		return Sum;
	}

	public void setSum(String sum) {
		Sum = sum;
	}

	public String getInvoiceContent() {
		return InvoiceContent;
	}

	public void setInvoiceContent(String InvoiceContent) {
		InvoiceContent = InvoiceContent;
	}

	public String getObjectNo() {
		return ObjectNo;
	}

	public void setObjectNo(String objectNo) {
		ObjectNo = objectNo;
	}

	public String getObjectType() {
		return ObjectType;
	}

	public void setObjectType(String objectType) {
		ObjectType = objectType;
	}

	public String getSerialNo() {
		return SerialNo;
	}

	public void setSerialNo(String serialNo) {
		SerialNo = serialNo;
	}
	
	public String InvoiceRelative(JBOTransaction tx) throws Exception{	
		BizObjectManager bmAIR = JBOFactory.getBizObjectManager("jbo.acct.ACCT_INVOICE_RELATIVE");
		tx.join(bmAIR);
		BizObject bqAIR = bmAIR.newObject();
		bqAIR.setAttributeValue("InvoiceSerialNo", SerialNo);
		bqAIR.setAttributeValue("ObjectType", ObjectType);
		bqAIR.setAttributeValue("ObjectNo", ObjectNo);
		bmAIR.saveObject(bqAIR);
		return "success";
	}
	
	public String InvoiceDetailRelative(JBOTransaction tx) throws Exception{	
		
		
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.acct.ACCT_INVOICE_DETAIL", tx);
		BizObjectQuery boq = bom.createQuery("select serialno,InvoiceAmount from O WHERE O.invoiceserialno='"+SerialNo+"' and O.InvoiceContent='"+InvoiceContent+"'");
		BizObject bo = boq.getSingleResult(false);
		String AIDSerialNo = "";
		double oldsum = 0.0;
		if(bo != null){
			AIDSerialNo = bo.getAttribute("serialno").toString();
			oldsum = Double.parseDouble(bo.getAttribute("InvoiceAmount").toString());
		}
		if("".equals(AIDSerialNo)){
			BizObject bqAID = bom.newObject();
			bqAID.setAttributeValue("InvoiceSerialNo", SerialNo);
			bqAID.setAttributeValue("InvoiceContent", InvoiceContent);
			bqAID.setAttributeValue("InvoiceNumber", "1");
			bqAID.setAttributeValue("InvoiceUnit", "01");
			bqAID.setAttributeValue("InvoiceUnitPrice", Sum);
			bqAID.setAttributeValue("InvoiceAmount", Sum);
			bqAID.setAttributeValue("TaxRate", "0");
			bqAID.setAttributeValue("TaxAmount", "0");
			bom.saveObject(bqAID);
		}else{
			BizObject boAID = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", AIDSerialNo).getSingleResult(true);
			boAID.setAttributeValue("InvoiceUnitPrice", Double.parseDouble(Sum)+oldsum);
			boAID.setAttributeValue("InvoiceAmount", Double.parseDouble(Sum)+oldsum);
			bom.saveObject(boAID);
		}
		
		
		return "success";
	}
	
	public String GetRelativeSerialNo(JBOTransaction tx) throws JBOException{
		String sReturn = "";
	
		BizObjectManager  bmAIR = JBOFactory.getFactory().getManager("jbo.acct.ACCT_INVOICE_RELATIVE");
		BizObject boAIR = bmAIR.createQuery("select APS.ObjectNo from O,jbo.acct.ACCT_PAYMENT_SCHEDULE APS where O.ObjectType='jbo.acct.ACCT_PAYMENT_SCHEDULE' and O.InvoiceSerialNo=:InvoiceSerialNo and O.ObjectNo=APS.SerialNo and APS.ObjectType='jbo.acct.ACCT_LOAN' ").setParameter("InvoiceSerialNo", SerialNo).getSingleResult(false);
		String ALSerialNo = boAIR.getAttribute("ObjectNo").getString();
		
		BizObjectManager  bmBC = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
		BizObject boBC = bmBC.createQuery("select O.SerialNo,O.ApplySerialNo from O where O.SerialNo in (select AL.ContractSerialNo from jbo.acct.ACCT_LOAN AL where AL.SerialNo=:SerialNo)").setParameter("SerialNo", ALSerialNo).getSingleResult(false);
		String ContractSerialNo = boBC.getAttribute("SerialNo").getString();
		String ApplySerialNo = boBC.getAttribute("ApplySerialNo").getString();
		sReturn = ALSerialNo + "@" + ApplySerialNo + "@" + ContractSerialNo;
		return sReturn;
	}
}
