package com.amarsoft.app.als.customer.partner.handler;

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

public class UpdateBuildingInfoHandler extends ALSBusinessProcess
implements BusinessObjectOWUpdater {
	
	public List<BusinessObject> update(BusinessObject prjBuilding,ALSBusinessProcess businessProcess) throws Exception {
		prjBuilding.generateKey();
		//�ж�����prj_building���������Ǹ���
		this.bomanager.updateBusinessObject(prjBuilding);
		
		//����building_info��
		BusinessObject buildingInfo = prjBuilding.getBusinessObject("jbo.app.BUILDING_INFO");
		buildingInfo.generateKey();
		this.bomanager.updateBusinessObject(buildingInfo);
		
		//����building_developer��
		BusinessObject buildingDeveloper = prjBuilding.getBusinessObject("jbo.app.BUILDING_DEVELOPER");
		
		buildingDeveloper.generateKey();
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

