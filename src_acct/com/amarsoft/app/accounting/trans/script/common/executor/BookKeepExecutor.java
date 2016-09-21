package com.amarsoft.app.accounting.trans.script.common.executor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.base.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.SystemDBConfig;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.script.ScriptConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * ����Ǽǣ��������׵ķ�¼��ˮ �����ڱ�Ҫ��ʱ�򴴽��ֻ��ˡ� ÿ�ʽ�ݾ������������룬�÷���������������ݿ����õ������п�Ŀ��
 * 
 */
public class BookKeepExecutor extends TransactionProcedure{

	@Override
	public int run() throws Exception {
		//��ȡ�������������õķ�¼��ţ�Ĭ��Ϊ��
		String journalGroupID = TransactionConfig.getScriptConfig(transactionCode, scriptID, "JournalGroupID");
		Map<String,List<BusinessObject>> details = this.createJournalEntries(journalGroupID);
	 
		for(String bookType:details.keySet()){
			this.updateLedgerAccount(details.get(bookType));
			transaction.appendBusinessObjects(BUSINESSOBJECT_CONSTANTS.subledger_detail, details.get(bookType));
		}
		return 1;
	}

	private final Map<String,List<BusinessObject>> createJournalEntries(String journalGroupID) throws Exception {
		Map<String,List<BusinessObject>> journalEntries = new HashMap<String,List<BusinessObject>>();
		BusinessObject journalGroupConfig = AccountCodeConfig.getJournalGroupConfig(journalGroupID);
		if(journalGroupConfig==null) return journalEntries;
		List<BusinessObject> journalConfigList = journalGroupConfig.getBusinessObjects(AccountCodeConfig.JBO_NAME_JOURNAL);

		String bookTypeFilter = transaction.getString("BookTypeFilter");//������������޶�Ԥ������㳡���£�ֻ��ָ�����׵ķ�¼
		
		for (int i = 0; i < journalConfigList.size(); i++) {
			BusinessObject journalConfig = journalConfigList.get(i);
			String bookType_T = journalConfig.getString("BookType");//��ȡ����/��չ����
			if (StringX.isEmpty(bookType_T)) {
				throw new ALSException("EC4003",journalGroupID);
			}
			
			if (!StringX.isEmpty(bookTypeFilter)&&bookTypeFilter.indexOf(bookType_T) <= -1) {
				continue;
			}
			String conditionScript=journalConfig.getString("ConditionScript");
			if(!StringX.isEmpty(conditionScript)){
				Boolean validFlag = ScriptConfig.getELBooleanValue(conditionScript, "transaction",transaction,"relativeObject",relativeObject,"documentObject",documentObject,"SystemDBConfig",SystemDBConfig.class);
				if (!validFlag) continue;
			}

			// ��ʼ�������׷�¼
			String direction = ScriptConfig.getELStringValue(journalConfig.getString("DirectionScript"), "transaction",transaction);//����
			double occuramt = ScriptConfig.getELDoubleValue(journalConfig.getString("AmtScript"), "transaction",transaction,"relativeObject",relativeObject,"documentObject",documentObject,"SystemDBConfig",SystemDBConfig.class);//���������
			if (Arith.round(occuramt,5)== 0d) continue;
			
			//�� �����ж�
			String journalFlag = journalConfig.getString("JournalFlag");
			if("R".equalsIgnoreCase(journalFlag)) occuramt = - occuramt;//����ȡ����
			
			BusinessObject journalEntry=BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.subledger_detail);
			journalEntry.generateKey();
			journalEntry.setAttributeValue("BookType", bookType_T);
			String slattributeConfig=AccountCodeConfig.getBookTypeConfig(bookType_T).getString("SLAttributes");//���˻�����
			String[] slattributes=slattributeConfig.split(",");
			for(String attributeID:slattributes){
				Object attributeValue = ScriptConfig.executeELScript(journalConfig.getString(attributeID), "transaction",transaction,"relativeObject",relativeObject,"documentObject",documentObject,"SystemDBConfig",SystemDBConfig.class);
				journalEntry.setAttributeValue(attributeID, attributeValue);
			}
			
			occuramt = Arith.round(occuramt, CashFlowHelper.getMoneyPrecision(relativeObject));
			journalEntry.setAttributeValue("Amount", occuramt);
			
			journalEntry.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));// ���ý��ױ��
			journalEntry.setAttributeValue("Direction", direction);
			journalEntry.setAttributeValue("SortNo", journalConfig.getString("ID"));
			journalEntry.setAttributeValue("RelativeObjectType", transaction.getString("RelativeObjectType"));
			journalEntry.setAttributeValue("RelativeObjectNo", transaction.getString("RelativeObjectNo"));
			journalEntry.setAttributeValue("SubLedgerCreateFlag", transaction.getString("SubLedgerCreateFlag"));

			journalEntry.setAttributeValue("Status", "0"); //��¼����ʱ״̬Ϊ0 ����Ч��������ֻ��˺����Ϊ1 ����Ч
			journalEntry.setAttributeValue("BookDate", transaction.getString("TransDate"));// ����Ϊ����ʱ������
			this.addDetails(journalEntries, journalEntry);
			
			String exbookType = journalConfig.getString("ExtendedBookType");
			if (!StringX.isEmpty(exbookType)) {
				
				BusinessObject exp = BusinessObject.createBusinessObject();
				exp.setAttributes(journalEntry);
				exp.setAttributes(relativeObject);
				
				journalEntry.setAttributeValue("EXBookType", exbookType);
				
				BusinessObject bt = AccountCodeConfig.getBookTypeConfig(exbookType);
				List<BusinessObject> accountCodes = bt.getBusinessObjects("AccountCode");
				for(BusinessObject accountCode:accountCodes)
				{
					String filter = accountCode.getString("Filter");
					if(!StringX.isEmpty(filter) && exp.matchSql(filter, null))
					{
						if(!StringX.isEmpty(accountCode.getString("ID")))
						{
							journalEntry.setAttributeValue("EXAccountCodeNo", accountCode.getString("ID"));
						}
						else
						{
							String id = ScriptConfig.getELStringValue(accountCode.getString("Script"), "transaction",transaction,"relativeObject",relativeObject,"documentObject",documentObject,"SystemDBConfig",SystemDBConfig.class);
							journalEntry.setAttributeValue("EXAccountCodeNo", id);
						}
					}
				}
				
				
				if(StringX.isEmpty(journalEntry.getString("EXAccountCodeNo")))
				{
					throw new ALSException("ED1035", exbookType,journalEntry.getString("AccountCodeNo"));
				}
			}
		}

		for(String bookType:journalEntries.keySet()){
			ALSException e = checkbalance(journalEntries.get(bookType));
			if (e!=null) throw e;
		}
		return journalEntries;
	}
	
	private void addDetails(Map<String,List<BusinessObject>> journalEntries,BusinessObject journalEntry) throws Exception{
		String bookType=journalEntry.getString("BookType");
		List<BusinessObject> a = journalEntries.get(bookType);
		if(a==null){
			a=new ArrayList<BusinessObject>();
			journalEntries.put(bookType, a);
		}
		a.add(journalEntry);
	}
	
	public final BusinessObject createSubsidiaryledger(BusinessObject journalEntry) throws Exception{
		BusinessObject subsidiaryledger = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger);
		subsidiaryledger.generateKey();
		String bookType=journalEntry.getString("BookType");
		String accountCodeNo=journalEntry.getString("AccountCodeNo");
		subsidiaryledger.setAttributeValue("BookType", bookType);
		subsidiaryledger.setAttributeValue("AccountCodeNo", accountCodeNo);
		
		BusinessObject accountCodeConfig = AccountCodeConfig.getAccountCodeConfig(bookType, accountCodeNo);
		String subjectDirection = accountCodeConfig.getString("Direction");
		subsidiaryledger.setAttributeValue("Direction", subjectDirection);
		subsidiaryledger.setAttributeValue("Status", "1");
		subsidiaryledger.setAttributeValue("CreateDate", DateHelper.getBusinessDate());
		subsidiaryledger.setAttributeValue("ObjectType", journalEntry.getString("ObjectType"));
		subsidiaryledger.setAttributeValue("ObjectNo", journalEntry.getString("ObjectNo"));
		subsidiaryledger.setAttributeValue("RelativeObjectType", transaction.getString("RelativeObjectType"));
		subsidiaryledger.setAttributeValue("RelativeObjectNo", transaction.getString("RelativeObjectNo"));
		subsidiaryledger.setAttributeValue("EXAccountCodeNo", journalEntry.getString("EXAccountCodeNo"));
		subsidiaryledger.setAttributeValue("EXBookType", journalEntry.getString("EXBookType"));
		
		String slattributeConfig=AccountCodeConfig.getBookTypeConfig(bookType).getString("SLAttributes");//���˻�����
		String[] slattributes=slattributeConfig.split(",");
		for(String attributeID:slattributes){
			subsidiaryledger.setAttributeValue(attributeID, journalEntry.getObject(attributeID));
		}
		this.bomanager.updateBusinessObject(subsidiaryledger);
		return subsidiaryledger;
	}

	protected final void updateLedgerAccount(List<BusinessObject> journalEntries) throws Exception {
		if (journalEntries == null || journalEntries.isEmpty()) return;

		for (int i = 0; i < journalEntries.size(); i++) {
			BusinessObject journalEntry = journalEntries.get(i);
			if(!"S".equals(journalEntry.getString("BookType"))) {
				if (!"0".equals(journalEntry.getString("Status"))) continue;// ����Ѿ����ˣ�������
				if (ACCOUNT_CONSTANTS.FLAG_NO.equals(journalEntry.getString("SubLedgerCreateFlag"))) continue;//��Ҫ�������˻��ļ�¼
				BusinessObject subsidiaryLedger = this.getSubsidiaryLedger(journalEntry);
				if (subsidiaryLedger == null ) subsidiaryLedger=this.createSubsidiaryledger(journalEntry);
				journalEntry.setAttributeValue("SubLedgerSerialNo", subsidiaryLedger.getString("SerialNo"));
				
				double amount = journalEntry.getDouble("Amount");
				String accountdirection = subsidiaryLedger.getString("Direction");
				double debitbalance = subsidiaryLedger.getDouble("DebitBalance");
				double creditbalance = subsidiaryLedger.getDouble("CreditBalance");
				String currency = subsidiaryLedger.getString("Currency");
				String direction=journalEntry.getString("Direction");
				
				if (AccountCodeConfig.BALANCE_DIRECTION_DEBIT.equalsIgnoreCase(accountdirection) || AccountCodeConfig.BALANCE_DIRECTION_RECIEVE.equalsIgnoreCase(accountdirection)) {
					if(AccountCodeConfig.BALANCE_DIRECTION_DEBIT.equalsIgnoreCase(direction) || AccountCodeConfig.BALANCE_DIRECTION_RECIEVE.equalsIgnoreCase(direction)){
						subsidiaryLedger.setAttributeValue("DebitBalance",Arith.round(debitbalance + amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
					}
					else if(AccountCodeConfig.BALANCE_DIRECTION_CREDIT.equalsIgnoreCase(direction) || AccountCodeConfig.BALANCE_DIRECTION_PAY.equalsIgnoreCase(direction)){
						subsidiaryLedger.setAttributeValue("DebitBalance",Arith.round(debitbalance - amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
					}
				} else if (AccountCodeConfig.BALANCE_DIRECTION_CREDIT.equalsIgnoreCase(accountdirection) || AccountCodeConfig.BALANCE_DIRECTION_PAY.equalsIgnoreCase(accountdirection)) {
					if(AccountCodeConfig.BALANCE_DIRECTION_DEBIT.equalsIgnoreCase(direction) || AccountCodeConfig.BALANCE_DIRECTION_RECIEVE.equalsIgnoreCase(direction)){
						subsidiaryLedger.setAttributeValue("CreditBalance",Arith.round(creditbalance - amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
					}
					else if(AccountCodeConfig.BALANCE_DIRECTION_CREDIT.equalsIgnoreCase(direction) || AccountCodeConfig.BALANCE_DIRECTION_PAY.equalsIgnoreCase(direction)){
						subsidiaryLedger.setAttributeValue("CreditBalance",Arith.round(creditbalance + amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
					}
				} else if (AccountCodeConfig.BALANCE_DIRECTION_BOTH.equalsIgnoreCase(accountdirection)) {//˫���Ŀ
					double bbalance = debitbalance-creditbalance;
					if(AccountCodeConfig.BALANCE_DIRECTION_DEBIT.equalsIgnoreCase(direction) || AccountCodeConfig.BALANCE_DIRECTION_RECIEVE.equalsIgnoreCase(direction)){
						bbalance = bbalance+amount;
						if(bbalance > 0)//������Ǳ߾ʹ������Ӧ�ֶ���
							subsidiaryLedger.setAttributeValue("DebitBalance",Arith.round(bbalance,CashFlowHelper.getMoneyPrecision(relativeObject)));
						else
							subsidiaryLedger.setAttributeValue("CreditBalance",Arith.round(Math.abs(bbalance),CashFlowHelper.getMoneyPrecision(relativeObject)));
					}
					else if(AccountCodeConfig.BALANCE_DIRECTION_CREDIT.equalsIgnoreCase(direction) || AccountCodeConfig.BALANCE_DIRECTION_PAY.equalsIgnoreCase(direction)){
						bbalance = bbalance-amount;
						if(bbalance > 0)//������Ǳ߾ʹ������Ӧ�ֶ���
							subsidiaryLedger.setAttributeValue("DebitBalance",Arith.round(bbalance,CashFlowHelper.getMoneyPrecision(relativeObject)));
						else
							subsidiaryLedger.setAttributeValue("CreditBalance",Arith.round(Math.abs(bbalance),CashFlowHelper.getMoneyPrecision(relativeObject)));
					}
				} else
					throw new ALSException("ED1004", accountdirection);
	
				journalEntry.setAttributeValue("ODebitBalance",debitbalance);// ��¼�仯ǰ�����
				journalEntry.setAttributeValue("OCreditBalance",creditbalance);// ��¼�仯ǰ�����
				journalEntry.setAttributeValue("DebitBalance",subsidiaryLedger.getDouble("DebitBalance"));// ��¼�仯������
				journalEntry.setAttributeValue("CreditBalance",subsidiaryLedger.getDouble("CreditBalance"));// ��¼�仯������
	
				//���շ�����,ӦΪ�ֻ���ϸ�еķ�����
				if(AccountCodeConfig.BALANCE_DIRECTION_DEBIT.equalsIgnoreCase(direction) || AccountCodeConfig.BALANCE_DIRECTION_RECIEVE.equalsIgnoreCase(direction)){
					subsidiaryLedger.setAttributeValue("DEBITAMTDAY",Arith.round(subsidiaryLedger.getDouble("DEBITAMTDAY") + amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
					subsidiaryLedger.setAttributeValue("DEBITAMTMONTH",Arith.round(subsidiaryLedger.getDouble("DEBITAMTMONTH") + amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
					subsidiaryLedger.setAttributeValue("DEBITAMTYEAR",Arith.round(subsidiaryLedger.getDouble("DEBITAMTYEAR") + amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
				}
				else if(AccountCodeConfig.BALANCE_DIRECTION_CREDIT.equals(direction) || AccountCodeConfig.BALANCE_DIRECTION_PAY.equalsIgnoreCase(direction)){
					subsidiaryLedger.setAttributeValue("CREDITAMTDAY",Arith.round(subsidiaryLedger.getDouble("CREDITAMTDAY") + amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
					subsidiaryLedger.setAttributeValue("CREDITAMTMONTH",Arith.round(subsidiaryLedger.getDouble("CREDITAMTMONTH") + amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
					subsidiaryLedger.setAttributeValue("CREDITAMTYEAR",Arith.round(subsidiaryLedger.getDouble("CREDITAMTYEAR") + amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
				}
				bomanager.updateBusinessObject(subsidiaryLedger);
				if(this.relativeObject != null) relativeObject.appendBusinessObject(subsidiaryLedger.getBizClassName(), subsidiaryLedger);

			}
			journalEntry.setAttributeValue("Status","1");
			
			//���ڷ����ཻ�׽��ֻ��˷�����ں����߼������ȡ�����Ϣ
			bomanager.updateBusinessObject(journalEntry);
			
		}
	}

	private BusinessObject getSubsidiaryLedger(BusinessObject journalEntry) throws Exception {
		String objectType = journalEntry.getString("ObjectType");
		String objectNo = journalEntry.getString("ObjectNo");
		Map<String,Object> as = new HashMap<String,Object>();
		as.put("ObjectType", journalEntry.getString("ObjectType"));
		as.put("ObjectNo", journalEntry.getString("ObjectNo"));
		as.put("AccountCodeNo", journalEntry.getString("AccountCodeNo"));
		as.put("AccountingOrgID", journalEntry.getString("AccountingOrgID"));
		as.put("BookType", journalEntry.getString("BookType"));
		String slattributeConfig=AccountCodeConfig.getBookTypeConfig(journalEntry.getString("BookType")).getString("SLAttributes");//���˻�����
		String[] slattributes=slattributeConfig.split(",");
		for(String attributeID:slattributes){
			as.put(attributeID, journalEntry.getObject(attributeID));
		}
		
		BusinessObject businessObject = this.transaction.getBusinessObjectByKey(objectType, objectNo);
		if (businessObject == null) throw new ALSException("ED1010", objectType, objectNo);
		return businessObject.getBusinessObjectByAttributes(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, as);
	}

	protected ALSException checkbalance(List<BusinessObject> journalEntries) throws Exception {
		ALSException e=null;
		HashMap<String, Double> debitMap = new HashMap<String, Double>();
		HashMap<String, Double> creditMap = new HashMap<String, Double>();
		for (int i = 0; i < journalEntries.size(); i++) {
			BusinessObject subledgerdetail = (BusinessObject) journalEntries.get(i);
			String bookType = subledgerdetail.getString("BookType");
			String currency = subledgerdetail.getString("Currency");
			String orgID = subledgerdetail.getString("AccountingOrgID");
			String direction = subledgerdetail.getString("Direction");
			
			if(AccountCodeConfig.BALANCE_DIRECTION_PAY.equalsIgnoreCase(direction)
					|| AccountCodeConfig.BALANCE_DIRECTION_RECIEVE.equalsIgnoreCase(direction)
					|| AccountCodeConfig.BALANCE_DIRECTION_BOTH.equalsIgnoreCase(direction))
			{
				continue;
			}
			
			String key = bookType + "@" + orgID + "@" + currency;
			
			if(AccountCodeConfig.BALANCE_DIRECTION_DEBIT.equals(direction))
			{
				Double debitAmt = debitMap.get(key);
				if (debitAmt == null)
					debitMap.put(key, new Double(subledgerdetail.getDouble("amount")));
				else
					debitMap.put(key, new Double(debitAmt.doubleValue()
							+ subledgerdetail.getDouble("amount")));
			}
			else
			{
				Double creditAmt = creditMap.get(key);
				if (creditAmt == null)
					creditMap.put(key, new Double(subledgerdetail.getDouble("amount")));
				else
					creditMap.put(key, new Double(creditAmt.doubleValue() + subledgerdetail.getDouble("amount")));
			}
		}

		// ��ɨ��跽
		for (Object a : debitMap.keySet().toArray()) {
			String key = (String) a;
			Double creditAmt = creditMap.get(key);
			Double debitAmt = debitMap.get(key);
			if (creditAmt == null)
				creditAmt = new Double(0.0d);
			if (debitAmt == null)
				debitAmt = new Double(0.0d);
			if (Arith.round(Math.abs(creditAmt - debitAmt), CashFlowHelper.getMoneyPrecision(relativeObject)) < 0.00001) {
				// ���ƽ��
			} else {
				if(e==null) e=new ALSException("EC4001",this.transactionCode,TransactionConfig.getTransactionConfig(this.transactionCode, "TransactionName"));
			}
		}

		// ��ɨ�����
		for (Object a : creditMap.keySet().toArray()) {
			String key = (String) a;
			Double creditAmt = creditMap.get(key);
			Double debitAmt = debitMap.get(key);
			if (creditAmt == null)
				creditAmt = new Double(0.0d);
			if (debitAmt == null)
				debitAmt = new Double(0.0d);
			if (Arith.round(Math.abs(creditAmt - debitAmt), CashFlowHelper.getMoneyPrecision(relativeObject)) < 0.0000001) {
				// ���ƽ��
			} else {
				if(e==null) e=new ALSException("EC4001",this.transactionCode,TransactionConfig.getTransactionConfig(this.transactionCode, "TransactionName"));
			}
		}
		
		return e;
	}
	
	/**
	 * ����ԭ������ˮ�������˵���ˮ
	 * @throws Exception 
	 */
	public Map<String,List<BusinessObject>> createReverseDetail() throws Exception{
		String journalFlag = TransactionConfig.getScriptConfig(transactionCode, scriptID, "JournalFlag");
		BusinessObject oldTransaction = documentObject;
		if(journalFlag==null||journalFlag.length()==0) {//������֣���ǰ�������
			String transDate=this.transaction.getString("TransDate");
			if(transDate==null||transDate.length()==0) transDate=DateHelper.getBusinessDate();
			String oldTransDate = oldTransaction.getString("TransDate");
			if(transDate.substring(0,4).equals(oldTransDate.substring(0,4)))//�������
				journalFlag="R";
			else journalFlag="B";//��ǰ�������
		}
		
		Map<String,List<BusinessObject>> journalEntries = new HashMap<String,List<BusinessObject>>();
		
		List<BusinessObject> oldDetailList = oldTransaction.getBusinessObjects(BUSINESSOBJECT_CONSTANTS.subledger_detail);
		if(oldDetailList!=null&&!oldDetailList.isEmpty()){
			for (int i = oldDetailList.size() - 1; i >= 0; i--) {
				BusinessObject subledgerDetailTemp = oldDetailList.get(i);
				String accountCodeNo = subledgerDetailTemp.getString("AccountCodeNo");
				String bookType = subledgerDetailTemp.getString("BookType");
				double amount = subledgerDetailTemp.getDouble("amount");
				String direction = subledgerDetailTemp.getString("Direction");
				
				BusinessObject subledgerDetail = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.subledger_detail);
				subledgerDetail.setAttributes(subledgerDetailTemp);
				subledgerDetail.generateKey(true);//����������ˮ��
				subledgerDetail.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));// ���ý��ױ��
				subledgerDetail.setAttributeValue("RelativeObjectType", transaction.getString("RelativeObjectType"));
				subledgerDetail.setAttributeValue("RelativeObjectNo", transaction.getString("RelativeObjectNo"));
				subledgerDetail.setAttributeValue("SubLedgerCreateFlag", transaction.getString("SubLedgerCreateFlag"));

				subledgerDetail.setAttributeValue("Status", "0"); //��¼����ʱ״̬Ϊ0 ����Ч��������ֻ��˺����Ϊ1 ����Ч
				subledgerDetail.setAttributeValue("BookDate", transaction.getString("TransDate"));// ����Ϊ����ʱ������
				
				if("R".equalsIgnoreCase(journalFlag) || AccountCodeConfig.BALANCE_DIRECTION_BOTH.equalsIgnoreCase(direction))
				{
					subledgerDetail.setAttributeValue("Direction", direction);
					subledgerDetail.setAttributeValue("Amount", Arith.round(0-amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
				}
				else
				{
					if(AccountCodeConfig.BALANCE_DIRECTION_DEBIT.equalsIgnoreCase(direction))
					{
						direction = AccountCodeConfig.BALANCE_DIRECTION_CREDIT;
					}
					else if(AccountCodeConfig.BALANCE_DIRECTION_CREDIT.equalsIgnoreCase(direction))
					{
						direction = AccountCodeConfig.BALANCE_DIRECTION_DEBIT;
					}
					else if(AccountCodeConfig.BALANCE_DIRECTION_RECIEVE.equalsIgnoreCase(direction))
					{
						direction = AccountCodeConfig.BALANCE_DIRECTION_PAY;
					}
					else if(AccountCodeConfig.BALANCE_DIRECTION_PAY.equalsIgnoreCase(direction))
					{
						direction = AccountCodeConfig.BALANCE_DIRECTION_RECIEVE;
					}
					subledgerDetail.setAttributeValue("Direction", direction);
					subledgerDetail.setAttributeValue("Amount", Arith.round(amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
				}
				
				this.addDetails(journalEntries, subledgerDetail);
			}
		}
		
		for(String bookType:journalEntries.keySet()){
			ALSException e = checkbalance(journalEntries.get(bookType));
			if (e!=null) throw e;
		}
		return journalEntries;
	}
}
