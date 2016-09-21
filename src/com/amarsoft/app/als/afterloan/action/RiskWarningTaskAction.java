package com.amarsoft.app.als.afterloan.action;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;


public class RiskWarningTaskAction {
	//����
	private String serialNo;//��ˮ
	private String returnValue = "Success";
	
	//��ɫԤ�����������ύ����
	public String TaskDtSubmit(JBOTransaction tx) throws Exception{
		BizObjectManager bm;
		try {
			bm = JBOFactory.getBizObjectManager("jbo.al.RISK_WARNING_SIGNAL");
			BizObject bo = bm.createQuery("serialno = :serialno")
						.setParameter("serialno", this.serialNo).getSingleResult(true);
			bo.setAttributeValue("STATUS", "1");
			bo.setAttributeValue("UPDATEDATE", DateHelper.getBusinessDate());
			bm.saveObject(bo);
		} catch (JBOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "�ύ����JBOִ��ʧ��";
		}
		return this.returnValue;
	}
	
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
}
