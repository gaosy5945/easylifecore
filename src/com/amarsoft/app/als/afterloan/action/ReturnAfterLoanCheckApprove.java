package com.amarsoft.app.als.afterloan.action;

import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 退回流程审批时 改变状态为退回重检
 * @author 梁建强
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
		return "退回重检";
	}
}
