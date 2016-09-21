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

		// �����Ʒ���ͻ򷽰���Ʒ��Ӧ�Ļ�����Ʒ�����仯������²�Ʒ��Ϣ����Ҫ�ǹ��͹�����Ϣ
		String newProductType1 = businessParameters.getString("ProductType1");
		if (newProductType1 == null)
			newProductType1 = "";
		String oldProductType1 = product.getString("ProductType1");
		if (oldProductType1 == null)
			oldProductType1 = "";
		// 1.���²�Ʒ������Ϣ
		if (!oldProductType1.equals(newProductType1))
			changeProductType1(transaction, bomanager);
		else if (newProductType1
				.equals(ProductConfig.PRODUCT_TYPE_PROJECT_PRODUCT)) {
			String newRelativeProductList = businessParameters
					.getString("RELATIVEPRODUCTLIST");
			if (newRelativeProductList.indexOf(",") > 0)// ���������Ʒֻ����һ��������Ʒ�����Զ���ʼ��������Ʒ������������Ʒ
				changePrjBaseProduct(transaction, newRelativeProductList,
						bomanager);
		}
		// 2.���²�Ʒ��Ϣ���½���Ʒ������ֱ�Ӹ���
		product.setAttributesValue(productParameters);
		bomanager.updateBusinessObject(product);

		// 3.���²�ƷĿ¼���˴�����ֱ�Ӹ��£�Ӧ���ڽ���ִ��ʱ����
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
		// �����Ʒ���ͻ򷽰���Ʒ��Ӧ�Ļ�����Ʒ�����仯������²�Ʒ��Ϣ����Ҫ�ǹ��͹�����Ϣ
		String newProductType1 = businessParameters.getString("ProductType1");
		if (newProductType1 == null)
			newProductType1 = "";

		// 1.����ǰ����������TransactionRelative�еĹ�������Ϣȫ��ɾ��
		List<BusinessObject> specificTRList = bomanager
				.loadBusinessObjects(
						ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE,
						"ObjectType=:ObjectType and TransactionSerialNo=:TransactionSerialNo",
						"ObjectType",
						ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
						"TransactionSerialNo", transactionSerialNo);
		bomanager.deleteBusinessObjects(specificTRList);

		/*
		 * //2.��Ʒ�е�ǰ�Ѿ���Ч�����а汾����ɾ����ǣ�������Ч��ɾ���������½���Ʒ���ף��˲��������� List<BusinessObject>
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
		// 3.ֱ��ɾ����ǰ�����µ������½����޸ĵĹ����Ϣ
		for (BusinessObject specificTR : specificTRList) {
			String relativeType = specificTR.getString("RelativeType");
			String specificSerialNo = specificTR.getString("ObjectNo");
			if (relativeType.equals("C") || relativeType.equals("M")) {
				BusinessObjectFactory.delete(
						ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
						specificSerialNo, bomanager);// ɾ�����й��
				transaction.removeBusinessObject(
						ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
						bomanager.keyLoadBusinessObject(
								ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
								specificSerialNo));
			}
		}
		// 4.�½������Ϣ
		ProductManager productManager = new ProductManager();
		if (newProductType1.equals(ProductConfig.PRODUCT_TYPE_BASIC_PRODUCT)) {// ������Ʒ
			BusinessObject specific = productManager
					.createBasicProductSpecific(productID, bomanager);
			bomanager.updateBusinessObject(specific);
			// ��ֱ�ӹ�������Ʒ�����µĹ���������ǰ����
			bomanager.updateBusinessObject(productTransactionManager
					.createTransactionRelative(transactionSerialNo, specific,
							"C"));
		} else if (newProductType1
				.equals(ProductConfig.PRODUCT_TYPE_PROJECT_PRODUCT)) {// ������Ʒ
			String newRelativeProductList = businessParameters
					.getString("RELATIVEPRODUCTLIST");
			if (newRelativeProductList == null)
				newRelativeProductList = "";

			List<BusinessObject> newSpecificList = productManager
					.createPrjProductSpecific(productID,
							newRelativeProductList, bomanager);
			bomanager.updateBusinessObjects(newSpecificList);
			// ��ֱ�ӹ�������Ʒ�����µĹ���������ǰ����
			for (BusinessObject newSpecific : newSpecificList)
				// ��ֱ�ӹ�������Ʒ�����µĹ���������ǰ����
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

		// 1.����ǰ����������TransactionRelative�еĹ�������Ϣȫ��ɾ������Ϊ�����˷�����Ʒ�����޸ģ����Կ���ֱ��ɾ������������
		List<BusinessObject> specificTRList = bomanager
				.loadBusinessObjects(
						ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE,
						"ObjectType=:ObjectType and TransactionSerialNo=:TransactionSerialNo",
						"ObjectType="
								+ ProductConfig.PRODUCT_CONFIG_SPECIFICATION
								+ ";TransactionSerialNo=" + transactionSerialNo);
		bomanager.deleteBusinessObjects(specificTRList);

		/*
		 * //2.��Ʒ�е�ǰ�Ѿ���Ч�����а汾����ɾ����ǣ�������Ч��ɾ���������½���Ʒ���ף��˲��������� List<BusinessObject>
		 * specificList =
		 * product.getListValue(ProductConfig.PRODUCT_CONFIG_SPECIFICATION);
		 * for(BusinessObject specific:specificList){ BusinessObject tr =
		 * productTransactionManager
		 * .createTransactionRelative(transactionSerialNo, specific, "D");
		 * bomanager.updateBusinessObject(tr);
		 * this.transaction.appendAttributeValue
		 * (ProductConfig.PRODUCT_CONFIG_TRANSACTION_RELATIVE, tr); }
		 */
		// 3.ֱ��ɾ����ǰ�����µ������½����޸ĵĹ����Ϣ
		for (BusinessObject specificTR : specificTRList) {
			String relativeType = specificTR.getString("RelativeType");
			String specificSerialNo = specificTR.getString("ObjectNo");
			if (relativeType.equals("C") || relativeType.equals("M")) {
				BusinessObjectFactory.delete(
						ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
						specificSerialNo, bomanager);// ɾ�����й��
				transaction.removeBusinessObject(
						ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
						bomanager.keyLoadBusinessObject(
								ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
								specificSerialNo));
			}
		}
		// 4.���½��������Ϣ
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
		// ��ֱ�ӹ�������Ʒ�����µĹ���������ǰ����
		for (BusinessObject newSpecific : newSpecificList)
			// ��ֱ�ӹ�������Ʒ�����µĹ���������ǰ����
			bomanager.updateBusinessObject(productTransactionManager
					.createTransactionRelative(transactionSerialNo,
							newSpecific, "C"));
	}

}
