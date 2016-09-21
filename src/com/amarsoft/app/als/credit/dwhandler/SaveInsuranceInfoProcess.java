package com.amarsoft.app.als.credit.dwhandler;

import java.sql.Connection;
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
 * ���汣����Ϣ
 */
public class SaveInsuranceInfoProcess extends ALSBusinessProcess
		implements BusinessObjectOWUpdater {
	
	@Override
	public List<BusinessObject> update(BusinessObject assetInsurance,
			ALSBusinessProcess businessProcess) throws Exception {
		String serialNo=assetInsurance.getKeyString();
		if(StringX.isEmpty(serialNo)){
			assetInsurance.generateKey();
			serialNo=assetInsurance.getKeyString();
			 
		}
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(assetInsurance);
		
		this.bomanager.updateBusinessObject(assetInsurance);
		this.bomanager.updateDB();
		
		//��ѺƷϵͳ��Ų�Ϊ��ʱ�����ñ��汣����Ϣ�ӿ�
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.app.ASSET_INFO");
		bomanager.getTx().join(table);

		BizObjectQuery q = table.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", assetInsurance.getString("ObjectNo"));
		BizObject pr = q.getSingleResult(false);
		String  ClrSerialNo = "";
		if(pr!=null)
		{
			ClrSerialNo = pr.getAttribute("CLRSERIALNO").getString();
			if(!StringX.isEmpty(ClrSerialNo)){
				//���汣����Ϣ�ӿ�
				String InsRcdNo = "";
				//OCITransaction oci = ClrInstance.InsInfoSave(serialNo,this.bomanager.getTx().getConnection(this.bomanager.getBizObjectManager(assetInsurance.getObjectType())));
				//InsRcdNo = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("InsRcdNo");
				assetInsurance.setAttributeValue("CMISSERIALNO", InsRcdNo);
				this.bomanager.updateBusinessObject(assetInsurance);
				this.bomanager.updateDB();
			}
		}

		return result;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		return null;
	}
}
