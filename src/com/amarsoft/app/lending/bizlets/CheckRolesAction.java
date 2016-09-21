package com.amarsoft.app.lending.bizlets;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 校验客户是否有客户主办权，信息查看权，信息维护权，业务申办权
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
	 * @param 参数说明
	 * <br/>
	 *            CustomerID :客户ID<br/>
	 *            UserID :用户ID
	 * @return 返回值说明
	 *         <p>
	 *         主办权@信息查看权@信息维护权@业务申办权
	 *         </p>
	 *         <li>主办权值域　　：Y/N</li> <li>信息查看权值域：Y1/N1</li> <li>信息维护权值域：Y2/N2</li>
	 *         <li>业务申办权值域：Y3/N3</li>
	 * 
	 */
	public String checkRolesAction(JBOTransaction tx) throws Exception {

		if (customerID == null) customerID = "";
		if (userID == null) userID = "";

		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_BELONG");
		tx.join(bom);
		String sReturn = ""; // 返回结果
		String sBelongAttribute = ""; // 客户主办权
		String sBelongAttribute1 = ""; // 信息查看权
		String sBelongAttribute2 = ""; // 信息维护权
		String sBelongAttribute3 = ""; // 业务申办权
		String sReturnValue = ""; // 主办权标志
		String sReturnValue1 = ""; // 信息查看权标志
		String sReturnValue2 = ""; // 信息维护权标志
		String sReturnValue3 = ""; // 业务申办权标志

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

		if (sBelongAttribute.equals("1")) {// 如果有客户主办权返回Y，否则返回N
			sReturnValue = "Y";
		} else {
			sReturnValue = "N";
		}

		if (sBelongAttribute1.equals("1")) {// 如果有信息查看权返回Y1，否则返回N1
			sReturnValue1 = "Y1";
		} else {
			sReturnValue1 = "N1";
		}

		if (sBelongAttribute2.equals("1")) {// 如果有信息维护权返回Y2，否则返回N2
			sReturnValue2 = "Y2";
		} else {
			sReturnValue2 = "N2";
		}

		if (sBelongAttribute3.equals("1")) {// 如果有业务申办权返回Y3，否则返回N3
			sReturnValue3 = "Y3";
		} else {
			sReturnValue3 = "N3";
		}

		sReturn = sReturnValue + "@" + sReturnValue1 + "@" + sReturnValue2
				+ "@" + sReturnValue3;
		return sReturn;

	}
}
