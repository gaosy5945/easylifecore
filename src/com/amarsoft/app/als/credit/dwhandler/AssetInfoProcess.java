package com.amarsoft.app.als.credit.dwhandler;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.credit.apply.action.CollateralTemplate;
import com.amarsoft.app.als.credit.guaranty.guarantycontract.CeilingCmis;
import com.amarsoft.app.als.guaranty.model.CollateralInterfaceAction;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONElement;
import com.amarsoft.are.util.json.JSONEncoder;
import com.amarsoft.are.util.json.JSONObject;

/**
 * @author
 * ѺƷ��Ϣ
 */
public class AssetInfoProcess extends ALSBusinessProcess
		implements BusinessObjectOWUpdater {
	
	@Override
	public List<BusinessObject> update(BusinessObject asset,
			ALSBusinessProcess businessProcess) throws Exception {
		
		String assetSerialNo=asset.getKeyString();
		if(StringX.isEmpty(assetSerialNo)){
			asset.generateKey();
			assetSerialNo = asset.getKeyString();
		}
		boolean ifNotNew = this.ifExists(assetSerialNo, this.bomanager);   //������������

		String assetType = asset.getString("AssetType");
		CollateralTemplate ct = new CollateralTemplate();
		String jboName = ct.getJBOName(assetType);//��ȡ��ѺƷ���Ͷ�Ӧ��jbo
		if(!jboName.equals("")){
			BusinessObject bo = asset.getBusinessObject(jboName);
			String boNo = bo.getKeyString();
			if(StringX.isEmpty(boNo)){
				bo.setKey(assetSerialNo);
			}
			this.bomanager.updateBusinessObject(bo);
		}
		this.bomanager.updateBusinessObject(asset);
		
		//����ѺƷΨһ��У�������
	    String attribute4 = CeilingCmis.getAttribute4(assetType);
	    String attribute5 = CeilingCmis.getAttribute5(assetType);
	    String CoreIdntfyElmt = "";
	    String AxlryIdntfyElmt = "";
	    if (attribute4 == null){
	    	CoreIdntfyElmt = "{}";
	    }else {
	    	String[] array = attribute4.split(",");
		    JSONObject businessObject = JSONObject.createObject();
		    for(int i = 0 ; i < array.length ; i++){		        
				businessObject.appendElement(JSONElement.valueOf(array[i],asset.getString(CollateralInterfaceAction.parseElement(array[i]))));	
			}    
		    CoreIdntfyElmt = JSONEncoder.encode(businessObject);//����ʶ��Ҫ��
	    }
	    if (attribute5 == null){
	    	AxlryIdntfyElmt = "{}";
	    }else {
	    	String[] array1 = attribute5.split(",");
			JSONObject businessObject1 = JSONObject.createObject();
			for(int i = 0 ; i < array1.length ; i++){		        
				businessObject1.appendElement(JSONElement.valueOf(array1[i],asset.getString(CollateralInterfaceAction.parseElement(array1[i]))));		
			}
			AxlryIdntfyElmt = JSONEncoder.encode(businessObject1);//����ʶ��Ҫ��
		}    
	   
		String NeedSaveFlag = "1";
		String ReptCfrmFlag = "0";//�˹�ȷ�ϱ�־
		String InputUserId = "";
		String InputInstId = "";
		
		this.bomanager.updateDB();
		
		//����ѺƷ����ӿ�
		//OCITransaction ociRlEstCltlDataSave = ClrInstance.ClrDataSave(assetSerialNo,assetType,this.bomanager.getTx().getConnection(this.bomanager.getBizObjectManager(asset.getObjectType())));
		String clrserialno = "";//ociRlEstCltlDataSave.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("MrtgPlgCltlNo");
		String ChkRsltFlag = "";//ociRlEstCltlDataSave.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("ChkRsltFlag");
		if(ChkRsltFlag.equals("02")){
			throw new Exception("ѺƷ����Ҫ����ѺƷϵͳ����ѺƷ��ͬ�����޸ĺ���Ҫ�ء�");
		}
		
		asset.setAttributeValue("CLRSerialNo", clrserialno);
		this.bomanager.updateBusinessObject(asset);
		
		String gcSerialNo = asset.getString("GCSerialNo");
		if(StringX.isEmpty(gcSerialNo)) gcSerialNo = "";
		this.guarantorToOwner(assetSerialNo, gcSerialNo);
		
		this.bomanager.updateDB();
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(asset);
        return result;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		for(BusinessObject businessObject:businessObjectList){
			this.update(businessObject, businessProcess);
		}
		for(BusinessObject businessObject1:businessObjectList){
			this.update(businessObject1, businessProcess);
		}
		return businessObjectList;
	}
	
	//�жϸ�ѺƷ�������Ļ�������
	public boolean ifExists(String serialNo,BusinessObjectManager bom) throws Exception{
		BusinessObject bo = bom.keyLoadBusinessObject("jbo.app.ASSET_INFO", serialNo);
		if(bo == null) return false;
		else return true;
	}
	
	//Ĭ�ϰѵ����˲���ASSET_OWNER
	public void guarantorToOwner(String assetSerialNo,String gcSerialNo) throws Exception {
		String guarantorName = "";
		BusinessObject assetOwner = BusinessObject.createBusinessObject("jbo.app.ASSET_OWNER");
		BusinessObject ai = this.bomanager.keyLoadBusinessObject("jbo.app.ASSET_INFO", assetSerialNo);
		String clrserialno = ai.getString("CLRSERIALNO");
		
		if(!StringX.isEmpty(assetSerialNo) && !StringX.isEmpty(gcSerialNo)){
			BusinessObject gc = this.bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", gcSerialNo);
			/**
			 * ��Ϊ��������ͬ���ʱ��������guaranty_contract_change�����Դ˴��жϣ���gcΪ��ʱ��ȡgcc
			 * add by bhxiao
			 * */
			if(gc==null)gc=this.bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT_CHANGE", gcSerialNo);
			
			String guarantorID = gc.getString("GuarantorID");
			guarantorName = gc.getString("GuarantorName");
			if(!StringX.isEmpty(guarantorID)){
				//�Ȳ�õ������Ƿ��Ѿ���Ȩ����
				List<BusinessObject> ownerList = this.bomanager.loadBusinessObjects("jbo.app.ASSET_OWNER", "AssetSerialNo=:AssetSerialNo and CustomerID=:GuarantorID", "AssetSerialNo",assetSerialNo,"GuarantorID",guarantorID);
				if(ownerList==null || (ownerList!=null && ownerList.size()==0)){
					BusinessObject ci = this.bomanager.keyLoadBusinessObject("jbo.customer.CUSTOMER_INFO", guarantorID);
					if(ci == null) return;
					String certType = ci.getString("CertType");
					String certID = ci.getString("CertID");
					String customerType = ci.getString("CustomerType");
					if(StringX.isEmpty(certType)) certType = "";
					if(StringX.isEmpty(certID)) certID = "";
					if(StringX.isEmpty(customerType)) customerType = "";
					
					//������Ĭ�ϴ�������Ȩ��
					assetOwner = BusinessObject.createBusinessObject("jbo.app.ASSET_OWNER");
					assetOwner.setAttributeValue("AssetSerialNo", assetSerialNo);
					assetOwner.setAttributeValue("CustomerID", guarantorID);
					assetOwner.setAttributeValue("CustomerName", guarantorName);
					assetOwner.setAttributeValue("OwnerCertType", certType);
					assetOwner.setAttributeValue("OwnerCertID", certID);
					assetOwner.setAttributeValue("OwningPercent", 1.0d);
					assetOwner.setAttributeValue("InputDate", DateHelper.getBusinessDate());
					if(customerType.startsWith("03"))
						assetOwner.setAttributeValue("OwnerType", "06");
					if(customerType.startsWith("01"))
						assetOwner.setAttributeValue("OwnerType", "01");
					assetOwner.generateKey();
					this.bomanager.updateBusinessObject(assetOwner);
					this.bomanager.updateDB();
					
					//����Ȩ������Ϣ�ӿ�
					String OwnerSerialno = assetOwner.getString("SERIALNO");
					String OwnerNo = "";
					try{
						//OCITransaction oci = ClrInstance.RtOwnerInfoSave(OwnerSerialno,this.bomanager.getTx().getConnection(this.bomanager.getBizObjectManager(assetOwner.getObjectType())));
						//OwnerNo = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("OwnerNo");
					}catch(Exception ex)
					{
						ex.printStackTrace();
						ARE.getLog().error("ASSET_OWNER_"+assetOwner.getKeyString()+"_save_error.");
						//��ʱ���׳��쳣
						throw ex;
					}
					assetOwner.setAttributeValue("CMISSERIALNO", OwnerNo);
					this.bomanager.updateBusinessObject(assetOwner);
					this.bomanager.updateDB();
				}
			}
		}
		
	}

}