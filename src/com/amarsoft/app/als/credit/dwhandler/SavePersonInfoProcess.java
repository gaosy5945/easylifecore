package com.amarsoft.app.als.credit.dwhandler;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;

/**
 * @author
 * 保存权属人信息
 */
public class SavePersonInfoProcess extends ALSBusinessProcess
		implements BusinessObjectOWUpdater {
	
	@Override
	public List<BusinessObject> update(BusinessObject assetOwner,
			ALSBusinessProcess businessProcess) throws Exception {
		String serialNo=assetOwner.getKeyString();
		if(StringX.isEmpty(serialNo)){
			assetOwner.generateKey();
			serialNo=assetOwner.getKeyString();
		}
		
		assetOwner.setAttributeValue("OwningPercent", 1.0d);
		/*for(BusinessObject bo:ao){
			bo.setAttributeValue("OwningPercent", percent);
			this.bomanager.updateBusinessObject(bo);
		}*/
		
		String OwnerSerialno = assetOwner.getString("SERIALNO");
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(assetOwner);
		
		this.bomanager.updateBusinessObject(assetOwner);
		this.bomanager.updateDB();
		
		//当押品系统编号不为空时，调用保存权属人信息接口
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.app.ASSET_INFO");
		bomanager.getTx().join(table);

		BizObjectQuery q = table.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", assetOwner.getString("AssetSerialNo"));
		BizObject pr = q.getSingleResult(false);
		String  ClrSerialNo = "";
		if(pr!=null)
		{
			ClrSerialNo = pr.getAttribute("CLRSERIALNO").getString();
			if(!StringX.isEmpty(ClrSerialNo)){
				//保存权属人信息接口
				//OCITransaction oci = ClrInstance.RtOwnerInfoSave(OwnerSerialno,this.bomanager.getTx().getConnection(this.bomanager.getBizObjectManager(assetOwner.getObjectType())));
				String OwnerNo = "";//oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("OwnerNo");
				assetOwner.setAttributeValue("CMISSERIALNO", OwnerNo);
				this.bomanager.updateBusinessObject(assetOwner);
				this.bomanager.updateDB();
			}
		}
		
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
