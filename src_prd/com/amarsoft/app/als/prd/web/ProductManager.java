package com.amarsoft.app.als.prd.web;

import java.util.ArrayList;
import java.util.List;

import org.jdom.Element;

import com.amarsoft.app.als.awe.script.WebBusinessProcessor;
import com.amarsoft.app.als.businessobject.action.BusinessObjectCopier;
import com.amarsoft.app.als.businessobject.action.BusinessObjectCreator;
import com.amarsoft.app.als.businessobject.action.BusinessObjectDeleter;
import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;
import com.amarsoft.app.als.businessobject.action.BusinessObjectLoader;
import com.amarsoft.app.als.businessobject.action.BusinessObjectSaver;
import com.amarsoft.app.als.businessobject.action.BusinessObjectXMLImportor;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.base.util.XMLHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;

public class ProductManager extends WebBusinessProcessor implements
		BusinessObjectLoader, BusinessObjectDeleter, BusinessObjectSaver,
		BusinessObjectCopier, BusinessObjectCreator, BusinessObjectXMLImportor {

	/**
	 * ���Ʋ������Ʒ
	 * 
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String copyProduct(JBOTransaction tx) throws Exception {
		this.setTx(tx);
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		String productID = this.getStringValue("ProductID");
		BusinessObject inputParameters = this.getInputParameters();
		List<BusinessObject> list = BusinessObjectFactory.copy(
				ProductConfig.PRODUCT_CONFIG_PRODUCT, productID,
				inputParameters, bomanager);
		BusinessObjectFactory.getSaver(ProductConfig.PRODUCT_CONFIG_PRODUCT)
				.save(list, null, bomanager);
		bomanager.updateDB();
		return "1";
	}

	/**
	 * �˷������ã�������ֱ��ʹ��
	 * 
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String deleteProduct(JBOTransaction tx) throws Exception {
		String productID = this.getStringValue("ProductID");
		BusinessObjectFactory.delete(ProductConfig.PRODUCT_CONFIG_PRODUCT,
				productID, this.getBusinessObjectManager());
		return "1";
	}

	@Override
	public List<BusinessObject> load(List<BusinessObject> businessObjectList,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {
		String productIDString = "";
		for (BusinessObject bo : businessObjectList)
			productIDString += "," + bo.getAttribute(0);

		List<BusinessObject> list = bomanager.loadBusinessObjects(
				ProductConfig.PRODUCT_CONFIG_PRODUCT,
				" PRODUCTID in (:ProductID) ", "ProductID", productIDString
						.replaceFirst(",", "").split(","));
		for (BusinessObject product : list) {
			// ��ȡ��ƷĿ¼
			List<BusinessObject> productCatalogView = bomanager
					.loadBusinessObjects(ProductConfig.PRODUCT_CONFIG_VIEW,
							" PRODUCTID = :ProductID", "ProductID",
							product.getKeyString());
			product.setAttributeValue(ProductConfig.PRODUCT_CONFIG_VIEW,
					productCatalogView);
			// ��ȡ��Ʒ���
			List<BusinessObject> specificList = bomanager
					.loadBusinessObjects(
							ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
							" O.SerialNo in (select R.ObjectNo from jbo.prd.PRD_PRODUCT_RELATIVE R where R.ObjectType='"
									+ ProductConfig.PRODUCT_CONFIG_SPECIFICATION
									+ "' " + " and R.PRODUCTID = :ProductID)",
							"ProductID", product.getKeyString());
			for(BusinessObject specific:specificList)
			{
				specific.appendBusinessObjects(BusinessComponentConfig.BUSINESS_COMPONENT, XMLHelper.getBusinessObjectList(specific.getString("SPECIFICFILEPATH"), BusinessComponentConfig.BUSINESS_COMPONENT, "ID"));
			}
			product.setAttributeValue(
					ProductConfig.PRODUCT_CONFIG_SPECIFICATION, specificList);
			// ��ȡ��Ʒ������Ϣ
			List<BusinessObject> productRelativeList = bomanager
					.loadBusinessObjects(
							ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE,
							" PRODUCTID = :ProductID", "ProductID",
							product.getKeyString());
			product.setAttributeValue(
					ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE,
					productRelativeList);
		}
		return list;
	}

	@Override
	public int delete(List<BusinessObject> businessObjectList,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {

		String productIDString = null;

		for (BusinessObject bo : businessObjectList)
			productIDString += "," + bo.getAttribute(0).getString();

		// ɾ����Ʒ��ͼ
		bomanager.deleteBusinessObjects(bomanager.loadBusinessObjects(
				ProductConfig.PRODUCT_CONFIG_VIEW,
				" PRODUCTID in (:PRODUCTID) ", "PRODUCTID", productIDString
						.replaceFirst(",", "").split(",")));
		// ɾ����Ʒ�¹��
		List<BusinessObject> specificList = bomanager.loadBusinessObjects(
				ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
				" PRODUCTID in (:PRODUCTID) ", "PRODUCTID",
				productIDString.split(","));
		
		// ɾ����Ʒ
		bomanager.deleteBusinessObjects(bomanager.loadBusinessObjects(
				ProductConfig.PRODUCT_CONFIG_PRODUCT,
				" PRODUCTID in (:PRODUCTID) ", "PRODUCTID",
				productIDString.split(",")));

		// ɾ����Ʒ������ϵ
		bomanager.deleteBusinessObjects(bomanager.loadBusinessObjects(
				ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE,
				" PRODUCTID =:PRODUCTID ", "PRODUCTID", productIDString));
		
		for(BusinessObject specific:specificList)
		{
			ProductSpecificManager psm = new ProductSpecificManager();
			psm.setBusinessObjectManager(bomanager);
			psm.setInputParameter("SpecificSerialNo", specific.getKeyString());
			psm.deleteSpecific(bomanager.getTx());
		}
		
		return 1;
	}

	@Override
	public int save(List<BusinessObject> productList,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {

		for (BusinessObject product : productList) {
			bomanager.updateBusinessObject(product);
			String[] keys = product.getAttributeIDArray();
			for (String key : keys) {
				Object l = product.getObject(key);
				if (l instanceof List)
					for (BusinessObject o : (List<BusinessObject>) l)
						BusinessObjectFactory.save(o, bomanager);
			}
		}
		bomanager.updateDB();
		return 1;
	}

	@Override
	public List<BusinessObject> copy(List<BusinessObject> businessObjectList,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {
		List<BusinessObject> list = new ArrayList<BusinessObject>(
				businessObjectList.size());

		String newProductID = inputParameters.getString("NewProductID");
		String newProductName = inputParameters.getString("NewProductName");
		for (BusinessObject product : businessObjectList) {
			BusinessObject newProduct = BusinessObject
					.createBusinessObject(product);
			if (newProductID != null && newProductID.length() > 0)
				newProduct.setAttributeValue("PRODUCTID", newProductID);
			else
				throw new Exception("�µĲ�Ʒ��Ų���Ϊ�գ�");
			if (newProductName != null && newProductName.length() > 0)
				newProduct.setAttributeValue("PRODUCTNAME", newProductName);

			String productID = product.getString("ProductID");
			// ������ͼ������
			List<BusinessObject> productViewList = bomanager
					.loadBusinessObjects(ProductConfig.PRODUCT_CONFIG_VIEW,
							"ProductID=:ProductID", "ProductID", productID);
			for (BusinessObject productView : productViewList) {
				BusinessObject newView = BusinessObject
						.createBusinessObject(productView);
				newView.setAttributeValue("PRODUCTID", newProductID);
				newProduct.appendBusinessObject(
						ProductConfig.PRODUCT_CONFIG_VIEW, newView);
			}

			// ���Ʋ�Ʒ�����й��
			List<BusinessObject> specificList = bomanager
					.loadBusinessObjects(
							ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
							"SerialNo in (select ObjectNo from "
									+ ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE
									+ " R where R.ProductID=:ProductID"
									+ " and R.ObjectType='"
									+ ProductConfig.PRODUCT_CONFIG_SPECIFICATION
									+ "')", "ProductID", productID);
			List<Object> ls = BusinessObjectHelper.getValues(specificList,
					"SerialNo");
			String specificSerialNoString = "";
			for (int i = 0; i < ls.toArray().length; i++)
				specificSerialNoString += "," + ls.toArray()[i].toString();
			List<BusinessObject> newSpecificList = BusinessObjectFactory.copy(
					ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
					specificSerialNoString.replaceFirst(",", ""), bomanager);
			for (BusinessObject newSpecific : newSpecificList) {
				if (productID.equals(newSpecific.getString("ProductID")))
					newSpecific.setAttributeValue("ProductID", newProductID);
				newProduct
						.appendBusinessObject(
								ProductConfig.PRODUCT_CONFIG_SPECIFICATION,
								newSpecific);
			}

			// ���Ʋ�Ʒ������Ϣ
			List<BusinessObject> productRelativeList = bomanager
					.loadBusinessObjects(
							ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE,
							"ProductID=:ProductID", "ProductID", productID);
			for (BusinessObject productRelative : productRelativeList) {
				// ������ȫ���ų��������Ը���
				if (ProductConfig.PRODUCT_CONFIG_SPECIFICATION
						.equals(productRelative.getString("ObjectType")))
					continue;
				BusinessObject newRelative = BusinessObject
						.createBusinessObject(productRelative);
				newRelative.setAttributeValue("PRODUCTID", newProductID);
				newProduct.appendBusinessObject(
						ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE,
						newRelative);
			}
			list.add(newProduct);
		}
		return list;
	}

	@Override
	public BusinessObject create(BizObjectClass bizObjectClass,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {
		BusinessObject product = BusinessObject
				.createBusinessObject(ProductConfig.PRODUCT_CONFIG_PRODUCT);
		String productID = inputParameters.getString("ProductID");
		product.setAttributeValue("PRODUCTID", productID);
		product.setAttributesValue(inputParameters.convertToMap());

		// 1.������Ʒ���
		String productType1 = product.getString("ProductType1");
		if (StringX.isEmpty(productType1))
			throw new ALSException("EC5003");
		else if (productType1.equals(ProductConfig.PRODUCT_TYPE_BASIC_PRODUCT)) {
			BusinessObject specific = this.createBasicProductSpecific(
					productID, bomanager);
			product.setAttributeValue(
					ProductConfig.PRODUCT_CONFIG_SPECIFICATION, specific);
		} else if (productType1
				.equals(ProductConfig.PRODUCT_TYPE_PROJECT_PRODUCT)) {
			List<BusinessObject> specificList = createPrjProductSpecific(
					productID,
					inputParameters.getString("RELATIVEPRODUCTLIST"), bomanager);
			product.setAttributeValue(
					ProductConfig.PRODUCT_CONFIG_SPECIFICATION, specificList);
			String[] basicProductIDArray = inputParameters.getString(
					"RELATIVEPRODUCTLIST").split(",");
			for (String basicProductID : basicProductIDArray) {
				BusinessObject productRelative = BusinessObject
						.createBusinessObject(ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE);
				productRelative.setAttributeValue("ProductID", productID);
				productRelative.setAttributeValue("OBJECTTYPE",
						ProductConfig.PRODUCT_CONFIG_PRODUCT);
				productRelative.setAttributeValue("OBJECTNO", basicProductID);
				productRelative.setAttributeValue("RELATIVETYPE", "01");
				productRelative.generateKey();
				product.appendBusinessObject(
						ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE,
						productRelative);
			}
		}

		// 2.����ProductRelative
		List<BusinessObject> newspecificList = product
				.getBusinessObjects(ProductConfig.PRODUCT_CONFIG_SPECIFICATION);
		for (BusinessObject newspecific : newspecificList) {
			BusinessObject productRelative = this.createProductRelative(
					productID, newspecific, "03");
			product.appendBusinessObject(
					ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE,
					productRelative);
		}
		return product;
	}

	public List<BusinessObject> createPrjProductSpecific(String productID,
			String basicProductIDString, BusinessObjectManager bomanager)
			throws Exception {
		List<BusinessObject> newSpecificList = new ArrayList<BusinessObject>();
		if (StringX.isEmpty(basicProductIDString))
			throw new ALSException("EC5004");

		// ����������Ʒ��Ӧ�Ĺ��
		List<BusinessObject> l = bomanager
				.loadBusinessObjects(
						ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE,
						"ProductID in (:ProductID) and ObjectType='jbo.prd.PRD_SPECIFIC_LIBRARY' and RelativeType='03'",
						"ProductID", basicProductIDString.split(","));
		if (l == null || l.isEmpty())
			throw new ALSException("EC5005", basicProductIDString);
		List<Object> ls = BusinessObjectHelper.getValues(l, "OBJECTNO");
		for (Object specificSerialNo:ls)
		{
			ProductSpecificManager psm = new ProductSpecificManager();
			psm.setBusinessObjectManager(bomanager);
			psm.setInputParameter("SpecificSerialNo", specificSerialNo);
			BusinessObject specific = psm.copySpecific(bomanager.getTx());
			
			specific.setAttributeValue("Status", "0");// �޸İ汾��Ϣ
			newSpecificList.add(specific);
		}
		return newSpecificList;
	}

	public BusinessObject createBasicProductSpecific(String productID,
			BusinessObjectManager bomanager) throws Exception {
		
		ProductSpecificManager psm = new ProductSpecificManager();
		psm.setBusinessObjectManager(bomanager);
		psm.setInputParameter("ProductID", productID);
		psm.setInputParameter("SpecificID",ProductConfig.DEFAULT_SPECIFICID);
		psm.setInputParameter("SpecificName", "ͨ�ð汾");
		BusinessObject specific = psm.newSpecific(bomanager.getTx());
		return specific;
	}

	public BusinessObject createProductRelative(String productID,
			BusinessObject relativeObject, String relativeType)
			throws Exception {
		return createProductRelative(productID,
				relativeObject.getBizClassName(),
				relativeObject.getKeyString(), relativeType);
	}

	public BusinessObject createProductRelative(String productID,
			String objectType, String objectNo, String relativeType)
			throws Exception {
		BusinessObject productRelative = BusinessObject
				.createBusinessObject(ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE);
		productRelative.setAttributeValue("ProductID", productID);
		productRelative.setAttributeValue("OBJECTTYPE", objectType);
		productRelative.setAttributeValue("OBJECTNO", objectNo);
		productRelative.setAttributeValue("RELATIVETYPE", relativeType);
		productRelative.generateKey();
		return productRelative;
	}

	@Override
	public BusinessObject getBusinessObject(Element e) throws Exception {
		String objectType = e.getAttributeValue("objectType");
		String objectNo = e.getAttributeValue("objectNo");
		String jboClassName = e.getAttributeValue("jboClassName");
		if (StringX.isEmpty(jboClassName))
			jboClassName = objectType;
		ARE.getLog().debug("�����Ʒ����{" + objectType + "}��ʼ����ʼ��");
		BusinessObject businessObject = BusinessObject
				.createBusinessObject(jboClassName);

		@SuppressWarnings("unchecked")
		List<Element> attributeList = e.getChildren("Attributes");
		for (Element attribute : attributeList) {
			List<Element> attrList = attribute.getChildren("Attribute");
			for (Element attr : attrList) {
				String attrID = attr.getAttributeValue("id");
				businessObject.setAttributeValue(attrID,
						getAttributeValue(attr));
			}

		}
		if (objectNo.indexOf(",") < 0)
			businessObject.setKey(objectNo);

		ARE.getLog().debug("�����Ʒ����{" + objectType + "}��ʼ��������");
		return businessObject;
	}

	@Override
	public int importToDB(List<BusinessObject> businessObject,
			BusinessObjectManager bomanager) throws Exception {
		ARE.getLog().debug("�����Ʒ��ʼ��");
		for (BusinessObject product : businessObject) {
			this.saveImportProduct(product, bomanager);
			bomanager.updateDB();
		}
		ARE.getLog().debug("�����Ʒ������");

		return 0;
	}

	private void saveImportProduct(BusinessObject product,
			BusinessObjectManager bomanager) throws Exception {
		String productid = product.getString("ProductID");
		ARE.getLog().debug("�����Ʒ{" + productid + "}��");

		/**
		 * 1���жϲ�Ʒ�Ƿ���� ���ڣ�������Ʒ�������ף����򣬽�����Ʒ��������
		 * */
		BusinessObject prdtransaction = BusinessObject
				.createBusinessObject("jbo.prd.PRD_TRANSACTION");
		BusinessObject productTemp = bomanager.keyLoadBusinessObject(
				"jbo.prd.PRD_PRODUCT_LIBRARY", productid);
		if (productTemp != null) {

			String status = productTemp.getString("STATUS");
			ArrayList<BusinessObject> oldpslList = new ArrayList<BusinessObject>();

			if ("1".equals(status)) {
				productTemp = BusinessObjectFactory.loadSingle(
						ProductConfig.PRODUCT_CONFIG_PRODUCT, productid,
						bomanager);
				oldpslList = (ArrayList<BusinessObject>) productTemp
						.getBusinessObjects("jbo.prd.PRD_SPECIFIC_LIBRARY");
			} else
				oldpslList = (ArrayList<BusinessObject>) bomanager
						.loadBusinessObjects("jbo.prd.PRD_SPECIFIC_LIBRARY",
								" productid=:ProductID ", "ProductID",
								productid);

			// 1����������
			prdtransaction.setAttributeValue("SerialNo", "");
			prdtransaction.generateKey();
			String prdSerialno = prdtransaction.getKeyString();
			prdtransaction.setAttributeValue("ObjectType",
					"jbo.prd.PRD_PRODUCT_LIBRARY");
			prdtransaction
					.setAttributeValue("ObjectNo", product.getKeyString());
			prdtransaction.setAttributeValue("status", "0");
			prdtransaction.setAttributeValue("Transcode", "0020");
			prdtransaction.setAttributeValue("TransName", "������Ʒ");
			prdtransaction.setAttributeValue("InputDate",
					DateHelper.getBusinessDate());
			prdtransaction.setAttributeValue("InputOrgID", "9900");
			prdtransaction.setAttributeValue("InputUserID", "System");
			bomanager.updateBusinessObject(prdtransaction);

			// ���²�����
			List<BusinessObject> spList = product
					.getBusinessObjects("jbo.prd.PRD_SPECIFIC_LIBRARY");
			for (BusinessObject sp : spList) {
				String serialno = sp.getKeyString();
				String objecttype = sp.getBizClassName();

				for (BusinessObject oldpsl : oldpslList) {
					String oldserialno = oldpsl.getKeyString();
					String oldobjecttype = oldpsl.getBizClassName();

					if (serialno.equals(oldserialno) && serialno != null
							&& serialno.length() > 0 && oldserialno != null
							&& oldserialno.length() > 0) {// ����Ĳ�����ԭ����һ��ʱ�������޸Ĳ�Ʒ�汾
						BusinessObject prdTransactionRelative = BusinessObject
								.createBusinessObject("jbo.prd.PRD_TRANSACTION_RELATIVE");
						prdTransactionRelative
								.setAttributeValue("SerialNo", "");
						prdTransactionRelative.generateKey();
						prdTransactionRelative.setAttributeValue(
								"TransactionSerialNo", prdSerialno);
						prdTransactionRelative.setAttributeValue("ObjectType",
								oldobjecttype);
						prdTransactionRelative.setAttributeValue("ObjectNo",
								oldserialno);
						prdTransactionRelative.setAttributeValue(
								"RelativeType", "M");
						bomanager.updateBusinessObject(prdTransactionRelative);
					} else if (oldserialno != null && oldserialno.length() > 0) {// ����Ĳ�����ԭ������һ��ʱ������ɾ����Ʒ�汾
						BusinessObject prdTransactionRelative = BusinessObject
								.createBusinessObject("jbo.prd.PRD_TRANSACTION_RELATIVE");
						prdTransactionRelative
								.setAttributeValue("SerialNo", "");
						prdTransactionRelative.generateKey();
						prdTransactionRelative.setAttributeValue(
								"TransactionSerialNo", prdSerialno);
						prdTransactionRelative.setAttributeValue("ObjectType",
								oldobjecttype);
						prdTransactionRelative.setAttributeValue("ObjectNo",
								oldserialno);
						prdTransactionRelative.setAttributeValue(
								"RelativeType", "D");
						bomanager.updateBusinessObject(prdTransactionRelative);
					} else if (serialno != null && serialno.length() > 0) {

						BusinessObject prdTransactionRelative = BusinessObject
								.createBusinessObject("jbo.prd.PRD_TRANSACTION_RELATIVE");
						prdTransactionRelative
								.setAttributeValue("SerialNo", "");
						prdTransactionRelative.generateKey();
						prdTransactionRelative.setAttributeValue(
								"TransactionSerialNo", prdSerialno);
						prdTransactionRelative.setAttributeValue("ObjectType",
								objecttype);
						prdTransactionRelative.setAttributeValue("ObjectNo",
								serialno);
						prdTransactionRelative.setAttributeValue(
								"RelativeType", "C");
						bomanager.updateBusinessObject(prdTransactionRelative);

						bomanager.updateBusinessObject(sp);

					}
				}

			}

		} else {
			// 1����������
			prdtransaction.setAttributeValue("SerialNo", "");
			prdtransaction.generateKey();
			String prdSerialno = prdtransaction.getKeyString();
			prdtransaction.setAttributeValue("ObjectType",
					"jbo.prd.PRD_PRODUCT_LIBRARY");
			prdtransaction
					.setAttributeValue("ObjectNo", product.getKeyString());
			prdtransaction.setAttributeValue("status", "0");
			prdtransaction.setAttributeValue("Transcode", "0010");
			prdtransaction.setAttributeValue("TransName", "������Ʒ");
			prdtransaction.setAttributeValue("InputDate",
					DateHelper.getBusinessDate());
			prdtransaction.setAttributeValue("InputOrgID", "9900");
			prdtransaction.setAttributeValue("InputUserID", "System");
			bomanager.updateBusinessObject(prdtransaction);

			BusinessObject prdTransactionRelative1 = BusinessObject
					.createBusinessObject("jbo.prd.PRD_TRANSACTION_RELATIVE");
			prdTransactionRelative1.setAttributeValue("SerialNo", "");
			prdTransactionRelative1.generateKey();
			prdTransactionRelative1.setAttributeValue("TransactionSerialNo",
					prdSerialno);
			prdTransactionRelative1.setAttributeValue("ObjectType",
					product.getBizClassName());
			prdTransactionRelative1.setAttributeValue("ObjectNo",
					product.getKeyString());
			prdTransactionRelative1.setAttributeValue("RelativeType", "C");
			bomanager.updateBusinessObject(prdTransactionRelative1);

			// 2���������׹�����Ϣ
			// ���²�����
			List<BusinessObject> spList = product
					.getBusinessObjects("jbo.prd.PRD_SPECIFIC_LIBRARY");
			for (BusinessObject sp : spList) {
				String serialno = sp.getKeyString();
				String objecttype = sp.getBizClassName();

				BusinessObject prdTransactionRelative = BusinessObject
						.createBusinessObject("jbo.prd.PRD_TRANSACTION_RELATIVE");
				prdTransactionRelative.setAttributeValue("SerialNo", "");
				prdTransactionRelative.generateKey();
				prdTransactionRelative.setAttributeValue("TransactionSerialNo",
						prdSerialno);
				prdTransactionRelative.setAttributeValue("ObjectType",
						objecttype);
				prdTransactionRelative.setAttributeValue("ObjectNo", serialno);
				prdTransactionRelative.setAttributeValue("RelativeType", "C");
				bomanager.updateBusinessObject(prdTransactionRelative);

			}

			// ���¹�����Ʒ
			List<BusinessObject> relativeProductList = product
					.getBusinessObjects("jbo.prd.PRD_PRODUCT_RELATIVE");
			for (BusinessObject relativeProduct : relativeProductList) {
				String serialno = relativeProduct.getString("ObjectNo");
				String objecttype = relativeProduct.getString("ObjectType");
				if ("jbo.prd.PRD_SPECIFIC_LIBRARY".equals(objecttype))
					continue;

				BusinessObject prdTransactionRelative = BusinessObject
						.createBusinessObject("jbo.prd.PRD_TRANSACTION_RELATIVE");
				prdTransactionRelative.setAttributeValue("SerialNo", "");
				prdTransactionRelative.generateKey();
				prdTransactionRelative.setAttributeValue("TransactionSerialNo",
						prdSerialno);
				prdTransactionRelative.setAttributeValue("ObjectType",
						objecttype);
				prdTransactionRelative.setAttributeValue("ObjectNo", serialno);
				prdTransactionRelative.setAttributeValue("RelativeType", "C");
				bomanager.updateBusinessObject(prdTransactionRelative);

			}

			// ����������Ʒ
			product.setAttributeValue("Status", "0");
			bomanager.updateBusinessObject(product);
			BusinessObjectFactory.save(product, bomanager);
		}

	}

	private Object getAttributeValue(Element element) throws Exception {
		if ("array".equals(element.getAttributeValue("type"))) {
			@SuppressWarnings("unchecked")
			List<Element> arrayList = element.getChildren("BusinessObject");
			List<BusinessObject> list = new ArrayList<BusinessObject>();
			for (Element e : arrayList) {
				BusinessObject o = BusinessObjectFactory
						.importXMLBusinessObject(e);
				list.add(o);
			}
			return list;
		} else {
			int dataType = Integer.parseInt(element.getAttributeValue("type"));
			String datavalue = element.getAttributeValue("value");
			if (dataType == DataElement.LONG)
				return datavalue == null || datavalue.length() == 0 ? "" : Long
						.parseLong(datavalue);
			else if (dataType == DataElement.INT)
				return datavalue == null || datavalue.length() == 0 ? ""
						: Integer.parseInt(datavalue);
			else if (dataType == DataElement.DOUBLE)
				return datavalue == null || datavalue.length() == 0 ? ""
						: Double.parseDouble(datavalue);
			else if (dataType == DataElement.BOOLEAN)
				return datavalue == null || datavalue.length() == 0 ? ""
						: Boolean.parseBoolean(datavalue);
			else
				return datavalue;
		}
	}
}
