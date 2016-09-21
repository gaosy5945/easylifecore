package com.amarsoft.app.check;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.Transaction;

public class Apply555ProductGuarantyCheck extends AlarmBiz{

	@Override
	public Object run(Transaction Sqlca) throws Exception {

		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ
		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject ba:baList)
			{
				String vouchType = ba.getString("VouchType");//������ʽ��005���ã�01090������֤��
				if(vouchType == null) vouchType = "";
				//DecimalFormat nf = new DecimalFormat("00.00000");
				//String a = nf.format(ba.getDouble("BusinessSum"));
				double businessSum = Double.parseDouble(ba.getString("BusinessSum"));//������
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
							putMsg("�����ܶ�С�������ܶ���Ϊ["+difference+"]��");
						}
					}else if("01090".equals(vouchType)){
						if(businessSum > guarantyValue){
							putMsg("���Ŷ�ȱ���С�ڵ��ڱ�֤�˵ĵ�����ծȨ֮�ͣ�");
						}
					}
				}
			}
		}
		
		/** ���ؽ������ **/
		if(messageSize() > 0){
			this.setPass(false);
		}else{
			this.setPass(true);
		}
		return null;
	}
}
