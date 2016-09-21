package com.amarsoft.app.als.guaranty.model;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.ARE;

/**
 * @author
 * ����ѺƷ��ֵ����ѺƷ�ӿ�
 */
public class MutilEvaProcess extends ALSBusinessProcess
		implements BusinessObjectOWUpdater {
	
	@Override
	public List<BusinessObject> update(BusinessObject assetEvaluateRelative,
			ALSBusinessProcess businessProcess) throws Exception {
		assetEvaluateRelative.generateKey();
		String serialNo=assetEvaluateRelative.getKeyString();
		
		//���ɷ���ѺƷϵͳ������
		String ApplyNo = serialNo;//�����
		String EstDestType = "3";//����Ŀ������
		String EstMthType = assetEvaluateRelative.getString("EvaluateModel");//������������
		String InvokeUserId = assetEvaluateRelative.getString("EvaluateUserID");
		String InvokeInstId = assetEvaluateRelative.getString("EvaluateOrgID");
		String PstnType = "1";//��λ����
		String InrExtEstType = "1";//������
		assetEvaluateRelative.setAttributeValue("APPLYSTATUS", "1");
		assetEvaluateRelative.setAttributeValue("APPROVESTATUS", "1");
		this.bomanager.updateBusinessObject(assetEvaluateRelative);
		this.bomanager.updateDB();
		//�����ֵ�ӿ�
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
		if(cmisBTCHApplyNo == null || "".equals(cmisBTCHApplyNo)) throw new Exception("δȡ������ѺƷ�����ֵ����ţ�");
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
