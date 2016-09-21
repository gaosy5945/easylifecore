package com.amarsoft.app.als.prd.transaction.script.modifyproduct;

import java.util.List;

import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.app.als.prd.web.ProductTransactionManager;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

public class CreateTransRelative {
	public static int execute(BusinessObject transaction,
			BusinessObjectManager bomanager) throws Exception {
		String productId = transaction.getString("ObjectNo");
		// ��Ʒ״̬����Ϊ����
		BusinessObject product = bomanager.keyLoadBusinessObject(
				ProductConfig.PRODUCT_CONFIG_PRODUCT, productId);

		ProductTransactionManager ptmanager = new ProductTransactionManager();

		// ���˴ν������ɵĲ�Ʒ�汾��������ǰ����
		List<BusinessObject> specificList = product
				.getBusinessObjects(ProductConfig.PRODUCT_CONFIG_SPECIFICATION);
		bomanager.updateBusinessObjects(specificList);
		if (specificList != null)
			for (BusinessObject specific : specificList) {
				BusinessObject specificTR = ptmanager
						.createTransactionRelative(transaction.getKeyString(),
								specific, "M");
				transaction.appendBusinessObject(
						ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE,
						specificTR);
				bomanager.updateBusinessObject(specificTR);
			}
		// ���˴ν������ɵĹ�����Ʒ��Ϣ
		List<BusinessObject> relativeProductList = product
				.getBusinessObjects(ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE);
		bomanager.updateBusinessObjects(relativeProductList);
		if (relativeProductList != null)
			for (BusinessObject relativeProduct : relativeProductList) {
				String objecttype = relativeProduct.getString("OBJECTTYPE");
				String objectno = relativeProduct.getString("OBJECTNO");
				if (!ProductConfig.PRODUCT_CONFIG_PRODUCT.equals(objecttype))
					continue;
				BusinessObject reProduct = bomanager.loadBusinessObject(
						objecttype, objectno);
				BusinessObject relativeProductTR = ptmanager
						.createTransactionRelative(transaction.getKeyString(),
								reProduct, "M");
				transaction.appendBusinessObject(
						ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE,
						relativeProductTR);
				bomanager.updateBusinessObject(relativeProductTR);
			}

		BusinessObject tr = ptmanager.createTransactionRelative(
				transaction.getKeyString(), product, "M");
		transaction.appendBusinessObject(
				ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE, tr);
		bomanager.updateBusinessObject(tr);
		bomanager.updateDB();
		return 1;
	}
}
