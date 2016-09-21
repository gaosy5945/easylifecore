package com.amarsoft.app.als.customer.common.action;

/**
 * @Author:柳显涛
 * 企业客户详情页面更新的customer_info中的英文名、客户等级值、客户等级和客户状态
*/

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class EntCustomerBasicInfoHandler extends CommonHandler{
	/**
	 * @柳显涛
	 * 企业客户详情页面更新的customer_info中的英文名、客户等级值、客户等级和客户状态
	 */
	protected  void afterUpdate(JBOTransaction tx, BizObject bo) throws Exception{
		
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		tx.join(bm);
		String customerID = bo.getAttribute("customerID").getString();
		String englishName = bo.getAttribute("EnglishName").getString();
		String cstLevel = bo.getAttribute("cstLevel").getString();
		String status = bo.getAttribute("status").getString();
		String orgType = bo.getAttribute("orgType").getString();
		String customerType = bo.getAttribute("CustomerType").getString();
		bm.createQuery("update O set ENGLISHNAME=:englishName,CSTLEVEL=:cstLevel,STATUS=:status,CUSTOMERTYPE=:customerType Where customerID=:customerID")
		  .setParameter("englishName", englishName)
		  .setParameter("cstLevel", cstLevel)
		  .setParameter("status", status)
		  .setParameter("orgType", orgType)
		  .setParameter("customerType", customerType)
		  .setParameter("customerID", customerID)
		  .executeUpdate();
		
		BizObjectManager bm1 = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_IDENTITY");
		tx.join(bm1);
		
		String certType = bo.getAttribute("CERTTYPE").getString();
		String certID = bo.getAttribute("CERTID").getString();
		String cnidegCity = bo.getAttribute("CNIDREGCITY").getString();
		String idexpriry = bo.getAttribute("IDEXPIRY").getString();
		
		bm1.createQuery("update O set CERTTYPE=:CERTTYPE,CERTID=:CERTID,CNIDREGCITY=:CNIDREGCITY,IDEXPIRY=:IDEXPIRY Where customerID=:customerID")
		  .setParameter("CERTTYPE", certType).setParameter("CERTID", certID).setParameter("CNIDREGCITY", cnidegCity)
		  .setParameter("IDEXPIRY", idexpriry).setParameter("customerID", customerID)
		  .executeUpdate();
		
	}

}
