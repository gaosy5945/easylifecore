package com.amarsoft.app.lending.bizlets;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.credit.putout.action.AddPutOutInfo;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitPutOutInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{	
		String userID=(String)this.getAttribute("userID");
		String orgID=(String)this.getAttribute("orgID");
		String contractSerialNo=(String)this.getAttribute("SerialNo");

		String objectType = "jbo.app.BUSINESS_PUTOUT";
		JBOTransaction tx = null;
		try{
			tx = JBOFactory.createJBOTransaction();
			
			BizObjectManager bpm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_PUTOUT");
			tx.join(bpm);
			
			AddPutOutInfo add = new AddPutOutInfo();
			add.setUserID(userID);
			add.setOrgID(orgID);
			add.setContractSerialNo(contractSerialNo);
			BizObject bp =  add.createPutOut(tx);
			String putoutSerialNo = bp.getAttribute("SerialNo").getString();
			List<BusinessObject> objects = new ArrayList<BusinessObject>();
			objects.add(BusinessObject.convertFromBizObject(bp));
			
			String productID = bp.getAttribute("ProductID").getString();
			if(productID == null || "".equals(productID)) productID = bp.getAttribute("BusinessType").getString();
			if(productID == null || "".equals(productID)) productID = "";
			
			//业务流程定义
			String flowNo = ProductAnalysisFunctions.getComponentDefaultValue(BusinessObject.convertFromBizObject(bp), "PRD04-02", "CreditPutOutFlowNo","0010", "01");
			if(flowNo == null || "".equals(flowNo)) flowNo = "S0215.plbs_business03.Flow_007";
			
			String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
			BusinessObject bot = BusinessObject.createBusinessObject();
			for(int i=0;i<this.getAttributes().getKeys().length;i++){
				String key = this.getAttributes().getKeys()[i].toString();
				Object value = this.getAttribute(key);
				bot.setAttributeValue(key, value);
			}
			BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
			FlowManager fm = FlowManager.getFlowManager(bomanager);
			String result = fm.createInstance(objectType, objects, flowNo, userID, orgID, bot);
			
			String instanceID = result.split("@")[0];
			String phaseNo = result.split("@")[1];
			String taskSerialNo = result.split("@")[2];
			String functionID = FlowConfig.getFlowPhase(flowNo, flowVersion, phaseNo).getString("FunctionID");
			tx.commit();
			return "true@"+putoutSerialNo +"@"+functionID+"@"+instanceID+"@"+taskSerialNo+"@"+phaseNo+"@新增成功！";
		}catch(Exception ex){
			if(tx != null) tx.rollback();
			throw ex;
		}
	}
	
}
