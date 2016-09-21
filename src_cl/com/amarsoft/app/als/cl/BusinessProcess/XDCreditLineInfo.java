package com.amarsoft.app.als.cl.BusinessProcess;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.util.ASValuePool;

/**
 * @author
 * �����Ϣ����
 */
public class XDCreditLineInfo extends ALSBusinessProcess implements BusinessObjectOWUpdater{
	
	public List<BusinessObject> update(BusinessObject ba, ALSBusinessProcess businessProcess) throws Exception {
		ba.generateKey();
		this.bomanager.updateBusinessObject(ba);
		
		String objecttype = ba.getBizClassName();
		String objectno = ba.getKeyString();
		String rateTermID = ba.getString("LoanRateTermID");
		String rptTermID = ba.getString("RPTTermID");
		
		//�����ԭ�ȱ���Ļ�����Ϣ��������Ϣ
		//1��ɾ��������Ϣ
		/*String selectRPTSql = " objectno=:ObjectNo and objecttype=:ObjectType and rpttermid<>:RPTTermID ";*/
		String selectRPTSql = " objectno=:ObjectNo and objecttype=:ObjectType and termid<>:RPTTermID ";
		List<BusinessObject> rptList = this.bomanager.loadBusinessObjects("jbo.acct.ACCT_RPT_SEGMENT", selectRPTSql, "ObjectNo", objectno,"ObjectType", objecttype,"RPTTermID", rptTermID);
		for(BusinessObject o:rptList){
			this.bomanager.deleteBusinessObject(o);
		}
		
		//2��ɾ������
		/*String selectRateSql = " objectno=:ObjectNo and objecttype=:ObjectType and ratetermid<>:RaTeTermID and ratetype='01' ";*/
		String selectRateSql = " objectno=:ObjectNo and objecttype=:ObjectType and termid<>:RaTeTermID and ratetype='01' ";
		List<BusinessObject> rateList = this.bomanager.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", selectRateSql, "ObjectNo", objectno,"ObjectType", objecttype,"RaTeTermID", rateTermID);
		for(BusinessObject o:rateList){
			this.bomanager.deleteBusinessObject(o);
		}
		
		String businessType = ba.getString("BusinessType");
		
		String clType = "";
		if("555".equals(businessType) || "999".equals(businessType))//�������Ŷ��
		{
			clType = "0101";
		}else if("500".equals(businessType)) //������ˢ�����
		{
			clType = "0104";
		}else if("502".equals(businessType)) //������ת�˶��
		{
			clType = "0103";
		}
		else if("666".equals(businessType) || "888".equals(businessType))//�����׶��
		{
			clType = "0102";
		}
		
		BusinessObject clInfo = ba.getBusinessObject("jbo.cl.CL_INFO");
		clInfo.setAttributeValue("ObjectType",ba.getBizClassName());
		clInfo.setAttributeValue("ObjectNo",ba.getKeyString());
		clInfo.setAttributeValue("BUSINESSAPPAMT", ba.getDouble("BusinessSum"));
		clInfo.setAttributeValue("BUSINESSAVAAMT", ba.getDouble("BusinessSum"));
		clInfo.setAttributeValue("CLTYPE", clType);//�������Ĭ�� ���Ѷ��
		clInfo.setAttributeValue("CURRENCY", ba.getString("BusinessCurrency"));
		clInfo.setAttributeValue("CLUSETYPE", "01");//���ʹ�÷�ʽ ����
		clInfo.setAttributeValue("CLCONTRACTNO", ba.getString("contractartificialno"));//���ź�ͬ���
		clInfo.setAttributeValue("REVOLVINGFLAG", ba.getString("RevolveFlag"));
		clInfo.setAttributeValue("FINALDRAWDOWNDATE", clInfo.getString("MATURITYDATE"));//�����������
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