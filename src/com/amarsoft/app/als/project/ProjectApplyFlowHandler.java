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
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class ProjectApplyFlowHandler extends CommonHandler {
	@Override
	protected void afterInsert(JBOTransaction tx,BizObject bo) throws Exception {
		
		BizObjectManager pbm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		tx.join(pbm);
		
		String applyTemp = this.getASDataObject().getCurPage().getParameter("ApplyType");
		BusinessObject apply = BusinessObject.createBusinessObject();
		apply.setAttributeValue("ApplyType", applyTemp);

		List<BusinessObject> objects = new ArrayList<BusinessObject>();
		objects.add(BusinessObject.convertFromBizObject(bo));

		String flowNo = this.getASDataObject().getCurPage().getParameter("FlowNo");
		String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		fm.createInstance("jbo.prj.PRJ_BASIC_INFO", objects, flowNo, this.curUser.getUserID(), this.curUser.getOrgID(), apply);
		//OCITransaction trans1 = BPMPInstance.StrtPcsInstnc(instanceID,"N", "", this.curUser.getUserID(), tx.getConnection(manager));
	}
}
