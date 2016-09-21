package com.amarsoft.app.base.trans;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.base.trans.common.checker.TransactionChecker;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;

/**
 * 核算交易公用方法
 */
public class TransactionHelper {
	public static final String transaction_create="create"; //交易创建
	public static final String transaction_load="load";//交易数据加载
	public static final String transaction_check="check";//交易数据检查
	public static final String transaction_execute="execute";//交易业务逻辑执行
	public static final String transaction_delete="delete";//交易删除
	
	/**
	 * 根据交易流水号加载交易信息
	 * @param transactionSerialNo
	 * @param bomanager
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject loadTransaction(String transactionSerialNo, BusinessObjectManager bomanager) throws Exception {
		BusinessObject transaction = bomanager.loadBusinessObject(BUSINESSOBJECT_CONSTANTS.transaction, "SerialNo",transactionSerialNo);
		return TransactionHelper.loadTransaction(transaction, bomanager);
	}

	/**
	 * 根据交易对象加载交易信息
	 * @param transaction
	 * @param bomanager
	 * @return 加载了各种关联对象的交易对象
	 * @throws Exception
	 */
	public static BusinessObject loadTransaction(BusinessObject transaction, BusinessObjectManager bomanager) throws Exception {
		int i=TransactionHelper.run(transaction, bomanager, TransactionHelper.transaction_load);
		if(i==1) return transaction;
		else throw new ALSException("ED2005",transaction.getString("TRANSCODE"));
	}

	/**
	 * 根据传入参数创建一个交易
	 * 
	 * @param transactionCode 交易代码
	 * @param documentObject 单据对象
	 * @param relativeObject 关联对象
	 * @param userID 用户编号
	 * @param orgID 机构编号
	 * @param transactionDate 交易日期
	 * @param bomanager 对象管理器
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject createTransaction(String transactionCode, BusinessObject documentObject,
			BusinessObject relativeObject, String userID,String orgID, String transactionDate,
			BusinessObjectManager bomanager) throws Exception {
		BusinessObject transactionConfig = TransactionConfig.getTransactionConfig(transactionCode);
		BusinessObject transaction = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.transaction);
		transaction.generateKey();
		transaction.setAttributeValue("TransCode", transactionCode);
		transaction.setAttributeValue("TransName", transactionConfig.getString("TransactionName"));
		transaction.setAttributeValue("OccurDate", DateHelper.getBusinessDate());
		if (!StringX.isEmpty(transactionDate)) {
			transaction.setAttributeValue("TransDate", transactionDate);
		} else {
			transaction.setAttributeValue("TransDate", DateHelper.getBusinessDate());
		}
		transaction.setAttributeValue("InputUserID", userID);
		transaction.setAttributeValue("InputOrgID", orgID);
		transaction.setAttributeValue("InputTime",DateX.format(new Date(), DateHelper.AMR_NOMAL_DATETIME_FORMAT));
		
		if (relativeObject != null) {
			transaction.setAttributeValue("RelativeObjectType", relativeObject.getBizClassName());
			transaction.setAttributeValue("RelativeObjectNo", relativeObject.getKeyString());
			transaction.appendBusinessObject(relativeObject.getBizClassName(),relativeObject);
		}

		// 创建交易单据
		String documentType = transactionConfig.getString("DocumentType");
		if (StringX.isEmpty(documentType)) {
			documentObject = null;// 交易不需要单据，如计提等交易
		}
		else {// 如果需要单据
			if (documentObject == null) {
				documentObject = BusinessObject.createBusinessObject(documentType);
				documentObject.generateKey();
				transaction.setAttributeValue("DocumentType", documentType);
				transaction.setAttributeValue("DocumentNo", documentObject.getKeyString());
				bomanager.updateBusinessObject(documentObject);
			} 
			else {
				transaction.setAttributeValue("DocumentType", documentObject.getBizClassName());
				transaction.setAttributeValue("DocumentNo", documentObject.getKeyString());
			}
			transaction.appendBusinessObject(documentType, documentObject);
		}
		bomanager.updateBusinessObject(transaction);

		//执行交易内部创建逻辑
		int r = TransactionHelper.run(transaction, bomanager, TransactionHelper.transaction_create);
		if(r == 1) return transaction;
		else throw new ALSException("ED2006",transaction.getString("TRANSCODE"));//创建交易异常
	}

	/**
	 * 交易流程提交前或交易执行前检查
	 * 
	 * 如需前端展示，请根据返回结果Map获取提示信息和强制控制信息
	 * 1、提示校验信息： List<Message> warningMessage = map.get("Warning");
	 * 2、强制校验信息： List<Message> errorMessage = map.get("Error");
	 * 使用者可根据以上两项信息进行前端展示，便于客户了解提示或错误信息。
	 * @param transaction
	 * @param bomanager
	 * @return
	 * @throws Exception
	 */
	public static Map<String,List<String>> checkTransaction(BusinessObject transaction,BusinessObjectManager bomanager) throws Exception{
		Map<String,List<String>> hs = new HashMap<String,List<String>>();
		List<String> warningMessage = new ArrayList<String>();
		List<String> errorMessage= new ArrayList<String>();
		hs.put("Warning", warningMessage);
		hs.put("Error", errorMessage);
		
		String transactionCode=transaction.getString("TransCode");
		BusinessObject transactionConfig = TransactionConfig.getTransactionConfig(transactionCode);
		List<BusinessObject> tplist=transactionConfig.getBusinessObjectsByAttributes(TransactionConfig.JBO_NAME_PROCEDURE_CONFIG, "type",TransactionHelper.transaction_check);
		int j = 1;
		for(BusinessObject tpConfig:tplist) {
			TransactionChecker tp = (TransactionChecker)TransactionProcedure.create(transaction, tpConfig, bomanager);
			j=tp.run();
			if (j != 1) {
				throw new ALSException("ED2012",transactionCode);//交易检查异常
			}
			warningMessage.addAll(tp.getWarningMessage());
			errorMessage.addAll(tp.getErrorMessage());
		}
		return hs;
	}
	
	/**
	 * 根据交易流水号删除交易及其相关信息
	 * @param transactionSerialNo
	 * @param bomanager
	 * @throws Exception
	 */
	public static void deleteTransaction(String transactionSerialNo,BusinessObjectManager bomanager) throws Exception{
		BusinessObject transaction = bomanager.keyLoadBusinessObject(BUSINESSOBJECT_CONSTANTS.transaction, transactionSerialNo);
		if(transaction == null) throw new ALSException("ED2009",transactionSerialNo);
		bomanager.deleteBusinessObject(transaction);
		
		String documentType = transaction.getString("DocumentType");
		String documentNo = transaction.getString("DocumentNo");
		
		if(!StringX.isEmpty(documentType) && !StringX.isEmpty(documentNo) && !BUSINESSOBJECT_CONSTANTS.transaction.equals(documentType))
		{
			BusinessObject documentObject = bomanager.keyLoadBusinessObject(documentType, documentNo);
			if(documentObject == null) throw new ALSException("ED2010",documentType, documentNo);
			bomanager.deleteBusinessObject(documentObject);
		}
		
		int r = TransactionHelper.run(transaction, bomanager, TransactionHelper.transaction_delete);
		if(r != 1) throw new ALSException("ED2011",transaction.getString("TRANSCODE"));
	}
	
	/**
	 * 交易内部业务数据处理执行
	 * @param transaction
	 * @param bomanager
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject executeTransaction(BusinessObject transaction, BusinessObjectManager bomanager) throws Exception{
		int r = TransactionHelper.run(transaction, bomanager, TransactionHelper.transaction_execute);
		if(r == 1) return transaction;
		else throw new ALSException("ED2007",transaction.getString("TRANSCODE"));
	}
	
	/**
	 * 根据指定类型执行交易信息
	 * @param transaction
	 * @param bomanager
	 * @param type
	 * @return
	 * @throws Exception
	 */
	private static int run(BusinessObject transaction, BusinessObjectManager bomanager,String type)
			throws Exception {
		String transactionCode=transaction.getString("TransCode");
		BusinessObject transactionConfig = TransactionConfig.getTransactionConfig(transactionCode);
		List<BusinessObject> tplist=transactionConfig.getBusinessObjectsByAttributes(TransactionConfig.JBO_NAME_PROCEDURE_CONFIG, "type",type);
		int j = 1;
		for(BusinessObject tpConfig:tplist) {
			TransactionProcedure tp = TransactionProcedure.create(transaction, tpConfig, bomanager);
			j=tp.run();
			if (j != 1) {
				return j;
			}
		}
		return j;
	}
}
