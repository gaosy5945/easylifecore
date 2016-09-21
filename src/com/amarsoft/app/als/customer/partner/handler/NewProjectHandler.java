package com.amarsoft.app.als.customer.partner.handler;

import com.amarsoft.app.als.customer.partner.model.CustomerPartner;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
/**
 * 项目申请处理类
 * @author Administrator
 *
 */
public class NewProjectHandler extends CommonHandler {
	private CustomerPartner customerPartner;
	/**
	 * 初始化
	 */
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		super.initDisplayForAdd(bo);
		//取参数
		String customerID = asPage.getParameter("customerID");
		String partnertype = asPage.getParameter("partnerType");
		
		this.customerPartner = new CustomerPartner(customerID, null);
		
		bo.setAttributeValue("PartnerType", partnertype);
		bo.setAttributeValue("CustomerID", customerID);
		bo.setAttributeValue("CustomerName", customerPartner.getCustomerName());
		bo.setAttributeValue("Status", "3");//待启用状态
		
	}
	protected void afterInsert(JBOTransaction tx, BizObject bo)throws Exception {
		//初始化流程
		/*
		FlowManageAction fmAction =  new FlowManageAction();
		fmAction.setObjectNo(bo.getAttribute("SerialNo").getString());
		fmAction.setObjectType("PartnerProjectAppl");
		fmAction.setApplyType(asPage.getParameter("ApplyType"));
		fmAction.setFlowNo("PartnerProjectFlow");
		fmAction.setUserID(curUser.getUserID());
		fmAction.initFlowData(tx);*/
		//初始化关联关系
		this.customerPartner = new CustomerPartner(bo.getAttribute("CustomerID").getString(), tx);
		customerPartner.initRelative(tx, bo);
		
	}

}
