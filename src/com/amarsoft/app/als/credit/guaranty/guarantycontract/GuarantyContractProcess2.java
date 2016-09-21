package com.amarsoft.app.als.credit.guaranty.guarantycontract;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;


/**
 * @author 
 * 引用最高额担保时录入担保债权金额（占用金额）页面
 */
public class GuarantyContractProcess2 extends ALSBusinessProcess 
			implements BusinessObjectOWUpdater{
	
	@Override
	public List<BusinessObject> update(BusinessObject guarantyContract,
			ALSBusinessProcess businessProcess) throws Exception {
		this.bomanager.updateBusinessObject(guarantyContract);
		
		String[] relativeTables=com.amarsoft.app.als.guaranty.model.GuarantyFunctions.getRelativeTable(this.asPage.getParameter("ObjectType"));
		BusinessObject applyRelative = null;
		if(!StringX.isEmpty(relativeTables[0])){
			applyRelative = guarantyContract.getBusinessObject(relativeTables[0]);
		}
		else
			applyRelative = guarantyContract.getBusinessObject("jbo.app.APPLY_RELATIVE");
		applyRelative.generateKey();
		applyRelative.setAttributeValue("ObjectType",guarantyContract.getBizClassName());
		applyRelative.setAttributeValue("ObjectNo",guarantyContract.getKeyString());
		
		this.bomanager.updateBusinessObject(applyRelative);
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(guarantyContract);
		if("Y".equals(this.asPage.getParameter("ChangeFlag"))){	
		}
		return result;
	}


	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}


}
