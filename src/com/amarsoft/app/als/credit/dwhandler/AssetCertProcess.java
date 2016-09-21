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
 *	抵质押登记权证（包括预告登记证、预抵押回执、预抵押登记信息、正式抵押回执），不包括正式抵押登记信息（列表）
 *  保存时根据录入情况更新抵质押登记的状态GUARANTY_RELATIVE.STATUS
 */
public class AssetCertProcess extends ALSBusinessProcess implements BusinessObjectOWUpdater{

	@Override
	public List<BusinessObject> update(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {
		businessObject.generateKey();
		this.bomanager.updateBusinessObject(businessObject);
		
		String assetSerialNo = businessObject.getString("AssetSerialNo");
		String certType = businessObject.getString("CertType");
		String reckonCollDate = businessObject.getString("ReckonCollectDate");  //估计领取日期
		String collDate = businessObject.getString("CollectDate");
		String objectType=businessObject.getString("ObjectType");   //jbo.guaranty.GUARANTY_RELATIVE
		String objectNo=businessObject.getString("ObjectNo");  
		String certNo=businessObject.getString("CertNo");
		
		//加载关联对象
		BusinessObject ai = this.bomanager.keyLoadBusinessObject("jbo.app.ASSET_INFO", assetSerialNo);
		BusinessObject gr = this.bomanager.keyLoadBusinessObject(objectType, objectNo);
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
		String clrSerialno = ai.getString("CLRSERIALNO");
		String assetType = ai.getString("AssetType");
		String guarantyStatus = gr.getString("Status");
			
		/*if(assetType.startsWith("20100")){//CodeNo:AssetType  20100:房地产    房地产才有预抵押
			String houseStatus = this.bomanager.keyLoadBusinessObject("jbo.guaranty.ASSET_REALTY", assetSerialNo).getString("HouseStatus");//01现房 02预售
			if("0101".equals(certType) || "0102".equals(certType)){//房产预告登记证，预抵押回执
				if(!StringX.isEmpty(reckonCollDate) || !StringX.isEmpty(collDate)){
					gr.setAttributeValue("Status", "0210");   //CodeNo:GuarantyStatus  0210:预抵押（质押）办理中
				}
			}
			if("0103".equals(certType)){//预抵押登记信息
				if(!StringX.isEmpty(collDate)){
					gr.setAttributeValue("Status", "0300");   //CodeNo:GuarantyStatus  0300:预抵押（质押）完成
					//根据阶段性担保要求释放担保合同，置为失效
					if(guarantyTermType.equals("02") && guarantyPeriodFlag.equals("01")){
						if(gc != null){
							if("true".equals(GuarantyContractAction.lastCollateral(gcSerialNo, assetSerialNo, "1"))){//是否该担保合同的最后一个完成登记的押品
								gc.setAttributeValue("ContractStatus", "03");//失效
								this.bomanager.updateBusinessObject(gc);
							}
						}
					}
				}
			}
			if("0204".equals(certType)){//正式抵押回执
				if(!StringX.isEmpty(reckonCollDate) || !StringX.isEmpty(collDate)){
					gr.setAttributeValue("Status", "0220");		//CodeNo:GuarantyStatus  0220:正式抵押办理中
					//根据阶段性担保要求释放担保合同，置为失效
					if(guarantyTermType.equals("02") && guarantyPeriodFlag.equals("01")){
						if(gc != null){
							if("true".equals(GuarantyContractAction.lastCollateral(gcSerialNo, assetSerialNo, "1"))){//是否该担保合同的最后一个完成登记的押品
								gc.setAttributeValue("ContractStatus", "03");//失效
								this.bomanager.updateBusinessObject(gc);
							}
						}
					}
				}
			}
		}
		else{//非房地产
			if("0204".equals(certType)){//正式抵押回执
				if(!StringX.isEmpty(reckonCollDate) || !StringX.isEmpty(collDate)){
					gr.setAttributeValue("Status", "0220");   //CodeNo:GuarantyStatus  0220:正式抵押（质押）办理中
					//根据阶段性担保要求释放担保合同，置为失效
					if(guarantyTermType.equals("02") && guarantyPeriodFlag.equals("01")){
						if(gc != null){
							if("true".equals(GuarantyContractAction.lastCollateral(gcSerialNo, assetSerialNo, "1"))){//是否该担保合同的最后一个完成登记的押品
								gc.setAttributeValue("ContractStatus", "03");//失效
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
		//保存权证信息接口
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
		

		//保存抵质押登记信息
		/*String CltlRgstNo="";
		try{
		OCITransaction oci = ClrInstance. CltlRgstInfoSave(gcSerialno,this.bomanager.getTx().getConnection(this.bomanager.getBizObjectManager(gr.getObjectType())));
		CltlRgstNo = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("CltlRgstNo");
		}catch(Exception ex)
		{
			ex.printStackTrace();
			ARE.getLog().error("GUARANTY_RElATIVE"+gr+"_save_error.");
			//暂时不抛出异常
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
