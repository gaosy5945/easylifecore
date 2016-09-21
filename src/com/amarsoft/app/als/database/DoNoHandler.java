package com.amarsoft.app.als.database;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

public class DoNoHandler {

	/**
	 * @dlsong
	 * �������ݱ����ҳ����Ӧ����ʾģ������
	 */
	public String TBNo;
	public String getTBNo() {
		return TBNo;
	}
	public void setTBNo(String tBNo) {
		TBNo = tBNo;
	}
	public String getRelaDono() throws JBOException{
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.DATAOBJECT_CATALOG");
		BizObject bo=bm.createQuery("upper(DoUpdateTable)=:UpdateTable").setParameter("UpdateTable", TBNo).getSingleResult(false);
		return bo.getAttribute("DONO").getString();
	}

}
