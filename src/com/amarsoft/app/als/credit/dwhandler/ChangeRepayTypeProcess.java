package com.amarsoft.app.als.credit.dwhandler;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.util.ASValuePool;

public class ChangeRepayTypeProcess extends ALSBusinessProcess implements
		BusinessObjectOWUpdater {

	
	public List<BusinessObject> update(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {
		String objecttype = businessObject.getBizClassName();
		String objectno = businessObject.getKeyString();
		String rptTermID = businessObject.getString("RPTTermID");
		
		//先清空原先保存的还款信息，利率信息
		//1、删除还款信息
		String selectRPTSql = " objectno=:ObjectNo and objecttype=:ObjectType and rpttermid<>:RPTTermID and status<>'2' ";
		List<BusinessObject> rptList = this.bomanager.loadBusinessObjects("jbo.acct.ACCT_RPT_SEGMENT", selectRPTSql, "ObjectNo", objectno,"ObjectType", objecttype,"RPTTermID", rptTermID);
		for(BusinessObject o:rptList){
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
