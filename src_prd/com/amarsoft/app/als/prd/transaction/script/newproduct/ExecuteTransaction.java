package com.amarsoft.app.als.prd.transaction.script.newproduct;

import java.util.List;

import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.app.als.prd.web.ProductManager;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;

public class ExecuteTransaction extends TransactionProcedure {

	@Override
	public int run() throws Exception {
		// 1.���½���״̬
		transaction.setAttributeValue("Status",
				ProductConfig.PRODUCT_TRANSACTION_STATUS_Finish);
		bomanager.updateBusinessObject(transaction);
		// 2.���²�Ʒ״̬
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
		// 3.��ɾ��������Ʒ�������Ʒ��Ĺ�ϵ
		List<BusinessObject> dspecificTRList = bomanager.loadBusinessObjects(
				ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE,
				"ProductID=:ProductID and ObjectType=:ObjectType ",
				"ProductID", productID, "ObjectType",
				ProductConfig.PRODUCT_CONFIG_PRODUCT);
		bomanager.deleteBusinessObjects(dspecificTRList);
		// 4.���¹��״̬�ͽ�����Ʒ����
		ProductManager productManager = new ProductManager();
		// ��ȡ�����뵱ǰ�����йصĹ��
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
				// 4.������Ʒ��������ɾ������
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

				// ����Ƿ�����Ʒ������������Ʒ�������Ʒ��Ĺ�ϵ����ɾ������
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
