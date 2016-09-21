package com.amarsoft.app.als.credit.guaranty.guarantycontract;

import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWDeleter;
import com.amarsoft.app.base.businessobject.BusinessObject;

/**
 * @author
 * 新增最高额担保信息页面
 */
public class GuarantyCLRListProcess extends ALSBusinessProcess
		implements BusinessObjectOWDeleter {

	@Override
	public int delete(BusinessObject clrList,
			ALSBusinessProcess businessProcess) throws Exception {
		List<BusinessObject> accountList = this.bomanager.loadBusinessObjects("jbo.acct.ACCT_BUSINESS_ACCOUNT", "ObjectType='jbo.guaranty.CLR_MARGIN_INFO' and ObjectNo=:ObjectNo  ", 
				"ObjectNo",clrList.getKeyString());
		if(accountList != null && accountList.size() != 0)
			this.bomanager.deleteBusinessObject(accountList.get(0));
		
		this.bomanager.deleteBusinessObject(clrList);
		return 1;
	}

	@Override
	public int delete(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}


}
