package com.amarsoft.app.als.prd.web;

import java.util.List;

import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;
import com.amarsoft.app.als.businessobject.action.impl.SimpleObjectLoader;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.app.als.transaction.AbstractTransactionManager;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.BizObjectKey;
import com.amarsoft.are.jbo.impl.StateBizObject;
import com.amarsoft.are.lang.StringX;

public class ProductTransactionManager extends AbstractTransactionManager {

	@Override
	public List<BusinessObject> load(List<BusinessObject> businessObjectList,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {
		SimpleObjectLoader sl = new SimpleObjectLoader();
		List<BusinessObject> list = sl.load(businessObjectList,
				inputParameters, bomanager);

		for (BusinessObject prdTransaction : list) {
			BusinessObject product = bomanager.loadBusinessObject(
					prdTransaction.getString("ObjectType"),
					prdTransaction.getString("ObjectNo"));
			prdTransaction
					.setAttributeValue(product.getBizClassName(), product);
			prdTransaction
					.setAttributeValue("InputParameters", inputParameters);
			this.executeScript(prdTransaction, "load", bomanager);
		}
		return list;
	}

	@Override
	public int delete(List<BusinessObject> businessObjectList,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {
		List<BusinessObject> l = this.load(businessObjectList, inputParameters,
				bomanager);
		for (BusinessObject transaction : l) {
			this.executeScript(transaction, "delete", bomanager);
			// 删除交易输入输出参数
			List<BusinessObject> list = bomanager.loadBusinessObjects(
					ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE,
					"TransactionSerialNo=:TransactionSerialNo",
					"TransactionSerialNo=" + transaction.getKeyString());
			if (list != null)
				for (BusinessObject relative : list) {
					bomanager.deleteBusinessObject(relative);
					if (relative.getString("RELATIVETYPE").equals("C")
							|| relative.getString("RELATIVETYPE").equals("M"))
						BusinessObjectFactory.delete(
								relative.getString("ObjectType"),
								relative.getString("ObjectNo"), bomanager);
				}
			// 删除交易信息
			bomanager.deleteBusinessObject(transaction);
		}
		bomanager.updateDB();
		return 1;
	}

	@Override
	public int save(List<BusinessObject> transactionList,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {
		for (BusinessObject transaction : transactionList) {
			if (transaction.getState() != StateBizObject.STATE_NEW) {
				transaction.setAttributeValue("InputParameters",
						inputParameters);
				this.executeScript(transaction, "update", bomanager);
			}
			transaction.removeAttribute("InputParameters");
			bomanager.updateBusinessObject(transaction);
		}
		bomanager.updateDB();
		return 1;
	}

	@Override
	public List<BusinessObject> copy(List<BusinessObject> businessObjectList,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {
		return null;
	}

	@Override
	public BusinessObject create(BizObjectClass bizObjectClass,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {
		BusinessObject productTransaction = BusinessObject
				.createBusinessObject(ProductConfig.PRODUCT_TRANSACTION_JBOCLASS);
		productTransaction.generateKey();

		String transactionGroup = inputParameters.getString("TransactionGroup");
		String transactionCode = inputParameters.getString("TransactionCode");
		if (StringX.isEmpty(transactionGroup))
			throw new Exception("创建交易时，未传入参数{TransactionGroup}");
		if (StringX.isEmpty(transactionCode))
			throw new Exception("创建交易时，未传入参数{TransactionCode}");
		productTransaction.setAttributeValue("TransCode",
				inputParameters.getString("TransactionCode"));
		productTransaction.setAttributeValue("TransName", TransactionConfig
				.getTransactionConfig(transactionCode, "TramsactionName"));
		productTransaction.setAttributeValue("Status",
				ProductConfig.PRODUCT_TRANSACTION_STATUS_New);

		String transCode = inputParameters.getString("TransactionCode");

		BusinessObject systemParameters = inputParameters
				.getBusinessObject("SystemParameters");
		if (transCode.equals("0020") || transCode.equals("0040"))
			systemParameters = inputParameters;
		productTransaction.setAttributeValue("InputDate",
				DateHelper.getBusinessDate());
		productTransaction.setAttributeValue("InputUserID",
				systemParameters.getString("CurUserID"));
		productTransaction.setAttributeValue("InputOrgID",
				systemParameters.getString("CurOrgID"));

		productTransaction
				.setAttributeValue("InputParameters", inputParameters);

		BusinessObject businessParameters = inputParameters
				.getBusinessObject("BusinessParameters");
		if (transCode.equals("0020") || transCode.equals("0040"))
			businessParameters = inputParameters;
		if (businessParameters != null) {
			String productID = businessParameters.getString("ProductID");
			if (!StringX.isEmpty(productID)) {
				productTransaction.setAttributeValue("ObjectType",
						ProductConfig.PRODUCT_CONFIG_PRODUCT);
				productTransaction.setAttributeValue("ObjectNo", productID);
				this.executeScript(productTransaction, "create", bomanager);
			}
		}
		return productTransaction;
	}

	public BusinessObject createTransactionRelative(String transactionSerialNo,
			BusinessObject relativeObject, String relativeType)
			throws Exception {
		BusinessObject transactionRelative = BusinessObject
				.createBusinessObject(ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE);
		transactionRelative.setAttributeValue("TransactionSerialNo",
				transactionSerialNo);
		transactionRelative.setAttributeValue("OBJECTTYPE",
				relativeObject.getBizClassName());
		transactionRelative.setAttributeValue("OBJECTNO",
				relativeObject.getKeyString());
		transactionRelative.setAttributeValue("RELATIVETYPE", relativeType);
		transactionRelative.generateKey();
		return transactionRelative;
	}

	@Override
	public BusinessObject getTransactionConfig(BusinessObject transaction)
			throws Exception {
		return TransactionConfig.getTransactionConfig(transaction
				.getString("TransCode"));
	}

	@Override
	public int delete(BizObjectKey[] objectKeyArray,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<BusinessObject> load(BizObjectKey[] bizObjectKeyArray,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

}
