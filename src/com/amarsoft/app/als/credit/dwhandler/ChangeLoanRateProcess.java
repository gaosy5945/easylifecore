package com.amarsoft.app.als.credit.dwhandler;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.util.ASValuePool;

public class ChangeLoanRateProcess extends ALSBusinessProcess implements
		BusinessObjectOWUpdater {

	
	public List<BusinessObject> update(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {
		
		String objecttype = businessObject.getBizClassName();
		String objectno = businessObject.getKeyString();
		String rateTermID = businessObject.getString("LoanRateTermID");
		
		//先清空原先保存的还款信息，利率信息
		
		//2、删除利率
		String selectRateSql = " objectno=:ObjectNo and objecttype=:ObjectType and ratetermid<>:RaTeTermID and ratetype='01' and status<>'2' ";
		List<BusinessObject> rateList = this.bomanager.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", selectRateSql, "ObjectNo", objectno,"ObjectType", objecttype,"RaTeTermID", rateTermID);
		for(BusinessObject o:rateList){
			this.bomanager.deleteBusinessObject(o);
		}
		
		this.bomanager.updateBusinessObject(businessObject);
		
		this.bomanager.updateDB();
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(businessObject);
		
		return result;
	}

	
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

}
