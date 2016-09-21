package com.amarsoft.app.als.credit.contract.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

/**
 * @author t-zhangq2
 * 台账中业务附属信息若不存在，则不显示tab
 */
public class ContractSubsidiaryAction {
	
	//判断购房信息是否存在
	public static String houseExists(String objectType,String objectNo) throws Exception{
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		String sql = "Select * from BUSINESS_TRADE O,ASSET_INFO AI,ASSET_REALTY AR where "
				+ "O.ObjectType='"+objectType+"' and O.ObjectNo='"+objectNo+"' and O.AssetSerialNo"
				+ " = AI.SerialNo and O.AssetSerialNo = AR.AssetSerialNo";
		List<BusinessObject> tradeList = bom.loadBusinessObjects_SQL(sql, BusinessObject.createBusinessObject());
		if(tradeList != null && tradeList.size() > 0)
			return "";
		return "hide";
	}
	
	//判断购车信息是否存在
	public static String vehicleExists(String objectType,String objectNo) throws Exception{
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		String sql = "Select * from BUSINESS_TRADE O,ASSET_INFO AI,ASSET_OTHERS_EQUIPMENT AOE where "
				+ "O.ObjectType='"+objectType+"' and O.ObjectNo='"+objectNo+"' and O.AssetSerialNo"
				+ " = AI.SerialNo and O.AssetSerialNo = AOE.AssetSerialNo and O.AssetType like '40500100%'";
		List<BusinessObject> tradeList = bom.loadBusinessObjects_SQL(sql, BusinessObject.createBusinessObject());
		if(tradeList != null && tradeList.size() > 0)
			return "";
		return "hide";
	}
		
	//判断经营实体信息是否存在
	public static String indEnterpriseExists(String objectType,String objectNo) throws Exception{
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		String sql = "Select * from BUSINESS_INVEST O where O.ObjectType='"+objectType+"' and O.ObjectNo='"+objectNo+"'";
		List<BusinessObject> tradeList = bom.loadBusinessObjects_SQL(sql, BusinessObject.createBusinessObject());
		if(tradeList != null && tradeList.size() > 0)
			return "";
		return "hide";
	}
		
	//判断消费品信息是否存在
	public static String consumeExists(String objectType,String objectNo) throws Exception{
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		String sql = "Select * from BUSINESS_TRADE O where O.ObjectType='"+objectType+"' and O.ObjectNo='"+objectNo+"'";
		List<BusinessObject> tradeList = bom.loadBusinessObjects_SQL(sql, BusinessObject.createBusinessObject());
		if(tradeList != null && tradeList.size() > 0)
			return "";
		return "hide";
	}
		
	//判断助学贷款信息是否存在
	public static String educationExists(String objectType,String objectNo) throws Exception{
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		String sql = "Select * from BUSINESS_EDUCATION O where O.ObjectType='"+objectType+"' and O.ObjectNo='"+objectNo+"'";
		List<BusinessObject> tradeList = bom.loadBusinessObjects_SQL(sql, BusinessObject.createBusinessObject());
		if(tradeList != null && tradeList.size() > 0)
			return "";
		return "hide";
	}
		
}
