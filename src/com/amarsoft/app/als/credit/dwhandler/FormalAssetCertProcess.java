package com.amarsoft.app.als.credit.dwhandler;

import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.guaranty.model.GuarantyContractAction;
import com.amarsoft.are.lang.StringX;

/**
 * @author t-zhangq2
 *	����Ѻ�Ǽ�Ȩ֤��������ʽ��Ѻ�Ǽ�֤����
 *  ����ʱ����¼��������µ���Ѻ�Ǽǵ�״̬GUARANTY_RELATIVE.STATUS
 */
public class FormalAssetCertProcess extends ALSBusinessProcess implements BusinessObjectOWUpdater{

	@Override
	public List<BusinessObject> update(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {
		businessObject.generateKey();
		this.bomanager.updateBusinessObject(businessObject);
		
		String certType = businessObject.getString("CertType");
		String collDate = businessObject.getString("CollectDate");
		String objectType=businessObject.getString("ObjectType");   //jbo.guaranty.GUARANTY_RELATIVE
		String objectNo=businessObject.getString("ObjectNo");  
	
		//���ع�������
		BusinessObject gr = this.bomanager.keyLoadBusinessObject(objectType, objectNo);
		String assetSerialNo = businessObject.getString("AssetSerialNo");
		BusinessObject ai = this.bomanager.keyLoadBusinessObject("jbo.app.ASSET_INFO", assetSerialNo);
		if(ai==null) return null;
		String assetType = ai.getString("AssetType");
		String houseStatus = "";
		
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
		
		if(assetType.startsWith("20100")){//���ز�
			houseStatus = this.bomanager.keyLoadBusinessObject("jbo.guaranty.ASSET_REALTY", assetSerialNo).getString("HouseStatus");//01�ַ� 02Ԥ��
		}
		
		/*if("020502".equals(certType)){//��Ȩ֤
			if(!StringX.isEmpty(collDate)){
				gr.setAttributeValue("Status", "05");   //CodeNo:GuarantyStatus  05:��ʽ��Ѻ�Ѱ���
				ai.setAttributeValue("AssetStatus", "0100");//�ѵ�Ѻ
				//���ݽ׶��Ե���Ҫ���ͷŵ�����ͬ����ΪʧЧ
				if(guarantyTermType.equals("02") && guarantyPeriodFlag.equals("02")){
					if(gc != null){
						if("true".equals(GuarantyContractAction.lastCollateral(gcSerialNo, assetSerialNo, "2"))){//�Ƿ�õ�����ͬ�����һ����ɵǼǵ�ѺƷ
							gc.setAttributeValue("ContractStatus", "03");//ʧЧ
							this.bomanager.updateBusinessObject(gc);
						}
					}
				}
				this.bomanager.updateBusinessObject(ai);
			}
		}*/
			
		this.bomanager.updateBusinessObject(gr);
		return null;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
}
