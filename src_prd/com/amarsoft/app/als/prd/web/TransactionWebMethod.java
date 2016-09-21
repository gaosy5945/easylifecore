package com.amarsoft.app.als.prd.web;

import java.util.HashMap;
import java.util.Map;

import com.amarsoft.app.als.awe.script.WebBusinessProcessor;
import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONElement;
import com.amarsoft.are.util.json.JSONEncoder;
import com.amarsoft.are.util.json.JSONObject;

/**
 * 产品规格页面发布新版本按钮处理逻辑
 * 
 * @author Administrator
 *
 */
public class TransactionWebMethod extends WebBusinessProcessor {

	public String getTransactionConfig(JBOTransaction tx) throws Exception {
		this.setTx(tx);
		String transactionGroup = getStringValue("TransactionGroup");
		String transactionCode = getStringValue("TransactionCode");
		String attributes = getStringValue("Attributes");
		BusinessObject businessObject = TransactionConfig
				.getTransactionConfig(transactionCode);
		String[] attributeArray = attributes.split("@");
		JSONObject result = JSONObject.createObject();
		for (String attributeID : attributeArray)
			result.appendElement(JSONElement.valueOf(attributeID,
					businessObject.getObject(attributeID)));
		return JSONEncoder.encode(result);
	}

	public String createTransaction(JBOTransaction tx) throws Exception {
		this.setTx(tx);
		String transactionGroup = this.getStringValue("TransactionGroup");
		String transactionCode = this.getStringValue("TransactionCode");
		JSONObject businessParameters = (JSONObject) this.inputParameter
				.getValue("BusinessParameters");
		Object productId = businessParameters.getValue("ProductID");
		JSONObject systemParameters = (JSONObject) this.inputParameter
				.getValue("SystemParameters");
		Object curOrgID = systemParameters.getValue("CurOrgID");
		Object curUserID = systemParameters.getValue("CurUserID");
		Map<String, Object> temp = new HashMap<String, Object>();
		temp.put("TransactionGroup", transactionGroup);
		temp.put("TransactionCode", transactionCode);
		temp.put("ProductID", productId);
		temp.put("CurOrgID", curOrgID);
		temp.put("CurUserID", curUserID);
		BusinessObject inputParameters = BusinessObject
				.createBusinessObject(temp);
		BusinessObject transaction = BusinessObjectFactory
				.createBusinessObject(transactionGroup, inputParameters, true,
						getBusinessObjectManager());
		BusinessObjectFactory.save(transaction, getBusinessObjectManager());
		this.getBusinessObjectManager().updateDB();
		this.getBusinessObjectManager().commit();
		return transaction.getKeyString();
	}

	public String changeTransactionStatus(JBOTransaction tx) throws Exception {
		this.setTx(tx);
		String transactionGroup = this.getStringValue("TransactionGroup");
		String transactionSerialNo = this.getStringValue("TransactionSerialNo");
		String status = this.getStringValue("NextTransactionStatus");
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject transaction = bomanager.loadBusinessObject(
				transactionGroup, transactionSerialNo);
		transaction.setAttributeValue("Status", status);// 0待提交，1已完成，2退回，3审批中，4审核通过
		bomanager.updateBusinessObject(transaction);
		bomanager.updateDB();
		bomanager.commit();
		return "1";
	}

	public String runTransaction(JBOTransaction tx) throws Exception {
		this.setTx(tx);
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		String transactionGroup = this.getStringValue("TransactionGroup");
		String transactionSerialNo = this.getStringValue("TransactionSerialNo");
		BusinessObject transaction = BusinessObjectFactory.loadSingle(
				transactionGroup, transactionSerialNo, bomanager);
		ProductTransactionManager ptmanager = new ProductTransactionManager();
		ptmanager.executeScript(transaction, "execute", bomanager);
		bomanager.updateDB();
		bomanager.commit();
		return "1";
	}

	public String deleteTransaction(JBOTransaction tx) throws Exception {
		this.setTx(tx);
		String transactionGroup = this.getStringValue("TransactionGroup");
		String transactionSerialNo = this.getStringValue("TransactionSerialNo");
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObjectFactory.delete(transactionGroup, transactionSerialNo,
				bomanager);
		bomanager.updateDB();
		bomanager.commit();
		return "1";
	}

}
