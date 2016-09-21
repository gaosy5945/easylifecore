/**
 * 
 */
package com.amarsoft.app.als.reserve.handler;

import java.util.Date;

import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.app.als.customer.model.CustomerInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * �����������ֵ������������	
 * @author xyli
 * @2014-5-12
 */
public class ReserveApplyCreationInfoHandler extends CommonHandler {

	@Override
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		bo.setAttributeValue("MANAGERUSERID", curUser.getUserID());
		bo.setAttributeValue("MANAGERUSERNAME", curUser.getUserName());
		bo.setAttributeValue("MANAGERORGID", curUser.getOrgID());
		bo.setAttributeValue("MANAGERORGNAME", curUser.getOrgName());
		bo.setAttributeValue("INPUTDATE", DateX.format(new Date()));
		
	}

	@Override
	protected void initDisplayForEdit(BizObject bo) throws Exception {
		bo.setAttributeValue("MANAGERUSERNAME", curUser.getUserName());
		bo.setAttributeValue("MANAGERORGNAME", curUser.getOrgName());
	}
	
	
	@Override
	protected void beforeInsert(JBOTransaction tx, BizObject bo)throws Exception {
		//�ͻ���Ϣ
		String customerID = bo.getAttribute("CustomerId").getString();//�ͻ����
		CustomerInfo ci = new CustomerInfo(tx, customerID);
		
		String customerType = ci.getBizObject().getAttribute("CustomerType").getString();
		String certType = ci.getBizObject().getAttribute("CertType").getString();
		String certId = ci.getBizObject().getAttribute("CertId").getString();
		
		bo.setAttributeValue("CustomerType", customerType);
		bo.setAttributeValue("CertType", certType);
		bo.setAttributeValue("CertId", certId);
		
		//�����Ϣ
		BizObjectManager bmBD = JBOFactory.getBizObjectManager(CreditConst.BD_JBOCLASS);
		BizObject boBD = bmBD.createQuery("SerialNo=:serialNo").setParameter("serialNo", bo.getAttribute("DUEBILLNO").getString()).getSingleResult(false);
		if(null != boBD){
			bo.setAttributeValue("BUSINESSTYPE", boBD.getAttribute("BUSINESSTYPE").getString());
			bo.setAttributeValue("CURRENCY", boBD.getAttribute("BUSINESSCURRENCY").getString());
			bo.setAttributeValue("PUTOUTSUM", boBD.getAttribute("BUSINESSSUM").getDouble());
			bo.setAttributeValue("BALANCE", boBD.getAttribute("BALANCE").getDouble());
			bo.setAttributeValue("FIVECLASSIFY", boBD.getAttribute("CLASSIFYRESULT").getString());
			bo.setAttributeValue("CONTRACTRATE", boBD.getAttribute("EXECUTEYEARRATE").getString());
		}
		
		
	}

	@Override
	protected void afterInsert(JBOTransaction tx, BizObject bo)throws Exception {
		//��ʼ������
		/*InitializeFlow flow = new InitializeFlow();
		flow.setObjectType(asPage.getParameter("ObjectType"));
		flow.setObjectNo(bo.getAttribute("SERIALNO").getString());
		flow.setApplyType(asPage.getParameter("ApplyType"));
		flow.setFlowNo(asPage.getParameter("FlowNo"));
		flow.setUserID(curUser.getUserID());
		flow.initializeFlow(tx);*/
		
	}
	
}
