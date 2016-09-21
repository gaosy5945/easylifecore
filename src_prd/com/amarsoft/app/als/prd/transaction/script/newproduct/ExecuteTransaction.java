package com.amarsoft.app.als.prd.transaction.script.newproduct;

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
		// 2.更新产品状态
		BusinessObject product = transaction
				.getBusinessObject(ProductConfig.PRODUCT_CONFIG_PRODUCT);
		if (product == null)
			product = bomanager.loadBusinessObject(
					transaction.getString("ObjectType"),
					transaction.getString("ObjectNo"));
		product.setAttributeValue("Status", "1");
		bomanager.updateBusinessObject(product);

		String productID = product.getString("PRODUCTID");
		String transactionSerialNo = transaction.getKeyString();
		// 3.先删除方案产品与基础产品间的关系
		List<BusinessObject> dspecificTRList = bomanager.loadBusinessObjects(
				ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE,
				"ProductID=:ProductID and ObjectType=:ObjectType ",
				"ProductID", productID, "ObjectType",
				ProductConfig.PRODUCT_CONFIG_PRODUCT);
		bomanager.deleteBusinessObjects(dspecificTRList);
		// 4.更新规格状态和建立产品关联
		ProductManager productManager = new ProductManager();
		// 获取所有与当前交易有关的规格
		List<BusinessObject> specificTRList = bomanager
				.loadBusinessObjects(
						ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE,
						"ObjectType=:ObjectType and TransactionSerialNo=:TransactionSerialNo",
						"ObjectType",
						ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
						"TransactionSerialNo", transactionSerialNo);
		for (BusinessObject specificTR : specificTRList) {
			String relativeType = specificTR.getString("RelativeType");
			String specificSerialNo = specificTR.getString("ObjectNo");
			if (relativeType.equals("C") || relativeType.equals("M")) {
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

				// 如果是方案产品，则建立方案产品与基础产品间的关系，先删除后建立
				if (!productID.equals(specific.getString("ProductID"))) {
					BusinessObject newpr1 = productManager
							.createProductRelative(productID,
									ProductConfig.PRODUCT_CONFIG_PRODUCT,
									specific.getString("ProductID"), "01");
					bomanager.updateBusinessObject(newpr1);
				}
			}
		}

		return 1;
	}

}
