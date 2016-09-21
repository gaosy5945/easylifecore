package com.amarsoft.app.als.project;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class CheckProjectHandler extends CommonHandler{
	protected  void afterUpdate(JBOTransaction tx, BizObject bo) throws Exception{
		
		String flowSerialNo = this.asPage.getParameter("FlowSerialNo");
		String applyType = this.asPage.getParameter("ApplyType");
		String projectType = this.asPage.getParameter("ProjectType");
		if(!"0110".equals(projectType)){//����Ŀ���Ͳ�Ϊ�����ڷ��������ڷ��������̣�ʱ����������
			 List<BusinessObject> boList = new ArrayList<BusinessObject>();
		        BusinessObject boo = BusinessObject.convertFromBizObject(bo);
		        
				//��ȡ���̶������
				String flowNo = "S0215.plbs_cooperation.Flow_015";
				String flowVersion = "1.0.0";
				List<BusinessObject> paraList = FlowConfig.getFlowCatalogPara(flowNo, flowVersion);
				BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_LIST");
				tx.join(bm);
				BizObjectQuery boq = bm.createQuery("CustomerID=:CustomerID");
				boq.setParameter("CustomerID", bo.getAttribute("CustomerID").getString());
				BizObject cl = boq.getSingleResult(false);
				boo.setAttributesValue(BusinessObject.convertFromBizObject(cl));
				boList.add(boo);
				
				BusinessObject para = BusinessObject.createBusinessObject();
				para.setAttributeValue("OrgID", this.curUser.getOrgID());
				para.setAttributeValue("UserID", this.curUser.getUserID());
				para.setAttributeValue("ApplyType", applyType);
				
				//��ȡ������
				BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
				BusinessObject context = FlowHelper.getContext(paraList,boList,para,bomanager);
				FlowManager fm = FlowManager.getFlowManager(bomanager);
				fm.setInstanceContext(flowSerialNo, context, curUser.getUserID(), curUser.getOrgID());
		}
	}

}
