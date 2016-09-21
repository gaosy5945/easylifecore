package com.amarsoft.app.als.credit.dwhandler;

import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.guaranty.model.GuarantyContractAction;
import com.amarsoft.are.lang.StringX;

/**
 * @author t-zhangq2
 *	抵质押登记权证（包括正式抵押登记证件）
 *  保存时根据录入情况更新抵质押登记的状态GUARANTY_RELATIVE.STATUS
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
	
		//加载关联对象
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
				guarantyTermType = gc.getString("GuarantyTermType");//01全程担保,02阶段性担保
				if(StringX.isEmpty(guarantyTermType)) guarantyTermType = "";
				guarantyPeriodFlag = gc.getString("GuarantyPeriodFlag");//01已正式抵押,02其他
				if(StringX.isEmpty(guarantyPeriodFlag)) guarantyPeriodFlag = "";
			}
		}
		
		if(assetType.startsWith("20100")){//房地产
			houseStatus = this.bomanager.keyLoadBusinessObject("jbo.guaranty.ASSET_REALTY", assetSerialNo).getString("HouseStatus");//01现房 02预售
		}
		
		/*if("020502".equals(certType)){//产权证
			if(!StringX.isEmpty(collDate)){
				gr.setAttributeValue("Status", "05");   //CodeNo:GuarantyStatus  05:正式抵押已办妥
				ai.setAttributeValue("AssetStatus", "0100");//已抵押
				//根据阶段性担保要求释放担保合同，置为失效
				if(guarantyTermType.equals("02") && guarantyPeriodFlag.equals("02")){
					if(gc != null){
						if("true".equals(GuarantyContractAction.lastCollateral(gcSerialNo, assetSerialNo, "2"))){//是否该担保合同的最后一个完成登记的押品
							gc.setAttributeValue("ContractStatus", "03");//失效
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
