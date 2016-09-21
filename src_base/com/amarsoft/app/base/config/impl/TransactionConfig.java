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
 * ���㽻���������
 * 
 * @author �����Ʒ��
 * @author xyqu 2014��6��17�� �������롢���ע��
 * 
 */
public final class TransactionConfig extends XMLConfig {
	public static final String JBO_NAME_TRANSACTION_CONFIG="TransactionConfig";
	public static final String JBO_NAME_PROCEDURE_CONFIG="Procedure";
	
	public static final String TRANSACTION_STATUS_0="0";//������
	public static final String TRANSACTION_STATUS_1="1";//����Ч
	public static final String TRANSACTION_STATUS_2="2";//�ѷ���
	
	/**
	 * ����������Ϣ
	 */
	private static BusinessObjectCache transactionConfigs=new BusinessObjectCache(1000);

	
	
	//����ģʽ
	private static TransactionConfig tc = null;
	
	private TransactionConfig(){
		
	}
	
	public static TransactionConfig getInstance(){
		if(tc == null)
			tc = new TransactionConfig();
		return tc;
	}
	
	/**
	 * ��ȡ����������Ϣ
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
	 * ��ȡ��������
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
	 * ��ȡ�������õ�����
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
	 * ��ȡ���н��ױ��
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
