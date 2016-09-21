package com.amarsoft.app.accounting.trans.script.common.loader;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

/**
 * 交易加载，加载交易相关的单据信息和关联对象信息。如还款交易的还款单据和对应的借据信息
 * 
 * @author 核算产品组
 * @author xyqu 2014年6月16日 整理代码、增加注释
 * 
 */
public final class TransactionLoader  extends TransactionProcedure {

	@Override
	public int run() throws Exception {
		// 加载并关联单据信息
		String documentType = transaction.getString("DocumentType");
		String documentNo = transaction.getString("DocumentNo");
		if (!StringX.isEmpty(documentType) && !StringX.isEmpty(documentNo)) {
			BusinessObject transactionDocument = transaction.getBusinessObjectByKey(documentType, documentNo);
			if (transactionDocument == null) {
				transactionDocument = bomanager.keyLoadBusinessObject(documentType, documentNo);
				if (transactionDocument == null) {
					throw new ALSException("ED1010", documentType, documentNo);
				}
				transaction.setAttributeValue(documentType,transactionDocument);
			}
		}

		// 加载并关联关联对象
		String relativeObjectType = transaction.getString("RelativeObjectType");
		String relativeObjectNo = transaction.getString("RelativeObjectNo");
		if (!StringX.isEmpty(relativeObjectType) &&!StringX.isEmpty(relativeObjectNo)) {
			BusinessObject relativeObject = transaction.getBusinessObjectByKey(relativeObjectType, relativeObjectNo);
			if (relativeObject == null) {
				relativeObject = bomanager.keyLoadBusinessObject(relativeObjectType, relativeObjectNo);
				if (relativeObject == null) {
					throw new ALSException("ED1010", relativeObjectType, relativeObjectNo);
				}
				transaction.setAttributeValue(relativeObjectType,relativeObject);
			}
		}

		return 1;
	}
}
