package com.amarsoft.app.risk;
/**
 * add by bhxiao 
 * 发起预警
 * */
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class StartPLRiskWarning extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {//预警发起
		String valueList = (String) this.getAttribute("ValueList");
		String riskSignalType = (String) this.getAttribute("RiskSignalType");
		String userid = (String) this.getAttribute("UserID");
		String flowNo = (String) this.getAttribute("FlowNo");
		if(valueList==null||valueList.length()==0)valueList="";
		if(riskSignalType==null||riskSignalType.length()==0)riskSignalType="";
		if(userid==null||userid.length()==0)userid="";
		
		if(valueList.length()==0)
			throw new Exception("传入预警对象为空，无法发起风险预警！");
		
		ASUserObject curUser = ASUserObject.getUser(userid);
		
		JBOTransaction tx = null;
		try
		{
			tx = JBOFactory.createJBOTransaction();
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager rws = f.getManager("jbo.al.RISK_WARNING_SIGNAL");
				String [] values = valueList.split("~", -1);
				for(int i=0;i<values.length;i++)
				{
					tx.join(rws);
					String serialNo = values[i];
					rws.createQuery("UPDATE O SET InputOrgID = :InputOrgID WHERE SERIALNO = :SERIALNO")
					.setParameter("InputOrgID", curUser.getOrgID()).setParameter("SERIALNO", serialNo).executeUpdate();
					BusinessObject apply = null;
					for(int k=0;k<this.getAttributes().getKeys().length;k++){
						String key = this.getAttributes().getKeys()[k].toString();
						Object value = this.getAttribute(key);
						apply.setAttributeValue(key, value);
					}
					apply.setAttributeValue("OrgID", curUser.getOrgID());
					List<BusinessObject> objects = new ArrayList<BusinessObject>();
					objects.add(BusinessObjectManager.createBusinessObjectManager(tx).keyLoadBusinessObject("jbo.al.RISK_WARNING_SIGNAL", serialNo));
					String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
					BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
					FlowManager fm = FlowManager.getFlowManager(bomanager);
					fm.createInstance("jbo.al.RISK_WARNING_SIGNAL", objects, flowNo, curUser.getUserID(), curUser.getOrgID(),apply);
					tx.commit();
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
