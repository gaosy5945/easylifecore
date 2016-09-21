package com.amarsoft.app.als.prd.web;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.app.base.util.SystemHelper;
import com.amarsoft.are.lang.StringX;

public class TransactionBusinessProcess extends ALSBusinessProcess implements
		BusinessObjectOWUpdater {

	@Override
	public List<BusinessObject> update(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {
		BusinessObject product = businessObject.getBusinessObject(ProductConfig.PRODUCT_CONFIG_PRODUCT);
		if(product != null) businessObject.setAttributeValue("ObjectNo", product.getString("ProductID"));
		BusinessObject inputParameters = ObjectWindowHelper
				.getDataObjectParameters(asDataObject);
		inputParameters.setAttributeValue("BusinessParameters", businessObject);
		BusinessObject systemParameters = SystemHelper.getSystemParameters(
				curUser, curUser.getBelongOrg());
		inputParameters.setAttributeValue("SystemParameters", systemParameters);

		String transactionGroup = inputParameters.getString("TransactionGroup");
		String transactionSerialNo = inputParameters
				.getString("TransactionSerialNo");

		BusinessObject transaction = null;
		if (StringX.isEmpty(transactionSerialNo)) {// 新建交易
			transaction = BusinessObjectFactory.createBusinessObject(
					transactionGroup, inputParameters, true, bomanager);
			transactionSerialNo = transaction.getKeyString();
		} else
			transaction = BusinessObjectFactory.loadSingle(transactionGroup,
					transactionSerialNo, bomanager);
		BusinessObjectFactory.save(transaction, inputParameters, bomanager);
		bomanager.updateDB();
		// 设置输出参数，可以返回到前端页面
		this.setOutputParameter("TransactionGroup", transactionGroup);
		// this.setOutputParameter("TransactionCode", transactionCode);
		this.setOutputParameter("TransactionSerialNo", transactionSerialNo);

		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(refreshOWBusinessObject(businessObject));
		return result;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		for (BusinessObject businessObject : businessObjectList)
			this.update(businessObject, businessProcess);
		return businessObjectList;
	}

	private BusinessObject refreshOWBusinessObject(BusinessObject businessObject) {
		return businessObject;
	}
}
