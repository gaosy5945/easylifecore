package com.amarsoft.app.lending.bizlets;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
/**
 * 
 * @author T-wur
 *功能：启动贷后检查流程
 */
public class RiskAdjustConfirm extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{	
		String userID=(String)this.getAttribute("userID");
		String orgID=(String)this.getAttribute("orgID");
		String duebillNo=(String)this.getAttribute("DuebillNo");
		String flowNo=(String)this.getAttribute("FlowNo");
		
		
		if(flowNo == null || "".equals(flowNo)) flowNo = "S0215.plbs_afterloan03.Flow_012";
		String objectType = "jbo.al.CLASSIFY_RECORD";
		String serialNo = "", referenceGrade = "";
		
		try{
			List<BusinessObject> objects = new ArrayList<BusinessObject>();
			String[] duebillNoArray = duebillNo.split("~");
			for(String no:duebillNoArray)
			{
				//产生分类数据
				BizObjectManager bdm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
				BizObjectQuery bdq = bdm.createQuery("SerialNo=:SerialNo");
				bdq.setParameter("SerialNo", no);
				BizObject bqbo = bdq.getSingleResult(false);
				
				BizObjectManager crm = JBOFactory.getBizObjectManager(objectType);
				BizObject crbo = crm.newObject();
				crbo.setAttributeValue("ObjectType", "jbo.app.BUSINESS_DUEBILL");
				crbo.setAttributeValue("ObjectNo", no);
				crbo.setAttributeValue("ClassifyMonth", DateHelper.getBusinessDate().substring(0, 7));
				crbo.setAttributeValue("ClassifyDate", DateHelper.getBusinessDate());				
				referenceGrade = bqbo.getAttribute("CLASSIFYRESULT5").getString();	
				crbo.setAttributeValue("REFERENCEGRADE", referenceGrade);
				crbo.setAttributeValue("FINALGRADE", referenceGrade);
				
				if("01".equals(bqbo.getAttribute("ClassifyMethod").getString())){
					crbo.setAttributeValue("ClassifyMethod","02");
					crbo.setAttributeValue("ADJUSTEDGRADE", referenceGrade);	
				}else{
					crbo.setAttributeValue("ClassifyMethod","01");
				}
				crbo.setAttributeValue("CLASSIFYMODEL","01");
				crbo.setAttributeValue("ClassifyStatus","0010");
				crbo.setAttributeValue("ClassifyUserID", userID);
				crbo.setAttributeValue("ClassifyOrgID", orgID);
				crbo.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
				crm.saveObject(crbo);
			
				serialNo = crbo.getAttribute("SerialNo").getString();
				objects.add(BusinessObject.convertFromBizObject(crbo));
			}
			BusinessObject apply = BusinessObject.createBusinessObject();
			for(int i=0;i<this.getAttributes().getKeys().length;i++){
				String key = this.getAttributes().getKeys()[i].toString();
				Object value = this.getAttribute(key);
				apply.setAttributeValue(key, value);
			}
			String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
			BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(Sqlca.getTransaction());
			FlowManager fm = FlowManager.getFlowManager(bomanager);
			String result = fm.createInstance(objectType, objects, flowNo, userID, orgID, apply);
			
			String instanceID = result.split("@")[0];
			String phaseNo = result.split("@")[1];
			String taskSerialNo = result.split("@")[2];
			String functionID = FlowConfig.getFlowPhase(flowNo, flowVersion, phaseNo).getString("FunctionID");
			
			return "true@"+serialNo+"@"+functionID+"@"+instanceID+"@"+taskSerialNo+"@"+phaseNo+"@新增成功！";
		}catch(Exception ex){
			throw ex;
		}
	}
	
}
