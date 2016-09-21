package com.amarsoft.app.als.credit.dwhandler;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.guaranty.model.GuarantyContractAction;
import com.amarsoft.are.lang.StringX;

public class CollateralRegisterProcess extends ALSBusinessProcess implements BusinessObjectOWUpdater{

	@Override
	public List<BusinessObject> update(BusinessObject guarantyRelative,
			ALSBusinessProcess businessProcess) throws Exception {
		String grStatus = guarantyRelative.getString("Status");//����Ѻ�Ǽ�״̬
		BusinessObject asset = guarantyRelative.getBusinessObject("jbo.app.ASSET_INFO");
		
		BusinessObject gc = null;
		String gcSerialNo = guarantyRelative.getString("GCSerialNo");
		String assetSerialNo = guarantyRelative.getString("AssetSerialNo");
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
		
		if("0300".equals(grStatus)){
			asset.setAttributeValue("AssetStatus", "0110");//��Ԥ��Ѻ
		}
		else if("04".equals(grStatus) || "05".equals(grStatus)){
			asset.setAttributeValue("AssetStatus", "0100");//�ѵ�Ѻ/��Ѻ
			//���ݽ׶��Ե���Ҫ���ͷŵ�����ͬ����ΪʧЧ
			if(guarantyTermType.equals("02") && guarantyPeriodFlag.equals("01")){
				if(gc != null){
					if("true".equals(GuarantyContractAction.lastCollateral(gcSerialNo, assetSerialNo, "2"))){//�Ƿ�õ�����ͬ�����һ����ɵǼǵ�ѺƷ
						gc.setAttributeValue("ContractStatus", "03");//ʧЧ
						this.bomanager.updateBusinessObject(gc);
					}
				}
			}
		}
		else if("0100".equals(grStatus) || grStatus.startsWith("02")){
			asset.setAttributeValue("AssetStatus", "0000");//δ��Ѻ/��Ѻ
		}
		else{
			asset.setAttributeValue("AssetStatus", "0900");//������
		}
		this.bomanager.updateBusinessObject(asset);
		this.bomanager.updateBusinessObject(guarantyRelative);
		this.bomanager.updateDB();
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(guarantyRelative);
		return result;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		return null;
	}
}
