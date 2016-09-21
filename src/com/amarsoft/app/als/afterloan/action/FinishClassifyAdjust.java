package com.amarsoft.app.als.afterloan.action;

import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * �����������ʱ �ı�״̬Ϊ���
 * @author ������
 *
 */
public class FinishClassifyAdjust{
	
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

	public String finishInspectRecord(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.al.CLASSIFY_RECORD");
		tx.join(bm);
		        bm.createQuery("UPDATE O SET CLASSIFYSTATUS = '0020' WHERE SERIALNO = :SERIALNO")
				.setParameter("SERIALNO", serialNo).executeUpdate();
		return "������";
	}
}
