package com.amarsoft.app.als.prd.transaction.script.changestatus;

import java.util.List;

import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;

public class UpdateProductStatus extends TransactionProcedure {

	@Override
	public int run() throws Exception {
		transaction.setAttributeValue("Status",
				ProductConfig.PRODUCT_TRANSACTION_STATUS_Finish);
		bomanager.updateBusinessObject(transaction);

		BusinessObject product = transaction
				.getBusinessObject(ProductConfig.PRODUCT_CONFIG_PRODUCT);
		if (product == null)
			product = bomanager.loadBusinessObject(
					transaction.getString("ObjectType"),
					transaction.getString("ObjectNo"));
		product.setAttributeValue("Status", "2");
		bomanager.updateBusinessObject(product);
		// 该版本的所有规格全部停用
		List<BusinessObject> specificList = bomanager.loadBusinessObjects(
				ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
				"O.ProductID=:ProductID", "ProductID",
				product.getString("ProductID"));
		if (specificList != null)
			for (BusinessObject specific : specificList) {
				specific.setAttributeValue("Status", "2");
				bomanager.updateBusinessObject(specific);
			}
		return 1;
	}

}
