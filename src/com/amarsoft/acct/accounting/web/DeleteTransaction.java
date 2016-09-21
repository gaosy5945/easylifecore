package com.amarsoft.acct.accounting.web;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.trans.TransactionHelper;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

public class DeleteTransaction {
	private String serialno;

	public String getSerialno() {
		return this.serialno;
	}

	public void setSerialno(String serialno) {
		this.serialno = serialno;
	}
	
	public String deleteTransaction(JBOTransaction tx) throws Exception{
		if(StringX.isEmpty(this.serialno)) return "false@ɾ��ʧ��";
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		//ɾ����ǰ�Ľ���
		TransactionHelper.deleteTransaction(this.serialno, bomanager);
		bomanager.updateDB();
		bomanager.commit();
		return "true@ɾ���ɹ�";
	}
}
