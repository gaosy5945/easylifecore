package com.amarsoft.app.als.afterloan.action;

import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * �˻���������ʱ �ı�״̬Ϊ�˻��ؼ�
 * @author ����ǿ
 *
 */
public class ReturnAfterLoanCheckApprove{
	
	private String serialNo;
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String returnInspectRecord(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.al.INSPECT_RECORD");
		tx.join(bm);
				bm.createQuery("UPDATE O SET STATUS = '6' WHERE SERIALNO = :SERIALNO")
				.setParameter("SERIALNO", serialNo).executeUpdate();
		return "�˻��ؼ�";
	}
}
