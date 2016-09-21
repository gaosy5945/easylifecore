package com.amarsoft.app.als.customer.union.handler;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.DBKeyHelp;
/**
 * �ͻ�Ⱥ����ģ���߼�������
 * @author wmZhu
 * @date 2014/04/11
 */
public class UnionCustomerAddHandler extends CommonHandler{

	@SuppressWarnings("deprecation")
	@Override
	protected void afterInsert(JBOTransaction tx, BizObject bo)
			throws Exception {
		//¼��ܻ���Ϣ
		BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_BELONG);
		tx.join(bom);
		BizObject biz = bom.newObject();
		biz.setAttributeValue("CUSTOMERID", bo.getAttribute("CustomerID"));
		biz.setAttributeValue("ORGID", curUser.getOrgID());
		biz.setAttributeValue("USERID", curUser.getUserID());
		biz.setAttributeValue("BELONGATTRIBUTE", "1");
		biz.setAttributeValue("BELONGATTRIBUTE1", "1");
		biz.setAttributeValue("BELONGATTRIBUTE2", "1");
		biz.setAttributeValue("BELONGATTRIBUTE3", "1");
		biz.setAttributeValue("BELONGATTRIBUTE4", "1");
		biz.setAttributeValue("INPUTUSERID", curUser.getUserID());
		biz.setAttributeValue("INPUTORGID", curUser.getOrgID());
		biz.setAttributeValue("INPUTDATE", StringFunction.getToday());
		biz.setAttributeValue("UPDATEDATE", StringFunction.getToday());
		bom.saveObject(biz);
		
		//��ʼ��Group_Info����Ϣ
		BizObjectManager bomGI = JBOFactory.getBizObjectManager(CustomerConst.GROUP_INFO);
		tx.join(bomGI);
		BizObject bizGI = bomGI.newObject();
		bizGI.setAttributeValue("GroupID", bo.getAttribute("CustomerID"));
		bizGI.setAttributeValue("GroupName", bo.getAttribute("CustomerName"));
		bizGI.setAttributeValue("GroupType", "04");
		bizGI.setAttributeValue("GroupType1", bo.getAttribute("UnionType"));
		bizGI.setAttributeValue("Status", "30");//Ĭ��δ����״̬
		bizGI.setAttributeValue("InputUserID", curUser.getUserID());
		bizGI.setAttributeValue("InputOrgID", curUser.getOrgID());
		bizGI.setAttributeValue("InputDate", StringFunction.getToday());
		bizGI.setAttributeValue("ATT01", bo.getAttribute("MemberCount"));
		bomGI.saveObject(bizGI);
	}

	@Override
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		String customerID= DBKeyHelp.getSerialNo("CUSTOMER_INFO", "CUSTOMERID", "GI");
		//��ʼ�������Ϣ
		bo.setAttributeValue("CustomerID", customerID);
		bo.setAttributeValue("Status", "30");
	}

}
