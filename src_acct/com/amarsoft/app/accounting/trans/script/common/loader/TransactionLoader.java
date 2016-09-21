package com.amarsoft.app.accounting.trans.script.common.loader;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

/**
 * ���׼��أ����ؽ�����صĵ�����Ϣ�͹���������Ϣ���绹��׵Ļ���ݺͶ�Ӧ�Ľ����Ϣ
 * 
 * @author �����Ʒ��
 * @author xyqu 2014��6��16�� ������롢����ע��
 * 
 */
public final class TransactionLoader  extends TransactionProcedure {

	@Override
	public int run() throws Exception {
		// ���ز�����������Ϣ
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

		// ���ز�������������
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
