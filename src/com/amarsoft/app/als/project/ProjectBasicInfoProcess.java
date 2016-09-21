package com.amarsoft.app.als.project;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.are.lang.StringX;

public class ProjectBasicInfoProcess  extends ALSBusinessProcess implements BusinessObjectOWUpdater{
	public List<BusinessObject> update(BusinessObject ba, ALSBusinessProcess businessProcess) throws Exception {
		String SerialNo=ba.getKeyString();
		String CustomerID = ba.getString("CustomerID");
		if(StringX.isEmpty(SerialNo)){
			ba.generateKey();
		}
		this.bomanager.updateBusinessObject(ba);
		
		String flowSerialNo = this.asPage.getParameter("FlowSerialNo");
		String applyType = this.asPage.getParameter("ApplyType");
		String projectType = this.asPage.getParameter("ProjectType");
		if(!"0110".equals(projectType)){//当项目类型不为零星期房（零星期房不走流程）时，则走流程
			List<BusinessObject> boList = new ArrayList<BusinessObject>();
	        BusinessObject boo = BusinessObject.createBusinessObject("jbo.prj.PRJ_BASIC_INFO");
	        boo.setAttributesValue(ba);
	        
			//获取流程定义参数
			String flowNo = "ProjectFlow";
			String flowVersion = "V1.0";
			List<BusinessObject> paraList = FlowConfig.getFlowCatalogPara(flowNo, flowVersion);
			
			List<BusinessObject> clList =bomanager.loadBusinessObjects("jbo.customer.CUSTOMER_LIST", "CustomerID=:CustomerID","CustomerID", CustomerID);
			boo.setAttributesValue(clList.get(0));
			boList.add(boo);
			
			BusinessObject para = BusinessObject.createBusinessObject();
			para.setAttributeValue("OrgID", this.curUser.getOrgID());
			para.setAttributeValue("UserID", this.curUser.getUserID());
			
			if("".equals(applyType) || applyType == null){
				String parmName = "APPLYTYPE";
				Map<String,String> map = new HashMap<String,String>();
				map.put("CntxtParmName", parmName);
				ArrayList<Map<String, String>> array = new ArrayList<Map<String, String>>();
				array.add(map);
				/*
				OCITransaction transApplytType = BPMPInstance.PcsInstncCntxtQry(flowSerialNo, array, bomanager.getTx().getConnection(bomanager.getBizObjectManager("jbo.customer.CUSTOMER_LIST")));
				
				Message response = transApplytType.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage();
				List<Message> imessage = response.getFieldByTag("CntxtParmInfo").getFieldArrayValue();
				if(imessage != null && !imessage.isEmpty())
				{
					for(Message message:imessage)
					{
						if(parmName.equalsIgnoreCase(message.getFieldValue("CntxtParmName")))
						{
							applyType = message.getFieldValue("CntxtParmVal");
							applyType = applyType.replaceAll("<"+parmName+">", "");
							applyType = applyType.replaceAll("</"+parmName+">", "");
						}
					}
				}*/			
			}
				para.setAttributeValue("ApplyType", applyType);
			
			//获取上下文
			//String context = FlowHelper.getContext(paraList,boList,para,bomanager.getTx().getConnection(bomanager.getBizObjectManager("jbo.customer.CUSTOMER_LIST")));
			
			//OCITransaction trans = BPMPInstance.SetPcsInstncCntxt(flowSerialNo, context, bomanager.getTx().getConnection(bomanager.getBizObjectManager("jbo.customer.CUSTOMER_LIST")));
		}
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(ba);
		return result;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
}