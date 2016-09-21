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
 * ���ݹ������¼������п�Ŀ����
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
					.getString("MappintScript_"+extendedBookType);// ��ȡϵͳ�ڲ���������Ӧ��������Ϣ
			String mappingObjectName  = AccountCodeConfig.getAccountCodeConfig(bookType, accountCodeNo)
					.getString("MappingParameterObjectName_"+extendedBookType);// ��ȡϵͳ�ڲ���������Ӧ��������Ϣ
			String mappingBizObjectName  = AccountCodeConfig.getAccountCodeConfig(bookType, accountCodeNo)
					.getString("MappingBizObjectName_"+extendedBookType);// ��ȡϵͳ�ڲ���������Ӧ��������Ϣ
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
			
			BusinessObject journalEntry1=BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.subledger_detail);// �ɿ�Ŀ����
			String slattributeConfig=AccountCodeConfig.getBookTypeConfig(bookType).getString("SLAttributes");//���˻�����
			String[] slattributes=slattributeConfig.split(",");
			for(String attributeID:slattributes){
				Object attributeValue = oldExtendedSubLedger.getObject(attributeID);
				journalEntry1.setAttributeValue(attributeID, attributeValue);
			}
			double occuramt = AccountCodeConfig.getSubledgerBalance(oldExtendedSubLedger,
					oldExtendedSubLedger.getString("Direction"), AccountCodeConfig.Balance_DateFlag_CurrentDay);
			journalEntry1.setAttributeValue("Amount", 0d-occuramt);
			journalEntry1.setAttributeValue("SubLedgerSerialNo", oldExtendedSubLedger.getString("SerialNo"));// ���÷ֻ�����ˮ��
			
			journalEntry1.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));// ���ý��ױ��
			journalEntry1.setAttributeValue("Direction", oldExtendedSubLedger.getString("Direction"));
			journalEntry1.setAttributeValue("SortNo", i++);
			journalEntry1.setAttributeValue("RelativeObjectType", oldExtendedSubLedger.getString("RelativeObjectType"));
			journalEntry1.setAttributeValue("RelativeObjectNo", oldExtendedSubLedger.getString("RelativeObjectNo"));
			journalEntry1.setAttributeValue("ObjectType", oldExtendedSubLedger.getString("ObjectType"));
			journalEntry1.setAttributeValue("ObjectNo", oldExtendedSubLedger.getString("ObjectNo"));
			journalEntry1.setAttributeValue("AccountCodeNo", oldExtendedSubLedger.getString("AccountCodeNo"));

			journalEntry1.setAttributeValue("Status", "0");
			journalEntry1.setAttributeValue("BookDate", transaction.getString("TransDate"));// ����Ϊ����ʱ������
			bomanager.updateBusinessObject(journalEntry1);

			// �¿�Ŀ��¼
			BusinessObject journalEntry2=BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.subledger_detail);// �ɿ�Ŀ����
			for(String attributeID:slattributes){
				Object attributeValue = oldExtendedSubLedger.getObject(attributeID);
				journalEntry2.setAttributeValue(attributeID, attributeValue);
			}
			journalEntry2.setAttributeValue("Amount", AccountCodeConfig.getSubledgerBalance(oldExtendedSubLedger,
					oldExtendedSubLedger.getString("Direction"), AccountCodeConfig.Balance_DateFlag_CurrentDay));
			journalEntry2.setAttributeValue("SubLedgerSerialNo", "");// ���÷ֻ�����ˮ��
			
			journalEntry2.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));// ���ý��ױ��
			journalEntry2.setAttributeValue("Direction", oldExtendedSubLedger.getString("Direction"));
			journalEntry2.setAttributeValue("SortNo", i++);
			journalEntry2.setAttributeValue("RelativeObjectType", oldExtendedSubLedger.getString("RelativeObjectType"));
			journalEntry2.setAttributeValue("RelativeObjectNo", oldExtendedSubLedger.getString("RelativeObjectNo"));
			journalEntry2.setAttributeValue("ObjectType", oldExtendedSubLedger.getString("ObjectType"));
			journalEntry2.setAttributeValue("ObjectNo", oldExtendedSubLedger.getString("ObjectNo"));
			journalEntry2.setAttributeValue("AccountCodeNo", newExtendedAccountCodeNo);

			journalEntry2.setAttributeValue("Status", "0");
			journalEntry2.setAttributeValue("BookDate", transaction.getString("TransDate"));// ����Ϊ����ʱ������
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