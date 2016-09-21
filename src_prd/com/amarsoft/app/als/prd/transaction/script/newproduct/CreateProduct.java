package com.amarsoft.app.als.prd.transaction.script.newproduct;

import java.util.List;

import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.app.als.prd.web.ProductCatalogManager;
import com.amarsoft.app.als.prd.web.ProductTransactionManager;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

public final class CreateProduct extends TransactionProcedure {
	@Override
	public int run() throws Exception {

		BusinessObject inputParameters = transaction
				.getBusinessObject("InputParameters");
		BusinessObject businessParameters = inputParameters
				.getBusinessObject("BusinessParameters");
		BusinessObject product = BusinessObjectFactory.createBusinessObject(
				ProductConfig.PRODUCT_CONFIG_PRODUCT, businessParameters,
				false, bomanager);
		product.setAttributeValue("Status", "0");
		// 产品对象放入管理器
		bomanager.updateBusinessObject(product);
		transaction.setAttributeValue(ProductConfig.PRODUCT_CONFIG_PRODUCT,
				product);
		transaction.setAttributeValue("ObjectNo",
				product.getString("ProductID"));
		transaction.setAttributeValue("ObjectType",
				ProductConfig.PRODUCT_CONFIG_PRODUCT);

		String productCatalogType = businessParameters.getString("CatalogType");
		ProductCatalogManager pcmanager = new ProductCatalogManager();
		pcmanager.setBusinessObjectManager(bomanager);
		if (!StringX.isEmpty(productCatalogType))
			// ProductCatalogManager pcmanager = new ProductCatalogManager();
			// pcmanager.setBusinessObjectManager(bomanager);
			pcmanager.importProduct("Standard", productCatalogType,
					product.getString("ProductID"));
		ProductTransactionManager ptmanager = new ProductTransactionManager();
		// 将此次交易生成的产品版本关联到当前交易
		List<BusinessObject> specificList = product
				.getBusinessObjects(ProductConfig.PRODUCT_CONFIG_SPECIFICATION);
		bomanager.updateBusinessObjects(specificList);
		if (specificList != null)
			for (BusinessObject specific : specificList) {
				BusinessObject specificTR = ptmanager
						.createTransactionRelative(transaction.getKeyString(),
								specific, "C");
				transaction.appendBusinessObject(
						ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE,
						specificTR);
				bomanager.updateBusinessObject(specificTR);
			}
		// 将此次交易生成的关联产品信息
		List<BusinessObject> relativeProductList = product
				.getBusinessObjects(ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE);
		bomanager.updateBusinessObjects(relativeProductList);
		if (relativeProductList != null)
			for (BusinessObject relativeProduct : relativeProductList) {
				String objecttype = relativeProduct.getString("OBJECTTYPE");
				String objectno = relativeProduct.getString("OBJECTNO");
				if (!ProductConfig.PRODUCT_CONFIG_PRODUCT.equals(objecttype))
					continue;
				BusinessObject reProduct = pcmanager.getBusinessObjectManager()
						.loadBusinessObject(objecttype, objectno);
				BusinessObject relativeProductTR = ptmanager
						.createTransactionRelative(transaction.getKeyString(),
								reProduct, "C");
				transaction.appendBusinessObject(
						ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE,
						relativeProductTR);
				bomanager.updateBusinessObject(relativeProductTR);
			}

		BusinessObject tr = ptmanager.createTransactionRelative(
				transaction.getKeyString(), product, "C");
		transaction.appendBusinessObject(
				ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE, tr);
		bomanager.updateBusinessObject(tr);
		return 1;
	}

}
