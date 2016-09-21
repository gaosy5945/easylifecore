package com.amarsoft.app.als.cl.BusinessProcess;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;

/**
 * @author
 * 额度信息保存
 */
public class CreditLineInfo extends ALSBusinessProcess implements BusinessObjectOWUpdater{
	
	public List<BusinessObject> update(BusinessObject businessApply, ALSBusinessProcess businessProcess) throws Exception {
		businessApply.generateKey();
		this.bomanager.updateBusinessObject(businessApply);
		
		String businessType = businessApply.getString("BusinessType");
		
		String clType = "";
		if("555".equals(businessType) || "999".equals(businessType))//消费授信额度
		{
			clType = "0101";
		}else if("500".equals(businessType)) //融资易刷卡额度
		{
			clType = "0104";
		}else if("502".equals(businessType)) //融资易转账额度
		{
			clType = "0103";
		}
		else if("666".equals(businessType) || "888".equals(businessType))//消贷易额度
		{
			clType = "0102";
		}
		
		BusinessObject clInfo = businessApply.getBusinessObject("jbo.cl.CL_INFO");
		clInfo.generateKey();
		clInfo.setAttributeValue("ObjectType",businessApply.getBizClassName());
		clInfo.setAttributeValue("ObjectNo",businessApply.getKeyString());
		clInfo.setAttributeValue("BUSINESSAPPAMT", businessApply.getDouble("BusinessSum"));
		clInfo.setAttributeValue("BUSINESSAVAAMT", businessApply.getDouble("BusinessSum"));
		clInfo.setAttributeValue("CLTYPE", clType);//额度类型默认 消费额度
		clInfo.setAttributeValue("Status", "10");
		clInfo.setAttributeValue("CLTERMDAY", businessApply.getInt("BusinessTermDay"));
		clInfo.setAttributeValue("CLTERM", businessApply.getInt("BusinessTerm"));
		clInfo.setAttributeValue("CLTERMUNIT", businessApply.getString("BusinessTermUnit"));
		clInfo.setAttributeValue("MATURITYDATE", businessApply.getString("MATURITYDATE"));
		clInfo.setAttributeValue("CURRENCY", businessApply.getString("BusinessCurrency"));
		clInfo.setAttributeValue("CLUSETYPE", "01");//额度使用方式 自用
		clInfo.setAttributeValue("CLCONTRACTNO", businessApply.getString("contractartificialno"));//授信合同编号
		clInfo.setAttributeValue("REVOLVINGFLAG", businessApply.getString("RevolveFlag"));
		clInfo.setAttributeValue("INPUTORGID", businessApply.getString("OPERATEORGID"));//初始化额度的录入机构
		
		this.bomanager.updateBusinessObject(clInfo);
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(businessApply);
		return result;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

}