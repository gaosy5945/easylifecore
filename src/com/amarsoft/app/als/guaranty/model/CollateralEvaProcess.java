package com.amarsoft.app.als.guaranty.model;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.util.Transaction;

/**
 * @author
 * 发起押品估值，调押品接口
 */
public class CollateralEvaProcess extends ALSBusinessProcess
		implements BusinessObjectOWUpdater {
	
	@Override
	public List<BusinessObject> update(BusinessObject assetEvaluate,
			ALSBusinessProcess businessProcess) throws Exception {
		assetEvaluate.generateKey();
		String serialNo=assetEvaluate.getKeyString();
		
		//生成发送押品系统的数据
		String cmisapplyno = "";
		String ApplyNo = serialNo;//申请号
		String EstDestType = assetEvaluate.getString("EvaluateScenario");//评估目的类型
		String EstMthType = assetEvaluate.getString("EvaluateModel");//评估方法类型
		String InvokeUserId = assetEvaluate.getString("EvaluateUserID");
		String InvokeInstId = assetEvaluate.getString("EvaluateOrgID");
		String PstnType = "1";//岗位类型
		String InrExtEstType = assetEvaluate.getString("EvaluateMethod");//内外评
		this.bomanager.updateBusinessObject(assetEvaluate);
		this.bomanager.updateDB();
		//发起估值接口
		String cmisApplyNo = "";
		String evaFinishDate = ""; //评估有效截止日
		if("4".equals(InrExtEstType)) {
			try{
				/*OCITransaction oci = ClrInstance.DrcEstMthIttEst(ApplyNo,this.bomanager.getTx().getConnection(this.bomanager.getBizObjectManager(assetEvaluate.getObjectType())));
				cmisApplyNo = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("CMISApplyNo");
				evaFinishDate = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("EstMatDate");
				*/
			}catch(Exception ex)
			{
				ex.printStackTrace();
				ARE.getLog().error("ASSET_EVALUATE_"+assetEvaluate.getKeyString()+"_save_error.");
				throw ex;
			}
			if(cmisApplyNo == null || "".equals(cmisApplyNo)) throw new Exception("未取到押品发起估值申请号！");
			assetEvaluate.setAttributeValue("CMISApplyNo", cmisApplyNo);
			assetEvaluate.setAttributeValue("EVAFINISHDATE", evaFinishDate);
			this.bomanager.updateBusinessObject(assetEvaluate);
			this.bomanager.updateDB();
			
			List<BusinessObject> result = new ArrayList<BusinessObject>();
			result.add(assetEvaluate);
			return result;
		} else {
			try{
				/*OCITransaction oci = ClrInstance.ScdStageIttValEst(ApplyNo,EstDestType,EstMthType,InvokeUserId,InvokeInstId,PstnType,InrExtEstType,"0",this.bomanager.getTx().getConnection(this.bomanager.getBizObjectManager(assetEvaluate.getObjectType())));
				cmisApplyNo = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("CMISApplyNo");
				*/
			}catch(Exception ex)
			{
				ex.printStackTrace();
				ARE.getLog().error("ASSET_EVALUATE_"+assetEvaluate.getKeyString()+"_save_error.");
				throw ex;
			}
			
			
			String objectType = "jbo.app.ASSET_EVALUATE";
			
			List<BusinessObject> objects = new ArrayList<BusinessObject>();
			objects.add(assetEvaluate);
			
			String flowNo = "S0215.plbs_collateral.Flow_016";
			String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
			BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(this.bomanager.getTx());
			FlowManager fm = FlowManager.getFlowManager(bomanager);
			fm.createInstance(objectType, getListFilter(), flowNo, InvokeUserId, InvokeInstId, assetEvaluate);
			
			//流程是否启动不影响整个数据处理
			try{
				//OCITransaction trans1 = BPMPInstance.StrtPcsInstnc(instanceID,"N", "", InvokeUserId, this.bomanager.getTx().getConnection(this.bomanager.getBizObjectManager(assetEvaluate.getBizClassName())));
			}catch(Exception ex)
			{
				ex.printStackTrace();
				ARE.getLog().error("ASSET_EVALUATE_"+assetEvaluate.getKeyString()+"_save_error.");
				throw ex;
			}
			
			if(cmisApplyNo == null || "".equals(cmisApplyNo)) throw new Exception("未取到押品发起估值申请号！");
			assetEvaluate.setAttributeValue("CMISApplyNo", cmisApplyNo);
			this.bomanager.updateBusinessObject(assetEvaluate);
			this.bomanager.updateDB();
			
			List<BusinessObject> result = new ArrayList<BusinessObject>();
			result.add(assetEvaluate);
			return result;
		}
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		for(BusinessObject businessObject:businessObjectList){
			this.update(businessObject, businessProcess);
		}
		return businessObjectList;
	}

}
