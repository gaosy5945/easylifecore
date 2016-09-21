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
 * 账务登记：产生交易的分录流水 ，并在必要的时候创建分户账。 每笔借据均保留方案编码，该方案编码必须包含借据可能用到的所有科目。
 * 
 */
public class BookKeepExecutor extends TransactionProcedure{

	@Override
	public int run() throws Exception {
		//获取交易配置中配置的分录组号，默认为空
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

		String bookTypeFilter = transaction.getString("BookTypeFilter");//这个参数用于限定预览或测算场景下，只出指定账套的分录
		
		for (int i = 0; i < journalConfigList.size(); i++) {
			BusinessObject journalConfig = journalConfigList.get(i);
			String bookType_T = journalConfig.getString("BookType");//获取账套/扩展账套
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

			// 开始创建交易分录
			String direction = ScriptConfig.getELStringValue(journalConfig.getString("DirectionScript"), "transaction",transaction);//方向
			double occuramt = ScriptConfig.getELDoubleValue(journalConfig.getString("AmtScript"), "transaction",transaction,"relativeObject",relativeObject,"documentObject",documentObject,"SystemDBConfig",SystemDBConfig.class);//发生额计算
			if (Arith.round(occuramt,5)== 0d) continue;
			
			//红 蓝字判断
			String journalFlag = journalConfig.getString("JournalFlag");
			if("R".equalsIgnoreCase(journalFlag)) occuramt = - occuramt;//红字取负数
			
			BusinessObject journalEntry=BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.subledger_detail);
			journalEntry.generateKey();
			journalEntry.setAttributeValue("BookType", bookType_T);
			String slattributeConfig=AccountCodeConfig.getBookTypeConfig(bookType_T).getString("SLAttributes");//子账户属性
			String[] slattributes=slattributeConfig.split(",");
			for(String attributeID:slattributes){
				Object attributeValue = ScriptConfig.executeELScript(journalConfig.getString(attributeID), "transaction",transaction,"relativeObject",relativeObject,"documentObject",documentObject,"SystemDBConfig",SystemDBConfig.class);
				journalEntry.setAttributeValue(attributeID, attributeValue);
			}
			
			occuramt = Arith.round(occuramt, CashFlowHelper.getMoneyPrecision(relativeObject));
			journalEntry.setAttributeValue("Amount", occuramt);
			
			journalEntry.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));// 设置交易编号
			journalEntry.setAttributeValue("Direction", direction);
			journalEntry.setAttributeValue("SortNo", journalConfig.getString("ID"));
			journalEntry.setAttributeValue("RelativeObjectType", transaction.getString("RelativeObjectType"));
			journalEntry.setAttributeValue("RelativeObjectNo", transaction.getString("RelativeObjectNo"));
			journalEntry.setAttributeValue("SubLedgerCreateFlag", transaction.getString("SubLedgerCreateFlag"));

			journalEntry.setAttributeValue("Status", "0"); //分录产生时状态为0 待生效，更新完分户账后更新为1 已生效
			journalEntry.setAttributeValue("BookDate", transaction.getString("TransDate"));// 设置为操作时间日期
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
		
		String slattributeConfig=AccountCodeConfig.getBookTypeConfig(bookType).getString("SLAttributes");//子账户属性
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
				if (!"0".equals(journalEntry.getString("Status"))) continue;// 如果已经记账，则跳过
				if (ACCOUNT_CONSTANTS.FLAG_NO.equals(journalEntry.getString("SubLedgerCreateFlag"))) continue;//需要创建子账户的记录
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
				} else if (AccountCodeConfig.BALANCE_DIRECTION_BOTH.equalsIgnoreCase(accountdirection)) {//双向科目
					double bbalance = debitbalance-creditbalance;
					if(AccountCodeConfig.BALANCE_DIRECTION_DEBIT.equalsIgnoreCase(direction) || AccountCodeConfig.BALANCE_DIRECTION_RECIEVE.equalsIgnoreCase(direction)){
						bbalance = bbalance+amount;
						if(bbalance > 0)//余额在那边就存放在相应字段上
							subsidiaryLedger.setAttributeValue("DebitBalance",Arith.round(bbalance,CashFlowHelper.getMoneyPrecision(relativeObject)));
						else
							subsidiaryLedger.setAttributeValue("CreditBalance",Arith.round(Math.abs(bbalance),CashFlowHelper.getMoneyPrecision(relativeObject)));
					}
					else if(AccountCodeConfig.BALANCE_DIRECTION_CREDIT.equalsIgnoreCase(direction) || AccountCodeConfig.BALANCE_DIRECTION_PAY.equalsIgnoreCase(direction)){
						bbalance = bbalance-amount;
						if(bbalance > 0)//余额在那边就存放在相应字段上
							subsidiaryLedger.setAttributeValue("DebitBalance",Arith.round(bbalance,CashFlowHelper.getMoneyPrecision(relativeObject)));
						else
							subsidiaryLedger.setAttributeValue("CreditBalance",Arith.round(Math.abs(bbalance),CashFlowHelper.getMoneyPrecision(relativeObject)));
					}
				} else
					throw new ALSException("ED1004", accountdirection);
	
				journalEntry.setAttributeValue("ODebitBalance",debitbalance);// 记录变化前的余额
				journalEntry.setAttributeValue("OCreditBalance",creditbalance);// 记录变化前的余额
				journalEntry.setAttributeValue("DebitBalance",subsidiaryLedger.getDouble("DebitBalance"));// 记录变化后的余额
				journalEntry.setAttributeValue("CreditBalance",subsidiaryLedger.getDouble("CreditBalance"));// 记录变化后的余额
	
				//当日发生额,应为分户明细中的发生金额。
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
			
			//对于发放类交易将分户账放入便于后续逻辑处理获取余额信息
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
		String slattributeConfig=AccountCodeConfig.getBookTypeConfig(journalEntry.getString("BookType")).getString("SLAttributes");//子账户属性
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

		// 先扫描借方
		for (Object a : debitMap.keySet().toArray()) {
			String key = (String) a;
			Double creditAmt = creditMap.get(key);
			Double debitAmt = debitMap.get(key);
			if (creditAmt == null)
				creditAmt = new Double(0.0d);
			if (debitAmt == null)
				debitAmt = new Double(0.0d);
			if (Arith.round(Math.abs(creditAmt - debitAmt), CashFlowHelper.getMoneyPrecision(relativeObject)) < 0.00001) {
				// 借贷平衡
			} else {
				if(e==null) e=new ALSException("EC4001",this.transactionCode,TransactionConfig.getTransactionConfig(this.transactionCode, "TransactionName"));
			}
		}

		// 再扫描贷方
		for (Object a : creditMap.keySet().toArray()) {
			String key = (String) a;
			Double creditAmt = creditMap.get(key);
			Double debitAmt = debitMap.get(key);
			if (creditAmt == null)
				creditAmt = new Double(0.0d);
			if (debitAmt == null)
				debitAmt = new Double(0.0d);
			if (Arith.round(Math.abs(creditAmt - debitAmt), CashFlowHelper.getMoneyPrecision(relativeObject)) < 0.0000001) {
				// 借贷平衡
			} else {
				if(e==null) e=new ALSException("EC4001",this.transactionCode,TransactionConfig.getTransactionConfig(this.transactionCode, "TransactionName"));
			}
		}
		
		return e;
	}
	
	/**
	 * 根据原交易流水创建冲账的流水
	 * @throws Exception 
	 */
	public Map<String,List<BusinessObject>> createReverseDetail() throws Exception{
		String journalFlag = TransactionConfig.getScriptConfig(transactionCode, scriptID, "JournalFlag");
		BusinessObject oldTransaction = documentObject;
		if(journalFlag==null||journalFlag.length()==0) {//当年红字，以前年份蓝字
			String transDate=this.transaction.getString("TransDate");
			if(transDate==null||transDate.length()==0) transDate=DateHelper.getBusinessDate();
			String oldTransDate = oldTransaction.getString("TransDate");
			if(transDate.substring(0,4).equals(oldTransDate.substring(0,4)))//当年红字
				journalFlag="R";
			else journalFlag="B";//以前年份蓝字
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
				subledgerDetail.generateKey(true);//重新生成流水号
				subledgerDetail.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));// 设置交易编号
				subledgerDetail.setAttributeValue("RelativeObjectType", transaction.getString("RelativeObjectType"));
				subledgerDetail.setAttributeValue("RelativeObjectNo", transaction.getString("RelativeObjectNo"));
				subledgerDetail.setAttributeValue("SubLedgerCreateFlag", transaction.getString("SubLedgerCreateFlag"));

				subledgerDetail.setAttributeValue("Status", "0"); //分录产生时状态为0 待生效，更新完分户账后更新为1 已生效
				subledgerDetail.setAttributeValue("BookDate", transaction.getString("TransDate"));// 设置为操作时间日期
				
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
