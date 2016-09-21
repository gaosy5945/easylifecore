package com.amarsoft.app.als.assetTransfer.handler;

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
/**
 * ��������Ŀ�������������ʱ����������ƽ̨����ִ�з���
 * @author zhaoxj and fengcr
 * @2014-12-15
 */
public class ProjectFlowHandler extends CommonHandler {

	@Override
	protected void afterInsert(JBOTransaction tx,BizObject bo) throws Exception {
		String SerialNo = bo.getAttribute("SERIALNO").toString();//bo����ˮ��
		String serialNo = asPage.getAttribute("SerialNo");//ҳ�洫��������ˮ��
		String ProjectType = bo.getAttribute("PROJECTTYPE").toString();
		String TranferPercent = bo.getAttribute("TRANFERPERCENT").toString();
		String RepayOrder = bo.getAttribute("REPAYORDER").toString();
		BizObjectManager pasbm = JBOFactory.getFactory().getManager("jbo.prj.PRJ_ASSET_SECURITIZATION");
		tx.join(pasbm);
		BizObject bo2 = pasbm.newObject();
		bo2.setAttributeValue("PROJECTSERIALNO", serialNo);
		bo2.setAttributeValue("TRANFERPERCENT", TranferPercent);
		bo2.setAttributeValue("REPAYORDER", RepayOrder);
		pasbm.saveObject(bo2);
		BizObjectManager pbm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		tx.join(pbm);
		BusinessObject apply = BusinessObject.createBusinessObject();
		apply.setAttributeValue("ApplyType", "Apply20");
		List<BusinessObject> objects = new ArrayList<BusinessObject>();
		//���Զ�������ˮ���滻��ҳ�洫��������ˮ�ţ���Ϊ������ǰҲ��Ҫ�õ�����ˮ��
		bo.setAttributeValue("SerialNo", serialNo);
		bo.setAttributeValue("Status","01");
		pbm.saveObject(bo);
		objects.add(BusinessObject.convertFromBizObject(bo));
		String flowNo = this.getASDataObject().getCurPage().getParameter("FlowNo");
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		fm.createInstance("jbo.prj.PRJ_BASIC_INFO", objects, flowNo, this.curUser.getUserID(), this.curUser.getOrgID(), apply);
	}
	
	@Override
	protected void afterUpdate(JBOTransaction tx,BizObject bo) throws Exception {
		String SerialNo = bo.getAttribute("SERIALNO").toString();
		String ProjectType = bo.getAttribute("PROJECTTYPE").toString();
		String TranferPercent = bo.getAttribute("TRANFERPERCENT").toString();
		String RepayOrder = bo.getAttribute("REPAYORDER").toString();
		BizObjectManager pasbm = JBOFactory.getFactory().getManager("jbo.prj.PRJ_ASSET_SECURITIZATION");
		tx.join(pasbm);
		BizObjectQuery bq = pasbm.createQuery("update O set TRANFERPERCENT = :TranferPercent,REPAYORDER = :RepayOrder where PROJECTSERIALNO = :SerialNo")
				.setParameter("TranferPercent", TranferPercent).setParameter("RepayOrder", RepayOrder).setParameter("SerialNo", SerialNo);
		bq.executeUpdate();
	}

}
