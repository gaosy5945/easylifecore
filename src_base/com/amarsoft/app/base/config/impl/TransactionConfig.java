package com.amarsoft.app.base.config.impl;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectCache;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;

/**
 * 
 * 核算交易相关配置
 * 
 * @author 核算产品组
 * @author xyqu 2014年6月17日 修正代码、添加注释
 * 
 */
public final class TransactionConfig extends XMLConfig {
	public static final String JBO_NAME_TRANSACTION_CONFIG="TransactionConfig";
	public static final String JBO_NAME_PROCEDURE_CONFIG="Procedure";
	
	public static final String TRANSACTION_STATUS_0="0";//待处理
	public static final String TRANSACTION_STATUS_1="1";//已生效
	public static final String TRANSACTION_STATUS_2="2";//已反冲
	
	/**
	 * 交易配置信息
	 */
	private static BusinessObjectCache transactionConfigs=new BusinessObjectCache(1000);

	
	
	//单例模式
	private static TransactionConfig tc = null;
	
	private TransactionConfig(){
		
	}
	
	public static TransactionConfig getInstance(){
		if(tc == null)
			tc = new TransactionConfig();
		return tc;
	}
	
	/**
	 * 获取交易配置信息
	 * @param transactionCode
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getTransactionConfig(String transactionCode) throws Exception {
		BusinessObject transactionConfig = (BusinessObject)transactionConfigs.getCacheObject(transactionCode);
		if(transactionConfig==null){
			throw new ALSException("EC4004",transactionCode);
		}
		return transactionConfig;
	}

	/**
	 * 获取交易属性
	 * @param transactionCode
	 * @param attributeID
	 * @return
	 * @throws Exception
	 */
	public static String getTransactionConfig(String transactionCode, String attributeID) throws Exception {
		String value = TransactionConfig.getTransactionConfig(transactionCode).getString(attributeID);
		return value;
	}

	/**
	 * 获取交易配置的属性
	 * @param transactionCode
	 * @param scriptID
	 * @param attributeID
	 * @return
	 * @throws Exception
	 */
	public static String getScriptConfig(String transactionCode, String scriptID, String attributeID) throws Exception {
		BusinessObject transactionScript= TransactionConfig.getScriptConfig(transactionCode, scriptID);
		if(transactionScript==null){
			throw new ALSException("EC4005",transactionCode,scriptID);
		}
		String value = transactionScript.getString(attributeID);
		return value;
	}
	
	public static BusinessObject getScriptConfig(String transactionCode, String scriptID) throws Exception {
		BusinessObject transactionScript= TransactionConfig.getTransactionConfig(transactionCode).getBusinessObjectByAttributes(JBO_NAME_PROCEDURE_CONFIG,"id", scriptID);
		if(transactionScript==null){
			throw new ALSException("EC4005",transactionCode,scriptID);
		}
		return transactionScript;
	}

	
	/**
	 * 获取所有交易编号
	 * @return
	 * @throws Exception
	 */
	public static String[] getTransactionCodes() throws Exception{
		return transactionConfigs.getCacheObjects().keySet().toArray(new String[0]);
	}

	@Override
	public synchronized void init(String file,int size)  throws Exception {
		file = ARE.replaceARETags(file);
		Document document = getDocument(file);
		Element root = document.getRootElement();
		BusinessObjectCache transactionConfigs=new BusinessObjectCache(size);
		
		List<BusinessObject> transactionList = this.convertToBusinessObjectList(root.getChildren(JBO_NAME_TRANSACTION_CONFIG));
		if (transactionList!=null) {
			for (BusinessObject transaction : transactionList) {
				transactionConfigs.setCache(transaction.getString("TransactionCode"), transaction);
			}
		}
		TransactionConfig.transactionConfigs = transactionConfigs;
	}
}
