package com.amarsoft.app.als.credit.dwhandler;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.guaranty.model.GuarantyContractAction;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;

/**
 * @author t-zhangq2
 *	����Ѻ�Ǽ�Ȩ֤������Ԥ��Ǽ�֤��Ԥ��Ѻ��ִ��Ԥ��Ѻ�Ǽ���Ϣ����ʽ��Ѻ��ִ������������ʽ��Ѻ�Ǽ���Ϣ���б�
 *  ����ʱ����¼��������µ���Ѻ�Ǽǵ�״̬GUARANTY_RELATIVE.STATUS
 */
public class AssetCertProcess extends ALSBusinessProcess implements BusinessObjectOWUpdater{

	@Override
	public List<BusinessObject> update(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {
		businessObject.generateKey();
		this.bomanager.updateBusinessObject(businessObject);
		
		String assetSerialNo = businessObject.getString("AssetSerialNo");
		String certType = businessObject.getString("CertType");
		String reckonCollDate = businessObject.getString("ReckonCollectDate");  //������ȡ����
		String collDate = businessObject.getString("CollectDate");
		String objectType=businessObject.getString("ObjectType");   //jbo.guaranty.GUARANTY_RELATIVE
		String objectNo=businessObject.getString("ObjectNo");  
		String certNo=businessObject.getString("CertNo");
		
		//���ع�������
		BusinessObject ai = this.bomanager.keyLoadBusinessObject("jbo.app.ASSET_INFO", assetSerialNo);
		BusinessObject gr = this.bomanager.keyLoadBusinessObject(objectType, objectNo);
		BusinessObject gc = null;
		String gcSerialNo = gr.getString("GCSerialNo");
		String guarantyTermType = "",guarantyPeriodFlag = "";
		if(!StringX.isEmpty(gcSerialNo)){
			gc = this.bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", gcSerialNo);
			if(gc != null){
				guarantyTermType = gc.getString("GuarantyTermType");//01ȫ�̵���,02�׶��Ե���
				if(StringX.isEmpty(guarantyTermType)) guarantyTermType = "";
				guarantyPeriodFlag = gc.getString("GuarantyPeriodFlag");//01����ʽ��Ѻ,02����
				if(StringX.isEmpty(guarantyPeriodFlag)) guarantyPeriodFlag = "";
			}
		}
		String clrSerialno = ai.getString("CLRSERIALNO");
		String assetType = ai.getString("AssetType");
		String guarantyStatus = gr.getString("Status");
			
		/*if(assetType.startsWith("20100")){//CodeNo:AssetType  20100:���ز�    ���ز�����Ԥ��Ѻ
			String houseStatus = this.bomanager.keyLoadBusinessObject("jbo.guaranty.ASSET_REALTY", assetSerialNo).getString("HouseStatus");//01�ַ� 02Ԥ��
			if("0101".equals(certType) || "0102".equals(certType)){//����Ԥ��Ǽ�֤��Ԥ��Ѻ��ִ
				if(!StringX.isEmpty(reckonCollDate) || !StringX.isEmpty(collDate)){
					gr.setAttributeValue("Status", "0210");   //CodeNo:GuarantyStatus  0210:Ԥ��Ѻ����Ѻ��������
				}
			}
			if("0103".equals(certType)){//Ԥ��Ѻ�Ǽ���Ϣ
				if(!StringX.isEmpty(collDate)){
					gr.setAttributeValue("Status", "0300");   //CodeNo:GuarantyStatus  0300:Ԥ��Ѻ����Ѻ�����
					//���ݽ׶��Ե���Ҫ���ͷŵ�����ͬ����ΪʧЧ
					if(guarantyTermType.equals("02") && guarantyPeriodFlag.equals("01")){
						if(gc != null){
							if("true".equals(GuarantyContractAction.lastCollateral(gcSerialNo, assetSerialNo, "1"))){//�Ƿ�õ�����ͬ�����һ����ɵǼǵ�ѺƷ
								gc.setAttributeValue("ContractStatus", "03");//ʧЧ
								this.bomanager.updateBusinessObject(gc);
							}
						}
					}
				}
			}
			if("0204".equals(certType)){//��ʽ��Ѻ��ִ
				if(!StringX.isEmpty(reckonCollDate) || !StringX.isEmpty(collDate)){
					gr.setAttributeValue("Status", "0220");		//CodeNo:GuarantyStatus  0220:��ʽ��Ѻ������
					//���ݽ׶��Ե���Ҫ���ͷŵ�����ͬ����ΪʧЧ
					if(guarantyTermType.equals("02") && guarantyPeriodFlag.equals("01")){
						if(gc != null){
							if("true".equals(GuarantyContractAction.lastCollateral(gcSerialNo, assetSerialNo, "1"))){//�Ƿ�õ�����ͬ�����һ����ɵǼǵ�ѺƷ
								gc.setAttributeValue("ContractStatus", "03");//ʧЧ
								this.bomanager.updateBusinessObject(gc);
							}
						}
					}
				}
			}
		}
		else{//�Ƿ��ز�
			if("0204".equals(certType)){//��ʽ��Ѻ��ִ
				if(!StringX.isEmpty(reckonCollDate) || !StringX.isEmpty(collDate)){
					gr.setAttributeValue("Status", "0220");   //CodeNo:GuarantyStatus  0220:��ʽ��Ѻ����Ѻ��������
					//���ݽ׶��Ե���Ҫ���ͷŵ�����ͬ����ΪʧЧ
					if(guarantyTermType.equals("02") && guarantyPeriodFlag.equals("01")){
						if(gc != null){
							if("true".equals(GuarantyContractAction.lastCollateral(gcSerialNo, assetSerialNo, "1"))){//�Ƿ�õ�����ͬ�����һ����ɵǼǵ�ѺƷ
								gc.setAttributeValue("ContractStatus", "03");//ʧЧ
								this.bomanager.updateBusinessObject(gc);
							}
						}
					}
				}
			}
		}
		
		this.bomanager.updateBusinessObject(gr);*/
		
		String WrntNo = businessObject.getString("CERTNO");
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(businessObject);
		
		this.bomanager.updateBusinessObject(businessObject);
		this.bomanager.updateDB();
		String tableName = "";
		//����Ȩ֤��Ϣ�ӿ�
		String WrntId="";
		try{
			//OCITransaction oci = ClrInstance.WrntInfoSave(clrSerialno,tableName,this.bomanager.getTx().getConnection(this.bomanager.getBizObjectManager(businessObject.getObjectType())));
			//WrntId = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("WrntId");
		}catch(Exception ex)
		{
			ex.printStackTrace();
			ARE.getLog().error("ASSET_RIGHT_CERTIFICATE_"+assetSerialNo+"_save_error.");
			throw ex;
		}
		
		businessObject.setAttributeValue("CMISSERIALNO", WrntId);
		this.bomanager.updateBusinessObject(businessObject);
		this.bomanager.updateDB();
		

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
	
		return result;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		return null;
	}
}
