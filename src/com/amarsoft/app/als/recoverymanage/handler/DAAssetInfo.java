package com.amarsoft.app.als.recoverymanage.handler;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.lang.StringX;

public class DAAssetInfo  extends ALSBusinessProcess implements BusinessObjectOWUpdater {

	public List<BusinessObject> update(BusinessObject ba, ALSBusinessProcess businessProcess) throws Exception {
		
		String serialNo=ba.getKeyString();
		if(StringX.isEmpty(serialNo)){
			ba.generateKey();
		}
		this.bomanager.updateBusinessObject(ba);
		
		//±£´æasset_info±í
		BusinessObject AI = ba.getBusinessObject("jbo.app.ASSET_INFO");
		this.bomanager.updateBusinessObject(AI);
		this.bomanager.updateDB();
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(ba);
		return result;
	}

	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		return null;
	}

}
