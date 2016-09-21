package com.amarsoft.app.als.project;

/**
 * @author ������
 * @˵����¥����Ϣ�������
 * 
 */

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.lang.StringX;

public class UpdateBuildingManageHandler extends ALSBusinessProcess
implements BusinessObjectOWUpdater {
	public List<BusinessObject> update(BusinessObject buildingInfo,ALSBusinessProcess businessProcess) throws Exception {
		//�ж�����building_info���������Ǹ���
		String buildingInfoSerialNo=buildingInfo.getKeyString();
		if(StringX.isEmpty(buildingInfoSerialNo)){
			buildingInfo.generateKey();
		}
		this.bomanager.updateBusinessObject(buildingInfo);
		
		//����prj_building��
		BusinessObject prjBuilding = buildingInfo.getBusinessObject("jbo.prj.PRJ_BUILDING");
		String prjBuildingSerialNo=prjBuilding.getKeyString();

		if(StringX.isEmpty(prjBuildingSerialNo)){
			prjBuilding.generateKey();
		}
		this.bomanager.updateBusinessObject(prjBuilding);
		
		//����building_developer��
		BusinessObject buildingDeveloper = buildingInfo.getBusinessObject("jbo.app.BUILDING_DEVELOPER");
		String buildingDeveloperSerialNo=buildingDeveloper.getKeyString();

		if(StringX.isEmpty(buildingDeveloperSerialNo)){
			buildingDeveloper.generateKey();
		}
		this.bomanager.updateBusinessObject(buildingDeveloper);
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(prjBuilding);
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
