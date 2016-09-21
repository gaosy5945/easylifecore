package com.amarsoft.app.risk;
/**
 * add by bhxiao 
 * 发起预警
 * */
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.dict.als.manage.NameManager;


public class StartRiskWarningGiveOut extends Bizlet {

	@Override
	public Object run(Transaction Sqlca) throws Exception {

		String serialNo = (String) this.getAttribute("ValueList");
		String OrgIDs = (String) this.getAttribute("OrgIDs");
		String userid = (String) this.getAttribute("UserID");
		String flowNo = "S0215.plbs_afterloan04.Flow_019";
		if(serialNo==null||serialNo.length()==0)serialNo="";
		if(userid==null||userid.length()==0)userid="";
		if(OrgIDs==null||OrgIDs.length()==0)OrgIDs="";
		
		if(serialNo.length()==0)
			throw new Exception("传入预警对象为空，无法发起风险预警！");
		
		ASUserObject curUser = ASUserObject.getUser(userid);
		
		JBOTransaction tx = null;
		try
		{
			tx = JBOFactory.createJBOTransaction();
			BizObjectManager bmRWS = JBOFactory.getFactory().getManager("jbo.al.RISK_WARNING_SIGNAL");
			tx.join(bmRWS);
			
			BusinessObject apply = BusinessObject.createBusinessObject();
			for(int k=0;k<this.getAttributes().getKeys().length;k++){
				String key = this.getAttributes().getKeys()[k].toString();
				Object value= this.getAttribute(key);
				apply.setAttributeValue(key, value);
			}
			apply.setAttributeValue("GiveoutOrgID", OrgIDs);
			List<BusinessObject> objects = new ArrayList<BusinessObject>();
			Map<String,Object> mp = new HashMap<String,Object>();
			for(int i=0;i<this.getAttributes().getKeys().length;i++){
				mp.put(this.getAttributes().getKeys()[i].toString(), this.getAttribute(this.getAttributes().getKeys()[i].toString()));
			}
			BusinessObject bo = BusinessObject.createBusinessObject(mp);
			objects.add(bo);
			
			String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
			BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
			FlowManager fm = FlowManager.getFlowManager(bomanager);
			String result = fm.createInstance("jbo.al.RISK_WARNING_SIGNAL01", objects,flowNo, curUser.getUserID(), curUser.getOrgID(),apply);
			String instanceID = result.split("@")[0];
			String phaseNo = result.split("@")[1];
			String taskSerialNo = result.split("@")[2];
			
			BizObjectManager bmFT = JBOFactory.getFactory().getManager("jbo.flow.FLOW_TASK");
			tx.join(bmFT);
			BizObject boFT;
			for(String orgID:OrgIDs.split("@")){
				boFT = bmFT.newObject();
				boFT.setAttributeValue("TaskSerialNo", DBKeyHelp.getSerialNo("FLOW_TASK","TASKSERIALNO",""));
				boFT.setAttributeValue("FlowSerialNo", instanceID);
				boFT.setAttributeValue("UserID", curUser.getUserID());
				boFT.setAttributeValue("ORGID", orgID);
				boFT.setAttributeValue("ORGName", NameManager.getOrgName(orgID));
				boFT.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
				bmFT.saveObject(boFT);
			}
			
			tx.commit();
			return "true@新增成功！";
		}catch(Exception ex)
		{
			ex.printStackTrace();
			tx.rollback();
			return "false@流程启动失败，请重新选择！";
		}
	}

}
