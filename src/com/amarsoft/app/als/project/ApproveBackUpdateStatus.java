package com.amarsoft.app.als.project;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class ApproveBackUpdateStatus {
	private String status;
	private String serialNo;
	
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public void lastFinishApprove(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		tx.join(bm);
		
		bm.createQuery("UPDATE O SET STATUS = :STATUS,UPDATEDATE=:UPDATEDATE WHERE SERIALNO = :SERIALNO")
		.setParameter("STATUS", "15").setParameter("UPDATEDATE", DateHelper.getBusinessDate())
		.setParameter("SERIALNO", serialNo).executeUpdate();

	}

}
