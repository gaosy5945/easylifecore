package com.amarsoft.app.als.prd.transaction.script.modifyproduct;

import java.util.List;

import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.app.als.prd.web.ProductManager;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;

public class ExecuteTransaction extends TransactionProcedure {

	@Override
	public int run() throws Exception {
		// 1.更新交易状态
		transaction.setAttributeValue("Status",
				ProductConfig.PRODUCT_TRANSACTION_STATUS_Finish);
		bomanager.updateBusinessObject(transaction);
		// 2.更新规格状态和建立产品关联
		String productID = transaction.getString("ObjectNo");
		String transactionSerialNo = transaction.getKeyString();

		ProductManager productManager = new ProductManager();
		// 获取所有与当前交易有关的规格
		List<BusinessObject> specificTRList = bomanager
				.loadBusinessObjects(
						ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE,
						"ObjectType=:ObjectType and TransactionSerialNo=:TransactionSerialNo",
						"ObjectType",ProductConfig.PRODUCT_CONFIG_SPECIFICATION
								,"TransactionSerialNo",transactionSerialNo);
		for (BusinessObject specificTR : specificTRList) {
			String relativeType = specificTR.getString("RelativeType");
			String specificSerialNo = specificTR.getString("ObjectNo");
			if (relativeType.equals("C")) {
				BusinessObject specific = bomanager.loadBusinessObject(
						ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
						specificSerialNo);
				specific.setAttributeValue("Status", "1");
				bomanager.updateBusinessObject(specific);
				// 4.建立产品关联，先删除后建立
				List<BusinessObject> dreProductList = bomanager
						.loadBusinessObjects(
								ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE,
								"ProductID=:ProductID and ObjectType=:ObjectType and ObjectNo=:ObjectNo",
								"ProductID", productID, "ObjectType",
								ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
								"ObjectNo", specificSerialNo);
				bomanager.deleteBusinessObjects(dreProductList);
				BusinessObject newpr = productManager.createProductRelative(
						productID, specific, "03");
				bomanager.updateBusinessObject(newpr);
			} else if (relativeType.equals("M")) {
				// 1.将修改版本生效
				BusinessObject specific = bomanager.loadBusinessObject(
						ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
						specificSerialNo);
				specific.setAttributeValue("Status", "1");
				bomanager.updateBusinessObject(specific);
				// 2.将历史版本失效
				String specificID = specific.getString("SpecificID");
				List<BusinessObject> oldSpecificList = bomanager
						.loadBusinessObjects(
								ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
								"O.Status='1' and O.SpecificID='"
										+ specificID
										+ "' and "
										+ "O.SerialNo in (select PR.ObjectNo from jbo.prd.PRD_PRODUCT_RELATIVE PR where PR.ProductID='"
										+ productID
										+ "' and PR.ObjectType='"
										+ ProductConfig.PRODUCT_CONFIG_SPECIFICATION
										+ "')");
				if (oldSpecificList != null) {
					for (BusinessObject oldSpecific : oldSpecificList)
						oldSpecific.setAttributeValue("Status", "2");
					bomanager.updateBusinessObjects(oldSpecificList);
				}

				List<BusinessObject> dreProductList = bomanager
						.loadBusinessObjects(
								ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE,
								"ProductID=:ProductID and ObjectType=:ObjectType and ObjectNo=:ObjectNo",
								"ProductID", productID, "ObjectType",
								ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
								"ObjectNo", specificSerialNo);
				bomanager.updateBusinessObjects(dreProductList);
				BusinessObject newpr = productManager.createProductRelative(
						productID, specific, "03");
				bomanager.updateBusinessObject(newpr);
			} else if (relativeType.equals("D")) {
				BusinessObject specific = bomanager.loadBusinessObject(
						ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
						specificSerialNo);
				specific.setAttributeValue("Status", "2");
				bomanager.updateBusinessObject(specific);
			}
		}

		return 1;
	}

}
