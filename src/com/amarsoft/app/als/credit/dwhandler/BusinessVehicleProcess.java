package com.amarsoft.app.als.credit.dwhandler;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWDeleter;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;
import com.amarsoft.app.als.credit.guaranty.guarantycontract.GetGCContractNo;
import com.amarsoft.awe.util.DBKeyHelp;

/**
 * @author
 * 汽车贷款附属信息
 */
public class BusinessVehicleProcess extends ALSBusinessProcess implements BusinessObjectOWDeleter,BusinessObjectOWUpdater {

public List<BusinessObject> update(BusinessObject businessTrade, ALSBusinessProcess businessProcess) throws Exception {
		
		BusinessObject assetInfo = businessTrade.getBusinessObject("jbo.app.ASSET_INFO");
		assetInfo.setAttributeValue("AssetType",businessTrade.getString("AssetType"));
		assetInfo.setAttributeValue("AssetName",businessTrade.getString("ContractName"));
		assetInfo.setAttributeValue("AssetStatus", "0000");//未抵押
		assetInfo.setAttributeValue("PurchaseValue", businessTrade.getString("ContractAmount"));
		assetInfo.setAttributeValue("InputDate",DateHelper.getBusinessDate());
		assetInfo.generateKey();
		String assetSerialNo = assetInfo.getKeyString();
		this.bomanager.updateBusinessObject(assetInfo);
		
		BusinessObject assetRealty = businessTrade.getBusinessObject("jbo.guaranty.ASSET_OTHERS_EQUIPMENT");
		assetRealty.setAttributeValue("CIF", businessTrade.getString("ContractAmount"));//购买总价
		assetRealty.setAttributeValue("Origin", businessTrade.getString("Origin"));//产地
		assetRealty.setKey(assetSerialNo);
		this.bomanager.updateBusinessObject(assetRealty);
		
		
		//是否以此标的为抵押，自动生成、删除抵押**************Start****************
		//先判断编号为assetSerialNo的押品是否已经被引为抵押担保
		boolean existFlag = false;
		String gcNo = "";
		List<BusinessObject> grList0 = bomanager.loadBusinessObjects("jbo.guaranty.GUARANTY_RELATIVE", "AssetSerialNo=:AssetSerialNo"
				, "AssetSerialNo",assetSerialNo);
		if(grList0 == null || (grList0!=null && grList0.size()==0)) existFlag = false;
		for(BusinessObject grbo:grList0){
			String gcSerialNo = grbo.getString("GCSerialNo");
			List<BusinessObject> arList0= bomanager.loadBusinessObjects("jbo.app.APPLY_RELATIVE", "ApplySerialNo=:ApplySerialNo "
					+ "and ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and ObjectNo=:ObjectNo and RelativeType='05' ", "ApplySerialNo",businessTrade.getString("ObjectNo"),"ObjectNo",gcSerialNo);
			if(arList0 == null || (arList0!=null && arList0.size()==0)) continue;
			existFlag = true;
			gcNo = gcSerialNo;
		}
		String isCollateral = businessTrade.getString("IsCollateral");
		
		
		if(!existFlag && "1".equals(isCollateral)){//此资产未被引为担保且需要引入为押品时才新建
			BusinessObject apply = bomanager.keyLoadBusinessObject(businessTrade.getString("ObjectType"), businessTrade.getString("ObjectNo"));
			String customerID = apply.getString("CustomerID");
			String customerName = apply.getString("CustomerName");
			String artificialNo = apply.getString("ContractArtificialNo");
			String orgID = apply.getString("InputOrgID");
			String userID = apply.getString("InputUserID");
			double businessSum = apply.getDouble("BusinessSum");
			
			BusinessObject gc = BusinessObject.createBusinessObject("jbo.guaranty.GUARANTY_CONTRACT");
			gc.setAttributeValue("ContractType", "010");//一般担保
			gc.setAttributeValue("GuarantyType", "02060");
			gc.setAttributeValue("ContractStatus", "01");//待生效
			gc.setAttributeValue("GuarantyValue", businessSum);
			gc.setAttributeValue("GuarantorID", customerID);
			gc.setAttributeValue("GuarantorName", customerName);
			gc.setAttributeValue("ContractNo", GetGCContractNo.getGCContractNo(artificialNo));
			gc.setAttributeValue("InputDate", DateHelper.getBusinessDate());
			gc.setAttributeValue("GuaranteeType", "3");
			gc.setAttributeValue("InputOrgID", orgID);
			gc.setAttributeValue("InputUserID", userID);
			gc.generateKey();
			this.bomanager.updateBusinessObject(gc);
			
			BusinessObject gr = BusinessObject.createBusinessObject("jbo.guaranty.GUARANTY_RELATIVE");
			gr.setAttributeValue("GCSerialNo", gc.getKeyString());
			gr.setAttributeValue("AssetSerialNo", assetSerialNo);
			//gr.setAttributeValue("GuarantyAmount", businessTrade.getDouble("ContractAmount"));
			//gr.setAttributeValue("GuarantyPercent", 1.0);
			gr.setAttributeValue("Currency", "CNY");
			gr.generateKey();
			this.bomanager.updateBusinessObject(gr);
			
			BusinessObject ar = BusinessObject.createBusinessObject("jbo.app.APPLY_RELATIVE");
			ar.setAttributeValue("ApplySerialNo", businessTrade.getString("ObjectNo"));
			ar.setAttributeValue("ObjectNo", gc.getKeyString());
			ar.setAttributeValue("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT");
			ar.setAttributeValue("RelativeType", "05");
			ar.generateKey();
			this.bomanager.updateBusinessObject(ar);
		}
		else if((!existFlag && "0".equals(isCollateral)) || (existFlag && "1".equals(isCollateral))){
			//do nothing
		}
		else if(existFlag && "0".equals(isCollateral)){//此资产已经被引为业务的押品，且现不需要设为押品，则删除
			List<BusinessObject> grList = bomanager.loadBusinessObjects("jbo.guaranty.GUARANTY_RELATIVE", "AssetSerialNo=:AssetSerialNo and GCSerialNo=:GCSerialNo"
					, "AssetSerialNo",assetSerialNo,"GCSerialNo",gcNo);
			List<BusinessObject> arList= bomanager.loadBusinessObjects("jbo.app.APPLY_RELATIVE", "ApplySerialNo=:ApplySerialNo "
					+ "and ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and ObjectNo=:ObjectNo and RelativeType='05' ", "ApplySerialNo",businessTrade.getString("ObjectNo"),"ObjectNo",gcNo);
			this.bomanager.deleteBusinessObjects(grList);
			//this.bomanager.deleteBusinessObjects(arList);
			//GC也不删，因为可能该担保合同下已录入了别的押品
		}
		else{}
		//自动生成、删除抵押**************End****************
		
		businessTrade.setAttributeValue("AssetSerialNo", assetSerialNo);
		businessTrade.generateKey();
		this.bomanager.updateBusinessObject(businessTrade);
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(businessTrade);
		return result;
	}
	
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public int delete(BusinessObject businessTrade, ALSBusinessProcess businessProcess) throws Exception {
		BusinessObject assetInfo = businessTrade.getBusinessObject("jbo.app.ASSET_INFO");
		BusinessObject assetVehicle = businessTrade.getBusinessObject("jbo.guaranty.ASSET_OTHERS_EQUIPMENT");
		this.bomanager.deleteBusinessObject(assetVehicle);
		this.bomanager.deleteBusinessObject(assetInfo);
		this.bomanager.deleteBusinessObject(businessTrade);
	
		return 1;
	}
	
	@Override
	public int delete(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		
		return 1;
	}

}
