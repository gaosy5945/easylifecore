package com.amarsoft.app.accounting.trans.script.loan.ratechange;

import java.util.List;

import com.amarsoft.app.accounting.interest.rate.reprice.RepriceMethod;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.base.util.RateHelper;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

/**
 * ���ʱ��ִ��
 */
public class RATChangeExecutor extends TransactionProcedure{

	public int run() throws Exception {
		String psType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "PSType");
		String businessDate = relativeObject.getString("BusinessDate");
		List<BusinessObject> rateList = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rate_segment,
				"Status='1' and (SegToDate = null or SegToDate='' or SegToDate>:BusinessDate)" ,"BusinessDate",businessDate);
		List<BusinessObject> newRateList = documentObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rate_segment,"Status='1'");
		
		String transDate = transaction.getString("TransDate");
		
		//�����ʴ���
		for (BusinessObject rateSegment : rateList) {
			rateSegment.setAttributeValue("SegToDate", transDate);
			this.bomanager.updateBusinessObject(rateSegment);
		}
		
		//�����ʴ���
		for (BusinessObject rateSegment : newRateList) {
			// �½����󲢽��������ֵ�����¶���
			BusinessObject newRateSegment = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.loan_rate_segment);
			newRateSegment.setAttributes(rateSegment);
			newRateSegment.generateKey(true);
			newRateSegment.setAttributeValue("Status", "1");
			newRateSegment.setAttributeValue("ObjectNo", relativeObject.getKeyString());
			newRateSegment.setAttributeValue("ObjectType", relativeObject.getBizClassName());
			if(StringX.isEmpty(newRateSegment.getString("SegFromDate")))
				newRateSegment.setAttributeValue("SegFromDate", transDate);
			if(StringX.isEmpty(newRateSegment.getString("SegToDate")))
				newRateSegment.setAttributeValue("SegToDate","");
			newRateSegment.setAttributeValue("LastRepriceDate", transDate);
			
			updateBusinessRate(newRateSegment,newRateList);
			
			String defaultRepriceDate = newRateSegment.getString("DefaultRepriceDate");
			if(!StringX.isEmpty(defaultRepriceDate))
				newRateSegment.setAttributeValue("DefaultRepriceDate", DateHelper.getBusinessDate().substring(0, 4)+"/"+defaultRepriceDate);
			
			if(!StringX.isEmpty(newRateSegment.getString("RepriceType")))
			{
				//�������ʵ�����ʽ
				String nextRepriceDate = RepriceMethod.getRepriceMethod(newRateSegment.getString("RepriceType")).getNextRepriceDate(relativeObject,newRateSegment);// �´����ʵ�����
				newRateSegment.setAttributeValue("NextRepriceDate", nextRepriceDate);
			}
			
			relativeObject.appendBusinessObject(BUSINESSOBJECT_CONSTANTS.loan_rate_segment, newRateSegment);;
			bomanager.updateBusinessObject(newRateSegment);
		}
		
		//�������������ڹ��ͻ���ƻ�
		List<BusinessObject> rptList = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, "Status='1' and PSType like :PSType ","PSType",psType);
		for(BusinessObject rptSegment:rptList)
		{
			rptSegment.setAttributeValue("PSRestructureFlag", "2");
		}
		return 1;
	}
	
	private BusinessObject updateBusinessRate(BusinessObject rateSegment,List<BusinessObject> RateList) throws Exception {
		if(StringX.isEmpty(rateSegment.getString("BaseRateType"))) return rateSegment;
		String businessDate=relativeObject.getString("BusinessDate");
		double newBaseRate = 0.0d;
		if(RateHelper.exists(rateSegment.getString("BaseRateType"), relativeObject.getString("Currency"), businessDate))//����޻�׼���ʣ������������������ȡ��
		{
			newBaseRate = RateHelper.getBaseRate(relativeObject, rateSegment);
		}else{
			int cnt = 0;
			for(BusinessObject parentRateSegment:RateList)
			{
				if(parentRateSegment.getString("RateType").equals(rateSegment.getString("BaseRateType")))
				{
					cnt ++;
					BusinessObject parent = updateBusinessRate(parentRateSegment,RateList);
					rateSegment.setAttributeValue("RateUnit", parent.getString("RateUnit"));
					rateSegment.setAttributeValue("BaseRateGrade", parent.getString("BaseRateGrade"));
					rateSegment.setAttributeValue("RepriceType", parent.getString("RepriceType"));
					rateSegment.setAttributeValue("RepriceTermUnit", parent.getString("RepriceTermUnit"));
					rateSegment.setAttributeValue("RepriceTerm", parent.getString("RepriceTerm"));
					rateSegment.setAttributeValue("DefaultRepriceDate", parent.getString("DefaultRepriceDate"));
					
					newBaseRate = parent.getDouble("BusinessRate");
					break;
				}
			}
			
			if(cnt > 1) throw new ALSException("ED2016",rateSegment.getString("BaseRateType"));
			if(cnt <= 0) throw new ALSException("ED2017",rateSegment.getString("BaseRateType"));
		}
		
		
		rateSegment.setAttributeValue("BaseRate", newBaseRate);
		rateSegment.setAttributeValue("BusinessRate", RateHelper.getBusinessRate(relativeObject, rateSegment));
		bomanager.updateBusinessObject(rateSegment);
		
		return rateSegment;
	}

}