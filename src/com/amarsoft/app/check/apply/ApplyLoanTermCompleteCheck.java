package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.awe.util.Transaction;

/**
 * 数据已加载缓存，本类中无需再SQL加载
 * 业务申请信息完整性检查
 * @author xjzhao
 * @since 2014/12/10
 */

public class ApplyLoanTermCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//获得参数
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息

		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
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
							this.putMsg("续贷的申请，新贷款金额不能超过原贷款余额【"+balance+"】!");
						}
						int oldMonths = (int)Math.floor(DateHelper.getMonths(bd.getString("PUTOUTDATE"), bd.getString("MATURITYDATE")));
						if(businessterm>oldMonths||(businessterm==oldMonths&&businesstermDay>0))
						{
							this.putMsg("续贷/借新换旧的申请，新贷款期限不能超过原贷款期限【"+oldMonths+"月】!");
						}
						if(businessterm>12 || (businessterm == 12 && businesstermDay>0))
						{
							this.putMsg("续贷的申请，新贷款期限不能超过1年!");
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
							this.putMsg("续贷/借新换旧的申请，新贷款期限不能超过原贷款期限【"+oldMonths+"月】!");
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
