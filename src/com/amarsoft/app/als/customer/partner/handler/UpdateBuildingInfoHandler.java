package com.amarsoft.app.als.customer.partner.handler;

/**
 * @author 柳显涛
 * @说明：楼盘信息多表保存类
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
		//判断主表prj_building是新增还是更新
		this.bomanager.updateBusinessObject(prjBuilding);
		
		//保存building_info表
		BusinessObject buildingInfo = prjBuilding.getBusinessObject("jbo.app.BUILDING_INFO");
		buildingInfo.generateKey();
		this.bomanager.updateBusinessObject(buildingInfo);
		
		//保存building_developer表
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

