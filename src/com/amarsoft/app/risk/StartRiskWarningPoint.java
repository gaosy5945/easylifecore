package com.amarsoft.app.risk;
/**
 * add by bhxiao 
 * 发起预警
 * */

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.script.WebBusinessProcessor;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;
import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.JBOTransaction;


public class StartRiskWarningPoint extends WebBusinessProcessor{
	
	public String reRunRiskPoint(JBOTransaction tx) throws Exception {
		this.setTx(tx);
		String riskSignalSerialNoString=this.getStringValue("RiskSignalSerialNoString");
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> riskSignalList =	BusinessObjectFactory.copy("jbo.al.RISK_WARNING_SIGNAL", riskSignalSerialNoString,"@", bomanager);
		
		String flowNo = this.getStringValue("FlowNo");
		ASUserObject curUser = this.getCurUser();
		
		BusinessObject apply = BusinessObject.createBusinessObject();
		apply.setAttributeValue("ApplyType",this.getStringValue("ApplyType"));
		
		for(BusinessObject riskSignal:riskSignalList){
			riskSignal.setAttributeValue("Status","0");
			bomanager.updateBusinessObject(riskSignal);
			bomanager.updateDB();
			List<BusinessObject> flowobjectSerialNo = new ArrayList<BusinessObject>();
			flowobjectSerialNo.add(riskSignal);
			FlowManager fm = FlowManager.getFlowManager(bomanager);
			fm.createInstance("jbo.al.RISK_WARNING_SIGNAL01", flowobjectSerialNo,flowNo, curUser.getUserID(), curUser.getOrgID(),apply);
		}
		return "true@新增成功！";
	}

}
