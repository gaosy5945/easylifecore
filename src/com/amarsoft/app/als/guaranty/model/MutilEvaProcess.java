package com.amarsoft.app.als.guaranty.model;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.ARE;

/**
 * @author
 * 发起押品估值，调押品接口
 */
public class MutilEvaProcess extends ALSBusinessProcess
		implements BusinessObjectOWUpdater {
	
	@Override
	public List<BusinessObject> update(BusinessObject assetEvaluateRelative,
			ALSBusinessProcess businessProcess) throws Exception {
		assetEvaluateRelative.generateKey();
		String serialNo=assetEvaluateRelative.getKeyString();
		
		//生成发送押品系统的数据
		String ApplyNo = serialNo;//申请号
		String EstDestType = "3";//评估目的类型
		String EstMthType = assetEvaluateRelative.getString("EvaluateModel");//评估方法类型
		String InvokeUserId = assetEvaluateRelative.getString("EvaluateUserID");
		String InvokeInstId = assetEvaluateRelative.getString("EvaluateOrgID");
		String PstnType = "1";//岗位类型
		String InrExtEstType = "1";//内外评
		assetEvaluateRelative.setAttributeValue("APPLYSTATUS", "1");
		assetEvaluateRelative.setAttributeValue("APPROVESTATUS", "1");
		this.bomanager.updateBusinessObject(assetEvaluateRelative);
		this.bomanager.updateDB();
		//发起估值接口
		String cmisBTCHApplyNo = "";
		try{
			/*
			OCITransaction oci = ClrInstance.ScdStageIttValEst1(ApplyNo,EstDestType,EstMthType,InvokeUserId,InvokeInstId,PstnType,InrExtEstType,"1",this.bomanager.getTx().getConnection(this.bomanager.getBizObjectManager(assetEvaluateRelative.getObjectType())));
			cmisBTCHApplyNo = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("CMISApplyNo");
			*/
		}catch(Exception ex)
		{
			ex.printStackTrace();
			ARE.getLog().error("ASSET_EVALUATE_RELATIVE_"+assetEvaluateRelative.getKeyString()+"_save_error.");
			throw ex;
		}
		if(cmisBTCHApplyNo == null || "".equals(cmisBTCHApplyNo)) throw new Exception("未取到批量押品发起估值申请号！");
		assetEvaluateRelative.setAttributeValue("CMISBTCHAPPLYNO", cmisBTCHApplyNo);
		this.bomanager.updateBusinessObject(assetEvaluateRelative);
		this.bomanager.updateDB();
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(assetEvaluateRelative);
		return result;
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
