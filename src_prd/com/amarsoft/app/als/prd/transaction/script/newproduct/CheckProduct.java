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
				return "false@����ͬ��Ʒ��ŵĲ�Ʒ����������!";
			return "false@��Ʒ����ѱ�ռ��!";
		} catch (Exception e) {
			return "true";
		}

	}
}
