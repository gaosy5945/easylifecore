package com.amarsoft.app.accounting.trans.script.loan.accountorgchange;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.trans.script.common.executor.BookKeepExecutor;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.util.Arith;

/**
 * 贷款账务机构调整
 * 
 */
public class AccountOrgChangeExecutor extends BookKeepExecutor {

	@Override
	public int run() throws Exception {
		ArrayList<BusinessObject> journalEntries = new ArrayList<BusinessObject>();
		String newAccountingOrgID = documentObject.getString("AccountingOrgID");// 取新机构
		// 把原借据对象的入账机构设置到单据的原入账机构中
		String orgAttributeID = TransactionConfig.getScriptConfig(this.transactionCode, this.scriptID, "OrgAttributeID");
		
		String oldOrgID=relativeObject.getString(orgAttributeID);
		relativeObject.setAttributeValue(orgAttributeID, newAccountingOrgID);
		bomanager.updateBusinessObject(this.relativeObject);
		documentObject.setAttributeValue("OldAccountingOrgID", oldOrgID);
		bomanager.updateBusinessObject(this.documentObject);
		
		List<BusinessObject> subledgers = relativeObject.getBusinessObjects(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger);//此处处理分录
		int i=1;
		for (BusinessObject subledger:subledgers) {
			String subLedgerSerialNo = subledger.getString("SerialNo");
			if(!oldOrgID.equals(subledger.getString("AccountingOrgID"))) continue;
			String bookType = subledger.getString("BookType");
			double occuramt = subledger.getDouble("DebitBalance")- subledger.getDouble("CreditBalance");

			BusinessObject journalEntry1=BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.subledger_detail);
			String slattributeConfig=AccountCodeConfig.getBookTypeConfig(bookType).getString("SLAttributes");//子账户属性
			String[] slattributes=slattributeConfig.split(",");
			for(String attributeID:slattributes){
				Object attributeValue = subledger.getObject(attributeID);
				journalEntry1.setAttributeValue(attributeID, attributeValue);
			}
			journalEntry1.setAttributeValue("Direction", subledger.getString("Direction"));
			journalEntry1.setAttributeValue("SortNo", i++);
			journalEntry1.setAttributeValue("AccountingOrgID", newAccountingOrgID);
			journalEntry1.setAttributeValue("Amount", Arith.round(occuramt, CashFlowHelper.getMoneyPrecision(this.relativeObject)));
			journalEntry1.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));// 设置交易编号
			
			journalEntry1.setAttributeValue("SubLedgerSerialNo", subLedgerSerialNo);
			journalEntry1.setAttributeValue("BookDate", transaction.getString("TransDate"));// 设置为操作时间日期
			journalEntries.add(journalEntry1);
			bomanager.updateBusinessObject(journalEntry1);

			// 产生新机构的入账分录
			BusinessObject journalEntry2=BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.subledger_detail);
			for(String attributeID:slattributes){
				Object attributeValue = subledger.getObject(attributeID);
				journalEntry2.setAttributeValue(attributeID, attributeValue);
			}
			journalEntry2.setAttributeValue("Direction", subledger.getString("Direction"));
			journalEntry2.setAttributeValue("SortNo", i++);
			journalEntry2.setAttributeValue("Amount", Arith.round(occuramt, CashFlowHelper.getMoneyPrecision(this.relativeObject)));
			journalEntry2.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));// 设置交易编号
			
			journalEntry2.setAttributeValue("SubLedgerSerialNo","");
			journalEntry2.setAttributeValue("BookDate", transaction.getString("TransDate"));// 设置为操作时间日期
			journalEntries.add(journalEntry2);
			bomanager.updateBusinessObject(journalEntry2);

			// 更新分户账信息表机构
			subledger.setAttributeValue("CloseDate", newAccountingOrgID);
			bomanager.updateBusinessObject(subledger);
		}
		// 检查账务信息
		ALSException e = checkbalance(journalEntries);
		if (e!=null) throw e;
		this.updateLedgerAccount(journalEntries);
		return 1;
	}

}