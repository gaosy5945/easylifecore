package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.awe.util.Transaction;

/**
 * �����Ѽ��ػ��棬������������SQL����
 * ҵ��������Ϣ�����Լ��
 * @author xjzhao
 * @since 2014/12/10
 */

public class ApplyLoanTermCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//��ò���
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ

		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject ba:baList)
			{
				
				String occurtype = ba.getString("OccurType");
				int businessterm = ba.getInt("BUSINESSTERM");
				int businesstermDay= ba.getInt("BUSINESSTERMDAY");
				if("0030".equals(occurtype))
				{
					List<BusinessObject> bdList = ba.getBusinessObjects("jbo.app.BUSINESS_DUEBILL");
					for(BusinessObject bd:bdList)
					{
						//int loanterm = bd.getInt("TOTALPERIOD");BALANCE
						double balance = bd.getDouble("Balance");
						double BusinessSum = ba.getDouble("BusinessSum");
						if(BusinessSum>balance){
							this.putMsg("���������룬�´�����ܳ���ԭ������"+balance+"��!");
						}
						int oldMonths = (int)Math.floor(DateHelper.getMonths(bd.getString("PUTOUTDATE"), bd.getString("MATURITYDATE")));
						if(businessterm>oldMonths||(businessterm==oldMonths&&businesstermDay>0))
						{
							this.putMsg("����/���»��ɵ����룬�´������޲��ܳ���ԭ�������ޡ�"+oldMonths+"�¡�!");
						}
						if(businessterm>12 || (businessterm == 12 && businesstermDay>0))
						{
							this.putMsg("���������룬�´������޲��ܳ���1��!");
						}
					}
					
				}else if("0020".equals(occurtype)){
					List<BusinessObject> bdList = ba.getBusinessObjects("jbo.app.BUSINESS_DUEBILL");
					for(BusinessObject bd:bdList)
					{
						//int loanterm = bd.getInt("TOTALPERIOD");
						int oldMonths = (int)Math.floor(DateHelper.getMonths(bd.getString("PUTOUTDATE"), bd.getString("MATURITYDATE")));
						if(businessterm>oldMonths||(businessterm==oldMonths&&businesstermDay>0))
						{
							this.putMsg("����/���»��ɵ����룬�´������޲��ܳ���ԭ�������ޡ�"+oldMonths+"�¡�!");
						}
					}
				}
				

			}
		}
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
