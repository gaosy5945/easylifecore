package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.SqlObject;

public class FreezeCreditLine {
	private String  serialNo = null;
	private String 	freezeFlag =null;
	public Object freezeCreditLine(JBOTransaction tx) throws Exception {
		// �Զ���ô���Ĳ���ֵ
		SqlObject so = null;
		// �����ͬ��
		String sBCSerialNo = this.serialNo;
		// ���붳���־
		String sFreezeFlag = this.freezeFlag;

		if (sBCSerialNo == null)
			sBCSerialNo = "";
		if (sFreezeFlag == null)
			sFreezeFlag = "";

		// ����CL_INFO�����Ӧ�Ķ����Ϣ
		JBOFactory.getBizObjectManager("jbo.cl.CL_INFO", tx)
		.createQuery("update O set FreezeFlag =:FreezeFlag where BCSerialNo =:BCSerialNo ")
		.setParameter("FreezeFlag", sFreezeFlag).setParameter("BCSerialNo", sBCSerialNo).executeUpdate();
 
		// ����BUSINESS_CONTRACT�����Ӧ�Ķ����Ϣ
		
		JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT", tx)
		.createQuery("update O set FreezeFlag =:FreezeFlag where SerialNo =:SerialNo ")
		.setParameter("FreezeFlag", sFreezeFlag).setParameter("SerialNo", sBCSerialNo).executeUpdate();
		 
		return "1";

	}
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	public String getFreezeFlag() {
		return freezeFlag;
	}
	public void setFreezeFlag(String freezeFlag) {
		this.freezeFlag = freezeFlag;
	}

}
