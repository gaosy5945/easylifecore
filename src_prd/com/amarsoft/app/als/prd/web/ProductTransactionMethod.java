package com.amarsoft.app.als.prd.web;

import java.util.List;

import com.amarsoft.app.als.awe.script.WebBusinessProcessor;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOTransaction;

public class ProductTransactionMethod extends WebBusinessProcessor {

	/**
	 * 修改一个产品规格
	 * 
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String newSpecific(JBOTransaction tx) throws Exception {
		this.setTx(tx);
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		String transactionSerialNo = this.getStringValue("TransactionSerialNo");
		
		ProductSpecificManager psm = new ProductSpecificManager();
		psm.setTx(tx);
		psm.setInputParameter(inputParameter);
		BusinessObject specific = psm.newSpecific(tx);

		ProductTransactionManager ptmanager = new ProductTransactionManager();
		BusinessObject transactionRelative = ptmanager
				.createTransactionRelative(transactionSerialNo, specific, "C");
		bomanager.updateBusinessObject(specific);
		bomanager.updateBusinessObject(transactionRelative);
		bomanager.updateDB();
		return "1";
	}
	
	/**
	 * 修改一个产品规格
	 * 
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String modifySpecific(JBOTransaction tx) throws Exception {
		this.setTx(tx);
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		String transactionSerialNo = this.getStringValue("TransactionSerialNo");
		
		ProductSpecificManager psm = new ProductSpecificManager();
		psm.setInputParameter(this.inputParameter);
		BusinessObject specific = psm.copySpecific(tx);

		ProductTransactionManager ptmanager = new ProductTransactionManager();
		BusinessObject transactionRelative = ptmanager.createTransactionRelative(transactionSerialNo, specific,"M");
		bomanager.updateBusinessObject(specific);
		bomanager.updateBusinessObject(transactionRelative);
		bomanager.updateDB();
		return "1";
	}


	/**
	 * 修改一个产品规格
	 * 
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String disableSpecific(JBOTransaction tx) throws Exception {
		this.setTx(tx);
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		String transactionSerialNo = this.getStringValue("TransactionSerialNo");
		String specificSerialNo = this.getStringValue("SpecificSerialNo");
		BusinessObject specific = bomanager.keyLoadBusinessObject(
				ProductConfig.PRODUCT_CONFIG_SPECIFICATION, specificSerialNo);

		ProductTransactionManager ptmanager = new ProductTransactionManager();
		BusinessObject transactionRelative = ptmanager
				.createTransactionRelative(transactionSerialNo, specific, "D");
		bomanager.updateBusinessObject(transactionRelative);
		bomanager.updateDB();
		return "1";
	}

	/**
	 * 修改一个产品规格
	 * 
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String deleteTransactionSpecific(JBOTransaction tx) throws Exception {
		this.setTx(tx);
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		String transactionSerialNo = this.getStringValue("TransactionSerialNo");
		String specificSerialNo = this.getStringValue("SpecificSerialNo");
		List<BusinessObject> l = bomanager
				.loadBusinessObjects(
						ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE,
						"TransactionSerialNo=:TransactionSerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType",
						"TransactionSerialNo", transactionSerialNo, "ObjectNo",
						specificSerialNo, "ObjectType",
						ProductConfig.PRODUCT_CONFIG_SPECIFICATION);
		if (l.isEmpty())
			return "1";
		BusinessObject tr = l.get(0);
		if (!"D".equals(tr.getString("RELATIVETYPE")))
		{
			ProductSpecificManager psm = new ProductSpecificManager();
			psm.setInputParameter(this.inputParameter);
			psm.deleteSpecific(tx);
		}
		bomanager.deleteBusinessObject(tr);
		bomanager.updateDB();
		return "1";
	}

	/**
	 * 修改一个产品规格
	 * 
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String copySpecific(JBOTransaction tx) throws Exception {
		this.setTx(tx);
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		String transactionSerialNo = this.getStringValue("TransactionSerialNo");
		ProductSpecificManager psm = new ProductSpecificManager();
		psm.setInputParameter(this.inputParameter);
		BusinessObject specific = psm.copySpecific(tx);
		
		ProductTransactionManager ptmanager = new ProductTransactionManager();
		BusinessObject transactionRelative = ptmanager
				.createTransactionRelative(transactionSerialNo, specific, "C");
		bomanager.updateBusinessObject(transactionRelative);
		bomanager.updateDB();
		return "1";
	}
}
