package com.amarsoft.app.als.credit.common.action;

import java.util.Map;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.als.dataimport.xlsimport.AbstractExcelImport;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.trans.TransactionHelper;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.util.DateHelper;
/**
 * 描述：还款批量导入
 * @author fengcr
 */
public class CreditPaymentImportAction extends AbstractExcelImport {
	private BusinessObjectManager bomanager;
	private int cnt = 0;
	private double sum=0.0d;
	private boolean rollBack = false;
	
	public void start(JBOTransaction tx) {
		bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		
		try{
			
			BizObjectManager bbm = JBOFactory.getBizObjectManager("jbo.acct.ACCT_TRANS_PAYMENT");
			if(tx!=null)tx.join(bbm);
			BizObjectQuery boq = bbm.createQuery("delete from O where SerialNo in(select AT.DocumentNo from jbo.acct.ACCT_TRANSACTION AT where AT.ParentTransSerialNo=:ParentTransSerialNo)");
			boq.setParameter("ParentTransSerialNo", getCurPage().getAttribute("ParentTransSerialNo"));
			boq.executeUpdate();
			
			bbm = JBOFactory.getBizObjectManager("jbo.acct.ACCT_TRANSACTION");
			if(tx!=null)tx.join(bbm);
			boq = bbm.createQuery("delete from O where ParentTransSerialNo=:ParentTransSerialNo");
			boq.setParameter("ParentTransSerialNo", getCurPage().getAttribute("ParentTransSerialNo"));
			boq.executeUpdate();
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}

	public boolean process(Map<String, DataElement> excelMap){
		try {
			
			String userID = getCurPage().getAttribute("UserID");
			String orgID = getCurPage().getAttribute("OrgID");
			String loanSerialNo = excelMap.get("LoanSerialNo").getString();
			double paymentAmt = excelMap.get("PAYMENTAMT").getDouble();
			
			BusinessObject loan = bomanager.keyLoadBusinessObject(BUSINESSOBJECT_CONSTANTS.loan, loanSerialNo);
			
			BusinessObject transaction = TransactionHelper.createTransaction("2001", null, loan, userID, orgID, DateHelper.getBusinessDate(), bomanager);
			transaction.setAttributeValue("ParentTransSerialNo", getCurPage().getAttribute("ParentTransSerialNo"));
			
			BusinessObject document = transaction.getBusinessObject(BUSINESSOBJECT_CONSTANTS.payment_bill);
			document.setAttributeValue("ActualPayAmt", paymentAmt);
			document.setAttributeValue("PayRuleType", CashFlowHelper.getPayRuleType(loan));
			bomanager.updateBusinessObject(transaction);
			bomanager.updateBusinessObject(document);
			bomanager.updateDB();
			sum += paymentAmt;
			cnt++;
		} catch (Exception e) {
			rollBack=true;
			e.printStackTrace();
		}
		
		return !rollBack;
	}

	public void end() {
		if(rollBack){
			try {
				bomanager.rollback();
			} catch (Exception e) {
				e.printStackTrace();
				ARE.getLog("事务回滚出错");
			}
		}else{
			try {
				BusinessObject batchBo = bomanager.keyLoadBusinessObject("jbo.app.BAT_BUSINESS", getCurPage().getAttribute("BatchSerialNo"));
				batchBo.setAttributeValue("TOTALSUM", sum);
				batchBo.setAttributeValue("TOTALCOUNT", cnt);
				bomanager.updateBusinessObject(batchBo);
				bomanager.updateDB();
				bomanager.commit();
			} catch (Exception e) {
				e.printStackTrace();
				ARE.getLog("事务提交出错");
			}
		}
	}
	

}
