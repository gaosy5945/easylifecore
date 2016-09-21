package com.amarsoft.app.als.prd.transaction.script.modifyproduct;

import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.app.als.prd.web.ProductTransactionManager;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.util.json.JSONEncoder;

public class UpdateProduct {

	public static int execute(BusinessObject transaction,
			BusinessObjectManager bomanager) throws Exception {
		BusinessObject inputParameters = transaction
				.getBusinessObject("InputParameters");
		BusinessObject businessParameters = inputParameters
				.getBusinessObject("BusinessParameters");
		BusinessObject productParameters = businessParameters
				.getBusinessObject(ProductConfig.PRODUCT_CONFIG_PRODUCT);
		String productID = productParameters.getString("ProductID");
		String transactionSerialNo = transaction.getKeyString();

		BusinessObject product = bomanager.loadBusinessObject(
				ProductConfig.PRODUCT_CONFIG_PRODUCT, productID);
		BusinessObject changedData = getChangedData(productParameters, product);

		String data = JSONEncoder.encode(changedData.toJSONObject());

		ProductTransactionManager productTransactionManager = new ProductTransactionManager();
		BusinessObject tr = productTransactionManager
				.createTransactionRelative(transactionSerialNo, product, "M");
		tr.setAttributeValue("DATA", data);
		bomanager.updateBusinessObject(tr);
		return 1;
	}

	public static BusinessObject getChangedData(
			BusinessObject productParameters, BusinessObject product)
			throws Exception {
		BusinessObject changedData = BusinessObject.createBusinessObject();
		String[] attributeIDArray = productParameters.getAttributeIDArray();
		for (String attributeID : attributeIDArray)
			if (product.containsAttribute(attributeID)) {
				Object newValue = productParameters.getObject(attributeID);
				Object oldValue = product.getObject(attributeID);
				if (newValue == null)
					newValue = "";
				if (oldValue == null)
					oldValue = "";
				if (!newValue.equals(oldValue))
					changedData.setAttributeValue(attributeID, newValue);
			}
		return changedData;
	}
}
