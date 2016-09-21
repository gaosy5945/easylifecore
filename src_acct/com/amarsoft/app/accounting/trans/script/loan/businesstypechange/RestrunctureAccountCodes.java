package com.amarsoft.app.accounting.trans.script.loan.businesstypechange;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.trans.script.common.executor.BookKeepExecutor;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.script.ScriptConfig;
import com.amarsoft.are.lang.StringX;

/**
 * 根据规则重新计算银行科目代码
 * 
 */
public final class RestrunctureAccountCodes extends BookKeepExecutor {
	@Override
	public int run() throws Exception{
		List<BusinessObject> journalEntries = new ArrayList<BusinessObject>();
		String bookType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "BookType");
		String extendedBookType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "ExtendedBookType");
		List<BusinessObject> subLedgerList = this.relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger,"BookType=:BookType","BookType",bookType);
		int i=1;
		for (BusinessObject subLedger : subLedgerList) {
			String accountCodeNo = subLedger.getString("AccountCodeNo");
			String oldExtendedAccountCodeNo = subLedger.getString("AccountCodeNo_"+extendedBookType);
			if(StringX.isEmpty(oldExtendedAccountCodeNo)) continue;
			String newExtendedAccountCodeNo=null;
					
			String mappingScript  = AccountCodeConfig.getAccountCodeConfig(bookType, accountCodeNo)
					.getString("MappintScript_"+extendedBookType);// 获取系统内部账务代码对应的配置信息
			String mappingObjectName  = AccountCodeConfig.getAccountCodeConfig(bookType, accountCodeNo)
					.getString("MappingParameterObjectName_"+extendedBookType);// 获取系统内部账务代码对应的配置信息
			String mappingBizObjectName  = AccountCodeConfig.getAccountCodeConfig(bookType, accountCodeNo)
					.getString("MappingBizObjectName_"+extendedBookType);// 获取系统内部账务代码对应的配置信息
			if (StringX.isEmpty(mappingScript)) continue;
			BusinessObject relativeObject = transaction.getBusinessObject(mappingBizObjectName);
			newExtendedAccountCodeNo =(String)ScriptConfig.executeELScript(mappingScript, "businessObject",mappingObjectName,relativeObject);
			if (StringX.isEmpty(newExtendedAccountCodeNo)) {
				throw new ALSException("EC2001", accountCodeNo);
			}
			if(oldExtendedAccountCodeNo.equals(newExtendedAccountCodeNo)) continue;

			BusinessObject oldExtendedSubLedger = this.relativeObject.getBusinessObjectBySql(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger,"BookType=:BookType and AccountCodeNo=:AccountCodeNo"
					,"BookType",bookType,"AccountCodeNo",oldExtendedAccountCodeNo);
			if(oldExtendedSubLedger==null) continue;
			
			BusinessObject journalEntry1=BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.subledger_detail);// 旧科目销账
			String slattributeConfig=AccountCodeConfig.getBookTypeConfig(bookType).getString("SLAttributes");//子账户属性
			String[] slattributes=slattributeConfig.split(",");
			for(String attributeID:slattributes){
				Object attributeValue = oldExtendedSubLedger.getObject(attributeID);
				journalEntry1.setAttributeValue(attributeID, attributeValue);
			}
			double occuramt = AccountCodeConfig.getSubledgerBalance(oldExtendedSubLedger,
					oldExtendedSubLedger.getString("Direction"), AccountCodeConfig.Balance_DateFlag_CurrentDay);
			journalEntry1.setAttributeValue("Amount", 0d-occuramt);
			journalEntry1.setAttributeValue("SubLedgerSerialNo", oldExtendedSubLedger.getString("SerialNo"));// 设置分户账流水号
			
			journalEntry1.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));// 设置交易编号
			journalEntry1.setAttributeValue("Direction", oldExtendedSubLedger.getString("Direction"));
			journalEntry1.setAttributeValue("SortNo", i++);
			journalEntry1.setAttributeValue("RelativeObjectType", oldExtendedSubLedger.getString("RelativeObjectType"));
			journalEntry1.setAttributeValue("RelativeObjectNo", oldExtendedSubLedger.getString("RelativeObjectNo"));
			journalEntry1.setAttributeValue("ObjectType", oldExtendedSubLedger.getString("ObjectType"));
			journalEntry1.setAttributeValue("ObjectNo", oldExtendedSubLedger.getString("ObjectNo"));
			journalEntry1.setAttributeValue("AccountCodeNo", oldExtendedSubLedger.getString("AccountCodeNo"));

			journalEntry1.setAttributeValue("Status", "0");
			journalEntry1.setAttributeValue("BookDate", transaction.getString("TransDate"));// 设置为操作时间日期
			bomanager.updateBusinessObject(journalEntry1);

			// 新科目分录
			BusinessObject journalEntry2=BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.subledger_detail);// 旧科目销账
			for(String attributeID:slattributes){
				Object attributeValue = oldExtendedSubLedger.getObject(attributeID);
				journalEntry2.setAttributeValue(attributeID, attributeValue);
			}
			journalEntry2.setAttributeValue("Amount", AccountCodeConfig.getSubledgerBalance(oldExtendedSubLedger,
					oldExtendedSubLedger.getString("Direction"), AccountCodeConfig.Balance_DateFlag_CurrentDay));
			journalEntry2.setAttributeValue("SubLedgerSerialNo", "");// 设置分户账流水号
			
			journalEntry2.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));// 设置交易编号
			journalEntry2.setAttributeValue("Direction", oldExtendedSubLedger.getString("Direction"));
			journalEntry2.setAttributeValue("SortNo", i++);
			journalEntry2.setAttributeValue("RelativeObjectType", oldExtendedSubLedger.getString("RelativeObjectType"));
			journalEntry2.setAttributeValue("RelativeObjectNo", oldExtendedSubLedger.getString("RelativeObjectNo"));
			journalEntry2.setAttributeValue("ObjectType", oldExtendedSubLedger.getString("ObjectType"));
			journalEntry2.setAttributeValue("ObjectNo", oldExtendedSubLedger.getString("ObjectNo"));
			journalEntry2.setAttributeValue("AccountCodeNo", newExtendedAccountCodeNo);

			journalEntry2.setAttributeValue("Status", "0");
			journalEntry2.setAttributeValue("BookDate", transaction.getString("TransDate"));// 设置为操作时间日期
			bomanager.updateBusinessObject(journalEntry2);

			journalEntries.add(journalEntry1);
			journalEntries.add(journalEntry2);

			subLedger.setAttributeValue("AccountCodeNo_"+extendedBookType, newExtendedAccountCodeNo);
			bomanager.updateBusinessObject(subLedger);
		}

		this.updateLedgerAccount(journalEntries);
		return 1;
	}
}