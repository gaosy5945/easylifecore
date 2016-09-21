package com.amarsoft.app.als.customer.alike.action;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;


/**
 * ���ڿͻ�������
 * @author lyin
 * @date 2014/04/16
 */
public class AlikeCustomerAction {
	private String certID;
	
	/**
	 * ���swift���
	 * @return
	 * @throws JBOException
	 */
	public String checkSwiftNo() throws JBOException{
		String sReturn = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager(CustomerConst.SWIFT_INFO);
		BizObject bo = bm.createQuery("Swift_No = :swiftNo ").setParameter("swiftNo",certID).getSingleResult(false);
		if(bo != null) {
			sReturn = "true";
		}
		return sReturn;
	}

	public String getCertID() {
		return certID;
	}

	public void setCertID(String certID) {
		this.certID = certID;
	}
}
