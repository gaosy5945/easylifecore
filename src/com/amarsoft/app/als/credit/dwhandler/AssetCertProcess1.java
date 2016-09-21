package com.amarsoft.app.als.credit.dwhandler;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWDeleter;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.manage.CodeManager;

/**
 * @author t-zhangq2
 *	����Ѻ�Ǽ�Ȩ֤
 */
public class AssetCertProcess1 extends ALSBusinessProcess implements BusinessObjectOWDeleter,BusinessObjectOWUpdater{

	@Override
	public List<BusinessObject> update(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {
		businessObject.generateKey();
		this.bomanager.updateBusinessObject(businessObject);
		
		String assetSerialNo = businessObject.getString("AssetSerialNo");
		String objectType=businessObject.getString("ObjectType");   //jbo.guaranty.GUARANTY_RELATIVE
		String objectNo=businessObject.getString("ObjectNo"); 
		String Flag=businessObject.getString("Flag");  
		
		String tableName = "guaranty_relative";
		if("jbo.guaranty.GUARANTY_RELATIVE_CHANGE".equals(objectType))
			tableName = "guaranty_relative_change";
		
		//���ع�������
		BusinessObject ai = this.bomanager.keyLoadBusinessObject("jbo.app.ASSET_INFO", assetSerialNo);
		BusinessObject gr = this.bomanager.keyLoadBusinessObject(objectType, objectNo);
		
		this.bomanager.updateBusinessObject(businessObject);
		this.bomanager.updateDB();
		
		
		//��ѺƷϵͳ��Ų�Ϊ��ʱ�����ñ���Ȩ֤��Ϣ�ӿ�
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.app.ASSET_INFO");
		bomanager.getTx().join(table);

		BizObjectQuery q = table.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", assetSerialNo);
		BizObject pr = q.getSingleResult(false);
		String  ClrSerialNo = "";
		if(pr!=null)
		{
			ClrSerialNo = pr.getAttribute("CLRSERIALNO").getString();
			if(!StringX.isEmpty(ClrSerialNo)){
				//����Ȩ֤��Ϣ�ӿ�
				String WrntId="";
				/*
				OCITransaction oci = ClrInstance.WrntInfoSave(businessObject.getObjectNo(),tableName,this.bomanager.getTx().getConnection(this.bomanager.getBizObjectManager(businessObject.getObjectType())));
				String ReptFlag = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("ReptFlag");
				if("01".equals(ReptFlag)){
					WrntId = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("WrntId");
				}else if("02".equals(ReptFlag)){
					List<Message> imessage = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldByTag("ReptWrntInfo").getFieldArrayValue();
					if(imessage != null)
					{
						for(int i = 0; i < imessage.size() ; i ++){
							Message message = imessage.get(i);
							WrntId = message.getFieldValue("ReptWrntId");
						}
					}
				}
				*/
				//��ȡ����ѺƷϵͳȨ֤��Ž��и�ֵ
				businessObject.setAttributeValue("CMISSERIALNO", WrntId);
				this.bomanager.updateBusinessObject(businessObject);
				this.bomanager.updateDB();
			}
		}

		//�������Ѻ�Ǽ���Ϣ
		/*String CltlRgstNo="";
		try{
		OCITransaction oci = ClrInstance. CltlRgstInfoSave(gcSerialno,this.bomanager.getTx().getConnection(this.bomanager.getBizObjectManager(gr.getObjectType())));
		CltlRgstNo = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("CltlRgstNo");
		}catch(Exception ex)
		{
			ex.printStackTrace();
			ARE.getLog().error("GUARANTY_RElATIVE"+gr+"_save_error.");
			//��ʱ���׳��쳣
		}
				
		gr.setAttributeValue("CMISSERIALNO", CltlRgstNo);
		this.bomanager.updateBusinessObject(gr);
		this.bomanager.updateDB();*/
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(businessObject);
		return result;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		return null;
	}
	

	@Override
	public int delete(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {
		String WrntId = businessObject.getString("CMISSERIALNO");
		String SerialNo = businessObject.getString("SERIALNO");
		if(!StringX.isEmpty(WrntId)){
			//Ȩ֤��Ϣɾ��
			try{
				//OCITransaction oci = ClrInstance.WrntInfoDel(WrntId,this.bomanager.getTx().getConnection(this.bomanager.getBizObjectManager(businessObject.getObjectType())));
			}catch(Exception ex)
			{
				ex.addSuppressed(new Exception("ASSET_RIGHT_CERTIFICATE_"+businessObject.getKeyString()+"_delete_error."));
				throw ex;
			}
			
			//�������ͬ��Ȩ֤��Ϣ���������Ȩ֤ɾ��
			BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.app.ASSET_RIGHT_CERTIFICATE");
			this.bomanager.getTx().join(bom);
			BizObjectQuery arc = bom.createQuery("CmisSerialNo=:CmisSerialNo and SerialNo <>:SerialNo").setParameter("CmisSerialNo", WrntId).setParameter("SerialNo", SerialNo);
			List<BizObject> DataList = arc.getResultList(false);
			if(DataList!=null){
				for(BizObject bo:DataList){
					String SerialNoOthers = bo.getAttribute("SerialNo").getString();
					bom.createQuery("Delete From O Where SerialNo=:SerialNoOthers").setParameter("SerialNoOthers", SerialNoOthers).executeUpdate();
				}
			}
		}
		
		this.bomanager.deleteBusinessObject(businessObject);
		this.bomanager.updateDB();

		return 1;
	}

	@Override
	public int delete(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}
}
