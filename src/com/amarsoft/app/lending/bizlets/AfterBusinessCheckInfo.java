package com.amarsoft.app.lending.bizlets;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;
/**
 * 
 * @author T-zhangwl
 *功能：启动贷后检查流程
 */
public class AfterBusinessCheckInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{	
		String userID=(String)this.getAttribute("userID");
		String orgID=(String)this.getAttribute("orgID");
		String serialNo=(String)this.getAttribute("SerialNo");
		String creditInspectType = (String)this.getAttribute("CreditInspectType");
		if(userID==null) userID="";
		if(orgID==null) orgID="";
		if(serialNo==null) serialNo="";
		if(creditInspectType==null) creditInspectType="";

		//检查对象类型
		Item item = CodeCache.getItem("InspectObjectType", creditInspectType);
		String objectType = item.getItemDescribe();
		//String objectType = "jbo.al.INSPECT_RECORD";
		try{
			
			List<String> objects = new ArrayList<String>();
			objects.add(serialNo);
			
			String flowNo = "S0215.plbs_afterloan02.Flow_011";
			String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
			/*
			String instanceID = FlowHelper.initFlow(objectType, objects,flowNo, flowVersion, userID, orgID,BusinessObject.createBusinessObject(this.getAttributes()), Sqlca.getConnection());
			Sqlca.commit();
			//流程是否启动不影响整个数据处理
			try{
				OCITransaction trans1 = BPMPInstance.StrtPcsInstnc(instanceID,"N", "", userID, Sqlca.getConnection());
			}catch(Exception ex)
			{
				ex.printStackTrace();
				return "false@"+serialNo +"@ @ @ @ @流程启动失败，请重新保存！";
			}
			
			OCITransaction trans = BPMPInstance.PcsInstncRunningTaskQry(instanceID, "Y", 0, 15, Sqlca.getConnection());
			
			Message response = trans.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage();
			List<Message> imessage = response.getFieldByTag("BPMTaskInfoNoCntxt").getFieldArrayValue();
			String phaseNo = imessage.get(0).getFieldValue("AvyDfnId");
			String taskSerialNo = imessage.get(0).getFieldValue("TaskId");
			String functionID = FlowConfig.getFlowModel(flowNo, flowVersion, phaseNo).getString("FunctionID");
			
			return "true@"+serialNo +"@"+functionID+"@"+instanceID+"@"+taskSerialNo+"@"+phaseNo+"@新增成功！";
			*/
			return "";
		}catch(Exception ex){
			throw ex;
		}
	}
	
}
