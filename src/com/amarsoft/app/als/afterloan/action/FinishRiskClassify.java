package com.amarsoft.app.als.afterloan.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

/**
 * 风险分类调整完成
 * @author qzhang2
 *
 */
public class FinishRiskClassify {
	private String duebillSerialNo;
	private String taskSerialNo;
	private String flowSerialNo;
	private String flowStatus;
	
	
	public String getDuebillSerialNo() {
		return duebillSerialNo;
	}

	public void setDuebillSerialNo(String duebillSerialNo) {
		this.duebillSerialNo = duebillSerialNo;
	}

	public String getFlowStatus() {
		return flowStatus;
	}

	public void setFlowStatus(String flowStatus) {
		this.flowStatus = flowStatus;
	}

	public String getTaskSerialNo() {
		return taskSerialNo;
	}

	public void setTaskSerialNo(String taskSerialNo) {
		this.taskSerialNo = taskSerialNo;
	}

	public String getFlowSerialNo() {
		return flowSerialNo;
	}

	public void setFlowSerialNo(String flowSerialNo) {
		this.flowSerialNo = flowSerialNo;
	}

	public String finish(JBOTransaction tx) throws Exception{
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject bo = bom.keyLoadBusinessObject("jbo.flow.FLOW_TASK", this.taskSerialNo);

		String phaseActionType = bo.getString("PHASEACTIONTYPE");
		List<BusinessObject> alList = bom.loadBusinessObjects("jbo.al.CLASSIFY_RECORD","SerialNo in (select FO.ObjectNo from jbo.flow.FLOW_OBJECT FO where FO.FlowSerialNo=:FlowSerialNo )"
				, "FlowSerialNo",flowSerialNo);	
		if(alList != null && !alList.isEmpty()) {
			for(BusinessObject al:alList){
				if("01".equals(phaseActionType)){	
					al.setAttributeValue("CLASSIFYMETHOD",bo.getString("PHASEACTION"));
					al.setAttributeValue("ADJUSTEDGRADE", bo.getString("PHASEACTION1"));
					al.setAttributeValue("FINALGRADE", bo.getString("PHASEACTION1"));	
					al.setAttributeValue("UPDATEDATE",DateHelper.getBusinessDate());	
					al.setAttributeValue("CLASSIFYSTATUS", "0030");
					bom.updateBusinessObject(al);
					
					BusinessObject bd = bom.keyLoadBusinessObject("jbo.app.BUSINESS_DUEBILL",al.getString("ObjectNo"));
					bd.setAttributeValue("CLASSIFYMETHOD",al.getString("CLASSIFYMETHOD"));
					bom.updateBusinessObject(bd);
					
					//判断分类方式是否调整
					if(!bd.getString("CLASSIFYMETHOD").equals(al.getString("CLASSIFYMETHOD"))){
						//发送接口 五级分类方式变更
						String tranTellerNo = "92261005";
						String branchId = "2261";
						String duebillNo = bd.getString("SerialNo");
						String classifyMode = al.getString("CLASSIFYMETHOD");//分类方式
						Item item0 =  CodeCache.getItem("ClassifyMethod", classifyMode);
						String clMode = "0";
						if(item0 != null)
						{
							clMode = item0.getAttribute1();
						}
						String clientCHNName = bd.getString("CUSTOMERNAME");//客户中文名
						try{
							Connection conn = null;
							//CoreInstance.FiveLvlClModeUdt(tranTellerNo, branchId, duebillNo, clMode, clientCHNName, conn);
						}
						catch(Exception e){
							e.printStackTrace();
							throw e;
						}
						
					}
					
					//判断分类结果是否调整
					if((!bd.getString("CLASSIFYRESULT5").equals(al.getString("FINALGRADE"))) &&("01".equals(al.getString("CLASSIFYMETHOD")))){
						
						//修改借据的五级分类结果
						bd.setAttributeValue("CLASSIFYRESULT5",al.getString("FINALGRADE"));
						//修改借据的十级分类结果
						String classifyResult = CodeCache.getItem("ClassifyGrade5", al.getString("FINALGRADE")).getAttribute2();
						bd.setAttributeValue("CLASSIFYRESULT", classifyResult==null||classifyResult.length()==0?"05":classifyResult);
						bom.updateBusinessObject(bd);
						
						//发送接口 五级分类结果变更
						String tranTellerNo = "92261005";
						String branchId = "2261";
						String duebillNo = bd.getString("SerialNo");
						

						String classifyMode = al.getString("CLASSIFYMETHOD");//分类方式						
						Item item0 =  CodeCache.getItem("ClassifyMethod", classifyMode);
						String clMode = "0";
						if(item0 != null)
						{
							clMode = item0.getAttribute1();
						}
						
						String finalGrade = al.getString("FINALGRADE");//贷款分					
						//十级分类转换成五级分类						
						Item item =  CodeCache.getItem("ClassifyGrade5", finalGrade);
						String loanFiveLvlType = "0";
						if(item != null)
						{
							loanFiveLvlType = item.getAttribute1();
						}
						String clientCHNName = bd.getString("CUSTOMERNAME");//客户中文名
						try{
							Connection conn = null;
							//CoreInstance.FiveLvlClInfoSnd(tranTellerNo, branchId, duebillNo, loanFiveLvlType, clMode, clientCHNName, conn);
						}
						catch(Exception e){
							e.printStackTrace();
							throw e;
						}
					}
				}
				else{
					al.setAttributeValue("CLASSIFYSTATUS", "0040");
					bom.updateBusinessObject(al);
				}
			}
		}	
		bom.updateDB();		
		return "提交完成！";
	}
	

}
