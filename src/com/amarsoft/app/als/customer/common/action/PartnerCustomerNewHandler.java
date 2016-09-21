package com.amarsoft.app.als.customer.common.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.DBKeyHelp;

public class PartnerCustomerNewHandler extends CommonHandler{
	/**
	 * @柳显涛
	 * 新增合作方客户时，向客户customer_info表中插入数据
	 */
	public void afterInsert(JBOTransaction tx, BizObject bo) throws Exception{
				//新增关联记录
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		tx.join(bm);
		
		String sCustomerID = bo.getAttribute("CustomerID").toString();
		String sCustomerName = bo.getAttribute("CustomerName").toString();
		String sInputOrgID = bo.getAttribute("InputOrgID").toString();
		String sInputUserID = bo.getAttribute("InputUserID").toString();
		String sInputDate = bo.getAttribute("InputDate").toString();

		BizObject bo1=bm.newObject();
		/*String sSerialNo1= DBKeyHelp.getSerialNo("ALS_TABLE_RELATIVE","SerialNo");*/
		bo1.setAttributeValue("CustomerID", sCustomerID);
		bo1.setAttributeValue("CustomerName", sCustomerName);
		bo1.setAttributeValue("InputOrgID", sInputOrgID);
		bo1.setAttributeValue("InputUserID", sInputUserID);
		bo1.setAttributeValue("InputDate", sInputDate);

		bm.saveObject(bo1);	
		}
}