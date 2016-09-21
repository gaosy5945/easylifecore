package com.amarsoft.app.als.prd.transaction.script.newproduct;

import java.util.List;

import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.app.als.prd.web.ProductCatalogManager;
import com.amarsoft.app.als.prd.web.ProductManager;
import com.amarsoft.app.als.prd.web.ProductTransactionManager;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

public class UpdateProduct extends TransactionProcedure {

	@Override
	public int run() throws Exception {
		BusinessObject inputParameters = transaction
				.getBusinessObject("InputParameters");
		BusinessObject businessParameters = inputParameters
				.getBusinessObject("BusinessParameters");
		BusinessObject productParameters = businessParameters
				.getBusinessObject(ProductConfig.PRODUCT_CONFIG_PRODUCT);
		BusinessObject product = bomanager.loadBusinessObject(
				ProductConfig.PRODUCT_CONFIG_PRODUCT,
				businessParameters.getString("ProductID"));

		// 如果产品类型或方案产品对应的基础产品发生变化，则更新产品信息，主要是规格和关联信息
		String newProductType1 = businessParameters.getString("ProductType1");
		if (newProductType1 == null)
			newProductType1 = "";
		String oldProductType1 = product.getString("ProductType1");
		if (oldProductType1 == null)
			oldProductType1 = "";
		// 1.更新产品规格等信息
		if (!oldProductType1.equals(newProductType1))
			changeProductType1(transaction, bomanager);
		else if (newProductType1
				.equals(ProductConfig.PRODUCT_TYPE_PROJECT_PRODUCT)) {
			String newRelativeProductList = businessParameters
					.getString("RELATIVEPRODUCTLIST");
			if (newRelativeProductList.indexOf(",") > 0)// 如果方案产品只关联一个基础产品，则不自动初始化基础产品参数到方案产品
				changePrjBaseProduct(transaction, newRelativeProductList,
						bomanager);
		}
		// 2.更新产品信息，新建产品，可以直接覆盖
		product.setAttributesValue(productParameters);
		bomanager.updateBusinessObject(product);

		// 3.更新产品目录，此处不能直接更新，应该在交易执行时更新
		String productCatalogType = businessParameters.getString("CatalogType");
		if (!StringX.isEmpty(productCatalogType)) {
			ProductCatalogManager pcmanager = new ProductCatalogManager();
			pcmanager.setBusinessObjectManager(bomanager);
			pcmanager.importProduct("Standard", productCatalogType,
					product.getString("ProductID"));
		}
		return 1;
	}

	private static void changeProductType1(BusinessObject transaction,
			BusinessObjectManager bomanager) throws Exception {
		BusinessObject inputParameters = transaction
				.getBusinessObject("InputParameters");
		BusinessObject businessParameters = inputParameters
				.getBusinessObject("BusinessParameters");
		ProductTransactionManager productTransactionManager = new ProductTransactionManager();
		BusinessObject product = bomanager.loadBusinessObject(
				ProductConfig.PRODUCT_CONFIG_PRODUCT,
				businessParameters.getString("ProductID"));
		String productID = product.getString("PRODUCTID");
		String transactionSerialNo = transaction.getKeyString();
		// 如果产品类型或方案产品对应的基础产品发生变化，则更新产品信息，主要是规格和关联信息
		String newProductType1 = businessParameters.getString("ProductType1");
		if (newProductType1 == null)
			newProductType1 = "";

		// 1.将当前交易下所有TransactionRelative中的规格关联信息全部删除
		List<BusinessObject> specificTRList = bomanager
				.loadBusinessObjects(
						ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE,
						"ObjectType=:ObjectType and TransactionSerialNo=:TransactionSerialNo",
						"ObjectType",
						ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
						"TransactionSerialNo", transactionSerialNo);
		bomanager.deleteBusinessObjects(specificTRList);

		/*
		 * //2.产品中当前已经生效的所有版本，做删除标记，交易生效后删除，对于新建产品交易，此步骤无意义 List<BusinessObject>
		 * specificList =
		 * bomanager.loadBusinessObjects(ProductConfig.PRODUCT_CONFIG_SPECIFICATION
		 * ,
		 * " O.SerialNo in (select R.ObjectNo from jbo.prd.PRD_PRODUCT_RELATIVE R where R.ObjectType='"
		 * +ProductConfig.PRODUCT_CONFIG_SPECIFICATION+"' " +
		 * " and R.PRODUCTID = :ProductID)","ProductID=" + productID);
		 * for(BusinessObject specific:specificList){ BusinessObject tr =
		 * productTransactionManager
		 * .createTransactionRelative(transactionSerialNo, specific, "D");
		 * bomanager.updateBusinessObject(tr);
		 * this.transaction.appendAttributeValue
		 * (ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE, tr); }
		 */
		// 3.直接删除当前交易下的所有新建或修改的规格信息
		for (BusinessObject specificTR : specificTRList) {
			String relativeType = specificTR.getString("RelativeType");
			String specificSerialNo = specificTR.getString("ObjectNo");
			if (relativeType.equals("C") || relativeType.equals("M")) {
				BusinessObjectFactory.delete(
						ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
						specificSerialNo, bomanager);// 删除所有规格
				transaction.removeBusinessObject(
						ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
						bomanager.keyLoadBusinessObject(
								ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
								specificSerialNo));
			}
		}
		// 4.新建规格信息
		ProductManager productManager = new ProductManager();
		if (newProductType1.equals(ProductConfig.PRODUCT_TYPE_BASIC_PRODUCT)) {// 基础产品
			BusinessObject specific = productManager
					.createBasicProductSpecific(productID, bomanager);
			bomanager.updateBusinessObject(specific);
			// 不直接关联到产品，将新的规格关联到当前交易
			bomanager.updateBusinessObject(productTransactionManager
					.createTransactionRelative(transactionSerialNo, specific,
							"C"));
		} else if (newProductType1
				.equals(ProductConfig.PRODUCT_TYPE_PROJECT_PRODUCT)) {// 方案产品
			String newRelativeProductList = businessParameters
					.getString("RELATIVEPRODUCTLIST");
			if (newRelativeProductList == null)
				newRelativeProductList = "";

			List<BusinessObject> newSpecificList = productManager
					.createPrjProductSpecific(productID,
							newRelativeProductList, bomanager);
			bomanager.updateBusinessObjects(newSpecificList);
			// 不直接关联到产品，将新的规格关联到当前交易
			for (BusinessObject newSpecific : newSpecificList)
				// 不直接关联到产品，将新的规格关联到当前交易
				bomanager.updateBusinessObject(productTransactionManager
						.createTransactionRelative(transactionSerialNo,
								newSpecific, "C"));
		}
	}

	private static void changePrjBaseProduct(BusinessObject transaction,
			String newProductIDString, BusinessObjectManager bomanager)
			throws Exception {
		BusinessObject inputParameters = transaction
				.getBusinessObject("InputParameters");
		BusinessObject businessParameters = inputParameters
				.getBusinessObject("BusinessParameters");
		ProductTransactionManager productTransactionManager = new ProductTransactionManager();

		BusinessObject product = bomanager.loadBusinessObject(
				ProductConfig.PRODUCT_CONFIG_PRODUCT,
				businessParameters.getString("ProductID"));
		String productID = product.getString("PRODUCTID");
		String transactionSerialNo = transaction.getKeyString();

		// 1.将当前交易下所有TransactionRelative中的规格关联信息全部删除，因为限制了方案产品不能修改，所以可以直接删除，重新引入
		List<BusinessObject> specificTRList = bomanager
				.loadBusinessObjects(
						ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE,
						"ObjectType=:ObjectType and TransactionSerialNo=:TransactionSerialNo",
						"ObjectType="
								+ ProductConfig.PRODUCT_CONFIG_SPECIFICATION
								+ ";TransactionSerialNo=" + transactionSerialNo);
		bomanager.deleteBusinessObjects(specificTRList);

		/*
		 * //2.产品中当前已经生效的所有版本，做删除标记，交易生效后删除，对于新建产品交易，此步骤无意义 List<BusinessObject>
		 * specificList =
		 * product.getListValue(ProductConfig.PRODUCT_CONFIG_SPECIFICATION);
		 * for(BusinessObject specific:specificList){ BusinessObject tr =
		 * productTransactionManager
		 * .createTransactionRelative(transactionSerialNo, specific, "D");
		 * bomanager.updateBusinessObject(tr);
		 * this.transaction.appendAttributeValue
		 * (ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE, tr); }
		 */
		// 3.直接删除当前交易下的所有新建或修改的规格信息
		for (BusinessObject specificTR : specificTRList) {
			String relativeType = specificTR.getString("RelativeType");
			String specificSerialNo = specificTR.getString("ObjectNo");
			if (relativeType.equals("C") || relativeType.equals("M")) {
				BusinessObjectFactory.delete(
						ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
						specificSerialNo, bomanager);// 删除所有规格
				transaction.removeBusinessObject(
						ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
						bomanager.keyLoadBusinessObject(
								ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
								specificSerialNo));
			}
		}
		// 4.重新建立规格信息
		ProductManager productManager = new ProductManager();
		String newRelativeProductList = businessParameters
				.getString("RELATIVEPRODUCTLIST");
		if (newRelativeProductList == null)
			newRelativeProductList = "";

		List<BusinessObject> newSpecificList = productManager
				.createPrjProductSpecific(productID, newRelativeProductList,
						bomanager);
		transaction.setAttributeValue(
				ProductConfig.PRODUCT_CONFIG_SPECIFICATION, newSpecificList);
		// 不直接关联到产品，将新的规格关联到当前交易
		for (BusinessObject newSpecific : newSpecificList)
			// 不直接关联到产品，将新的规格关联到当前交易
			bomanager.updateBusinessObject(productTransactionManager
					.createTransactionRelative(transactionSerialNo,
							newSpecific, "C"));
	}

}
