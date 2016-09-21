package com.amarsoft.app.als.credit.dwhandler;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.manager.FlowManager;

public class BatchPutOutProcess extends ALSBusinessProcess implements
		BusinessObjectOWUpdater {

	
	public List<BusinessObject> update(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {

		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(this.transaction);
		bomanager.updateBusinessObject(businessObject);
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		fm.setInstanceContext(asPage.getAttribute("FlowSerialNo"), businessObject, this.curUser.getUserID(), this.curUser.getOrgID());;
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(businessObject);
		return result;
	}

	
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

}
