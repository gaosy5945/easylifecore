package com.amarsoft.app.lending.bizlets;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * У��ͻ��Ƿ��пͻ�����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ
 * 
 * @author syang 2009/10/27
 * 
 */
public class CheckRolesAction {

	private String customerID;
	private String userID;

	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	/**
	 * @param ����˵��
	 * <br/>
	 *            CustomerID :�ͻ�ID<br/>
	 *            UserID :�û�ID
	 * @return ����ֵ˵��
	 *         <p>
	 *         ����Ȩ@��Ϣ�鿴Ȩ@��Ϣά��Ȩ@ҵ�����Ȩ
	 *         </p>
	 *         <li>����Ȩֵ�򡡡���Y/N</li> <li>��Ϣ�鿴Ȩֵ��Y1/N1</li> <li>��Ϣά��Ȩֵ��Y2/N2</li>
	 *         <li>ҵ�����Ȩֵ��Y3/N3</li>
	 * 
	 */
	public String checkRolesAction(JBOTransaction tx) throws Exception {

		if (customerID == null) customerID = "";
		if (userID == null) userID = "";

		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_BELONG");
		tx.join(bom);
		String sReturn = ""; // ���ؽ��
		String sBelongAttribute = ""; // �ͻ�����Ȩ
		String sBelongAttribute1 = ""; // ��Ϣ�鿴Ȩ
		String sBelongAttribute2 = ""; // ��Ϣά��Ȩ
		String sBelongAttribute3 = ""; // ҵ�����Ȩ
		String sReturnValue = ""; // ����Ȩ��־
		String sReturnValue1 = ""; // ��Ϣ�鿴Ȩ��־
		String sReturnValue2 = ""; // ��Ϣά��Ȩ��־
		String sReturnValue3 = ""; // ҵ�����Ȩ��־

		String sSql = " select BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3 from O where CustomerID =:CustomerID and UserID =:UserID";
		BizObjectQuery boq = bom.createQuery(sSql).setParameter("CustomerID",customerID)
				.setParameter("UserID", userID);
		@SuppressWarnings("unchecked")
		List<BizObject> bos = boq.getResultList(false);
		if (bos != null && bos.size() > 0) {
			BizObject bo = bos.get(0);
			sBelongAttribute = bo.getAttribute("BelongAttribute").getString();
			sBelongAttribute1 = bo.getAttribute("BelongAttribute1").getString();
			sBelongAttribute2 = bo.getAttribute("BelongAttribute2").getString();
			sBelongAttribute3 = bo.getAttribute("BelongAttribute3").getString();
		}
		
		if (sBelongAttribute == null) sBelongAttribute = "";
		if (sBelongAttribute1 == null) sBelongAttribute1 = "";
		if (sBelongAttribute2 == null)	sBelongAttribute2 = "";
		if (sBelongAttribute3 == null)	sBelongAttribute3 = "";

		if (sBelongAttribute.equals("1")) {// ����пͻ�����Ȩ����Y�����򷵻�N
			sReturnValue = "Y";
		} else {
			sReturnValue = "N";
		}

		if (sBelongAttribute1.equals("1")) {// �������Ϣ�鿴Ȩ����Y1�����򷵻�N1
			sReturnValue1 = "Y1";
		} else {
			sReturnValue1 = "N1";
		}

		if (sBelongAttribute2.equals("1")) {// �������Ϣά��Ȩ����Y2�����򷵻�N2
			sReturnValue2 = "Y2";
		} else {
			sReturnValue2 = "N2";
		}

		if (sBelongAttribute3.equals("1")) {// �����ҵ�����Ȩ����Y3�����򷵻�N3
			sReturnValue3 = "Y3";
		} else {
			sReturnValue3 = "N3";
		}

		sReturn = sReturnValue + "@" + sReturnValue1 + "@" + sReturnValue2
				+ "@" + sReturnValue3;
		return sReturn;

	}
}
