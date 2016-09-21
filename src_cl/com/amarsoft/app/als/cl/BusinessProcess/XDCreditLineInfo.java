package com.amarsoft.app.als.cl.BusinessProcess;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.util.ASValuePool;

/**
 * @author
 * 额度信息保存
 */
public class XDCreditLineInfo extends ALSBusinessProcess implements BusinessObjectOWUpdater{
	
	public List<BusinessObject> update(BusinessObject ba, ALSBusinessProcess businessProcess) throws Exception {
		ba.generateKey();
		this.bomanager.updateBusinessObject(ba);
		
		String objecttype = ba.getBizClassName();
		String objectno = ba.getKeyString();
		String rateTermID = ba.getString("LoanRateTermID");
		String rptTermID = ba.getString("RPTTermID");
		
		//先清空原先保存的还款信息，利率信息
		//1、删除还款信息
		/*String selectRPTSql = " objectno=:ObjectNo and objecttype=:ObjectType and rpttermid<>:RPTTermID ";*/
		String selectRPTSql = " objectno=:ObjectNo and objecttype=:ObjectType and termid<>:RPTTermID ";
		List<BusinessObject> rptList = this.bomanager.loadBusinessObjects("jbo.acct.ACCT_RPT_SEGMENT", selectRPTSql, "ObjectNo", objectno,"ObjectType", objecttype,"RPTTermID", rptTermID);
		for(BusinessObject o:rptList){
			this.bomanager.deleteBusinessObject(o);
		}
		
		//2、删除利率
		/*String selectRateSql = " objectno=:ObjectNo and objecttype=:ObjectType and ratetermid<>:RaTeTermID and ratetype='01' ";*/
		String selectRateSql = " objectno=:ObjectNo and objecttype=:ObjectType and termid<>:RaTeTermID and ratetype='01' ";
		List<BusinessObject> rateList = this.bomanager.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", selectRateSql, "ObjectNo", objectno,"ObjectType", objecttype,"RaTeTermID", rateTermID);
		for(BusinessObject o:rateList){
			this.bomanager.deleteBusinessObject(o);
		}
		
		String businessType = ba.getString("BusinessType");
		
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
		
		BusinessObject clInfo = ba.getBusinessObject("jbo.cl.CL_INFO");
		clInfo.setAttributeValue("ObjectType",ba.getBizClassName());
		clInfo.setAttributeValue("ObjectNo",ba.getKeyString());
		clInfo.setAttributeValue("BUSINESSAPPAMT", ba.getDouble("BusinessSum"));
		clInfo.setAttributeValue("BUSINESSAVAAMT", ba.getDouble("BusinessSum"));
		clInfo.setAttributeValue("CLTYPE", clType);//额度类型默认 消费额度
		clInfo.setAttributeValue("CURRENCY", ba.getString("BusinessCurrency"));
		clInfo.setAttributeValue("CLUSETYPE", "01");//额度使用方式 自用
		clInfo.setAttributeValue("CLCONTRACTNO", ba.getString("contractartificialno"));//授信合同编号
		clInfo.setAttributeValue("REVOLVINGFLAG", ba.getString("RevolveFlag"));
		clInfo.setAttributeValue("FINALDRAWDOWNDATE", clInfo.getString("MATURITYDATE"));//最晚提款日期
		clInfo.generateKey();
		this.bomanager.updateBusinessObject(clInfo);
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(ba);
		return result;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
}