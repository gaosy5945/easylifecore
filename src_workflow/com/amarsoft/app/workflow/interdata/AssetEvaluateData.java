package com.amarsoft.app.workflow.interdata;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.SystemDBConfig;
import com.amarsoft.app.als.sys.tools.SYSNameManager;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * 通过对象类型、对象编号获取对象基础信息
 * @author 
 */

public class AssetEvaluateData implements IData {


	@Override
	public List<BusinessObject> getFlowObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select * from jbo.app.ASSET_EVALUATE O,jbo.app.ASSET_INFO AI,jbo.flow.FLOW_OBJECT FO where O.AssetSerialNo = AI.SerialNo and O.SerialNo = FO.ObjectNo and "+
					 " FO.ObjectType =:ObjectType and FO.FlowSerialNo in (:FlowSerialNo) ";
		return bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", sql,"ObjectType",objectType,  parameters);
	}
	
	
	@Override
	public List<BusinessObject> getObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select * from jbo.app.ASSET_EVALUATE O,jbo.app.ASSET_INFO AI where O.AssetSerialNo = AI.SerialNo "+
					 " and O.SerialNo in (:SerialNo)"; 
		return bomanager.loadBusinessObjects("jbo.app.ASSET_EVALUATE", sql, parameters);
		
	}
	
	public void transfer(BusinessObject bo) throws Exception {
		if(bo ==  null) return;
		bo.setAttributeValue("GuaranTorName", SYSNameManager.getGuaranTorName(bo.getString("AssetSerialNo")));
		bo.setAttributeValue("PhaseActionType", "1");
		bo.setAttributeValue("EvaluateUserName", NameManager.getUserName(bo.getString("EvaluateUserID")));
		bo.setAttributeValue("EvaluateOrgName", SystemDBConfig.getOrg(bo.getString("EvaluateOrgID")).getString("OrgName"));
		//bo.setAttributeValue("EvaluateMethod", "");
	}
	
	public List<BusinessObject> group(List<BusinessObject> boList)
			throws Exception {
		if(boList == null) return boList;
		List<BusinessObject> returnList = new ArrayList<BusinessObject>();
		HashMap<String,BusinessObject> map = new HashMap<String,BusinessObject>();
		for(BusinessObject bo:boList)
		{
			String groupID = bo.getString("TaskSerialNo");
			if(groupID == null || "".equals(groupID)) groupID = bo.getString("FlowSerialNo");
			BusinessObject tempBo = map.get(groupID);
			if(tempBo == null){
				map.put(groupID, bo);
				returnList.add(bo);
			}
			else
			{
			}
		}
		
		return returnList;
	}


	public void cancel(String key, BusinessObjectManager bomanager) throws Exception {
		
		BizObjectManager bo = bomanager.getBizObjectManager("jbo.app.ASSET_EVALUATE");
		bo.createQuery("delete O from  where SerialNo=:SerialNo")
		.setParameter("SerialNo", key)
		.executeUpdate();
	}

	
	public void finish(String key, BusinessObjectManager bomanager) throws Exception {
		
		/*SqlObject so = new SqlObject("update ASSET_EVALUATE set ApproveStatus = '05' where SerialNo=:SerialNo");
		so.setParameter("SerialNo", key);
		sqlca.executeSQL(so);*/
	}
	
}
