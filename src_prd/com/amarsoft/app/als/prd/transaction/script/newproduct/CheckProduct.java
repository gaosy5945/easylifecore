package com.amarsoft.app.als.prd.transaction.script.newproduct;

import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

public class CheckProduct {
	private String productId;

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String checkProduct() throws Exception {
		BusinessObjectManager bom = new BusinessObjectManager();
		BusinessObject product = bom.keyLoadBusinessObject(
				ProductConfig.PRODUCT_CONFIG_PRODUCT, productId);
		try {
			String status = product.getString("Status");
			if (product == null)
				return "true";
			else if (status.equals("0"))
				return "false@有相同产品编号的产品正在申请中!";
			return "false@产品编号已被占用!";
		} catch (Exception e) {
			return "true";
		}

	}
}
