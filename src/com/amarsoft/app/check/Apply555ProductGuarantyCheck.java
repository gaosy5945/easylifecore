package com.amarsoft.app.check;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.Transaction;

public class Apply555ProductGuarantyCheck extends AlarmBiz{

	@Override
	public Object run(Transaction Sqlca) throws Exception {

		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				String vouchType = ba.getString("VouchType");//担保方式：005信用；01090其他保证；
				if(vouchType == null) vouchType = "";
				//DecimalFormat nf = new DecimalFormat("00.00000");
				//String a = nf.format(ba.getDouble("BusinessSum"));
				double businessSum = Double.parseDouble(ba.getString("BusinessSum"));//申请金额
				double guarantyValue = 0.00;
				List<BusinessObject> gcList = ba.getBusinessObjects("jbo.guaranty.GUARANTY_CONTRACT");
				if(gcList != null && gcList.size()>0){
					
					for(BusinessObject gc:gcList){
						
						String guarantyType = gc.getString("GuarantyType");
						if("01090".equals(guarantyType)){
							guarantyValue += gc.getDouble("GuarantyValue");
						}
					}
					
					if("005,01090".equals(vouchType)){
						if(businessSum > guarantyValue){
							double difference = businessSum - guarantyValue;
							putMsg("担保总额小于申请总额，差额为["+difference+"]。");
						}
					}else if("01090".equals(vouchType)){
						if(businessSum > guarantyValue){
							putMsg("授信额度必须小于等于保证人的担保主债权之和！");
						}
					}
				}
			}
		}
		
		/** 返回结果处理 **/
		if(messageSize() > 0){
			this.setPass(false);
		}else{
			this.setPass(true);
		}
		return null;
	}
}
