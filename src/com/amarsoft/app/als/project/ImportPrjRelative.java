package com.amarsoft.app.als.project;

/**
 * 项目变更新增类
 * @柳显涛
 */

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class ImportPrjRelative {
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	public String importPrjAndCopyPrj(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String ProjectSerialNo = (String)inputParameter.getValue("ProjectSerialNo");
		String ObjectType = (String)inputParameter.getValue("ObjectType");
		String RelativeType = (String)inputParameter.getValue("RelativeType");
		String userID = (String)inputParameter.getValue("userID");
		String orgID = (String)inputParameter.getValue("orgID");

		String fromSerialNo = ProjectSerialNo;
		CopyProject cp = new CopyProject();
		String sReturn = cp.copyTable(tx, fromSerialNo, RelativeType);
		String copySerialNo = sReturn.split("@")[1];
		String result = importPrjRelative(copySerialNo,ObjectType,ProjectSerialNo,RelativeType);
		String sResult = "";
		if("0301".equals(RelativeType)){
			//流程启动
			String copySerialNoNew = sReturn.split("@")[1];
			BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
			tx.join(table);
			BizObjectQuery q = table.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", copySerialNoNew);
			BizObject bo = q.getSingleResult(false);
			sResult = startFlow(tx,bo,userID,orgID);
		}
		return copySerialNo+"@"+sResult;
	}
	
	public String importPrjRelative(String copySerialNo,String ObjectType,String ProjectSerialNo,String RelativeType) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
		tx.join(bm);

		BizObject bo = bm.newObject();
		bo.setAttributeValue("PROJECTSERIALNO", copySerialNo);
		bo.setAttributeValue("OBJECTTYPE", ObjectType);
		bo.setAttributeValue("OBJECTNO", ProjectSerialNo);
		bo.setAttributeValue("RELATIVETYPE", RelativeType);
		bm.saveObject(bo);
		String serialNo = bo.getAttribute("SerialNo").toString();
		String lastSerialNo = bo.getAttribute("ObjectNo").toString();
		return "SUCCEED@"+serialNo+"@"+lastSerialNo;
	}
	
	public String updatePrjSatus(JBOTransaction tx,String projectSerialNo) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		tx.join(bm);
		
		bm.createQuery("update O set status=:status,updateDate=:updateDate Where serialNo=:serialNo")
		  .setParameter("status", "16").setParameter("updateDate", DateHelper.getBusinessDate()).setParameter("serialNo", projectSerialNo).executeUpdate();
		
		return "SUCCEED";
	}
	
	public String startFlow(JBOTransaction tx,BizObject bo,String userID,String orgID) throws Exception{
		BizObjectManager pbm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		tx.join(pbm);
		
		BusinessObject apply = BusinessObject.createBusinessObject();
		apply.setAttributeValue("ApplyType", "Apply91");
		
		List<BusinessObject> objects = new ArrayList<BusinessObject>();
		objects.add(BusinessObject.convertFromBizObject(bo));

		String flowNo = "S0215.plbs_cooperation.Flow_015";
		String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		fm.createInstance("jbo.prj.PRJ_BASIC_INFO", objects, flowNo, userID, orgID, apply);
		//OCITransaction trans1 = BPMPInstance.StrtPcsInstnc(instanceID,"N", "", userID, tx.getConnection(pbm));
		
		try{
			//OCITransaction trans1 = BPMPInstance.StrtPcsInstnc(instanceID,"N", "", userID, tx.getConnection(pbm));
		}catch(Exception ex)
		{
			ex.printStackTrace();
			return "false@"+"" +"@ @ @ @ @流程启动失败，请重新保存！";
		}
		/*
		OCITransaction trans = BPMPInstance.PcsInstncRunningTaskQry(instanceID, "Y", 0, 15, tx.getConnection(pbm));
		
		Message response = trans.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage();
		List<Message> imessage = response.getFieldByTag("BPMTaskInfoNoCntxt").getFieldArrayValue();
		String phaseNo = imessage.get(0).getFieldValue("AvyDfnId");
		String taskSerialNo = imessage.get(0).getFieldValue("TaskId");
		String functionID = FlowConfig.getFlowModel(flowNo, flowVersion, phaseNo).getString("FunctionID");
		tx.commit();
		
		return "true@"+functionID+"@"+instanceID+"@"+taskSerialNo+"@"+phaseNo;
		*/
		return "";
	}
	
}
