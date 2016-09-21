package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 消贷易、融资易检查
 * @author 张万亮
 * @since 2014/04/08
 */

public class ApplyBusinessTermCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//获得参数
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				String birthDay = Sqlca.getString(new SqlObject("select BirthDay from IND_INFO where CustomerID = :CustomerID").setParameter("CustomerID",ba.getString("CustomerID")));
				String maturityDate = ba.getString("MaturityDate");
				String RPTTermID = ba.getString("RPTTermID");
				if("666".equals(ba.getString("BusinessType"))){
					if(birthDay != null && !"".equals(birthDay) && maturityDate != null && !"".equals(maturityDate) ){
						int birthYear = Integer.parseInt(birthDay.substring(0, 4));
						int MaxYear = birthYear+70;
						String MaxDate = MaxYear+birthDay.substring(4, 10);
						int upMonths = (int) Math.floor(DateHelper.getMonths(birthDay, maturityDate));
						int BusinessTerm = Integer.parseInt(ba.getString("BusinessTerm"));
						int BusinessTermDay = Integer.parseInt(ba.getString("BusinessTermDay"));
						if(BusinessTermDay > 0) BusinessTerm += 1;
						int sumMonths = upMonths+BusinessTerm;
						if(sumMonths > 840){
							//putMsg("消贷易转贷期限不符合要求，该申请人的出生日期为【"+birthDay+"】，额度到期日+转贷期限不得超过【"+MaxDate+"】，请修改转贷期限或额度到期日！");
						}else if(BusinessTerm > 120){
							//putMsg("消贷易转贷期限不能超过10年");
						}else if(BusinessTerm <= 12){
							if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID) && !"RPT-03".equals(RPTTermID) && !"RPT-04".equals(RPTTermID)){
								putMsg("还款方式有误，转贷期限一年（含）以内，可选等额本息、等额本金、一次还本付息和按期付息一次还本!");
							}
						}else if(BusinessTerm > 12 &&  BusinessTerm<= 120){
							if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID)){
								putMsg("还款方式有误，转贷期限在一年以上，可选等额本息和等额本金!");
							}
						}
					}
				}
				if("500".equals(ba.getString("BusinessType")) || "502".equals(ba.getString("BusinessType"))){
					if(birthDay != null && !"".equals(birthDay) && maturityDate != null && !"".equals(maturityDate) ){
						int birthYear = Integer.parseInt(birthDay.substring(0, 4));
						int MaxYear = birthYear+70;
						String MaxDate = MaxYear+birthDay.substring(4, 10);
						int upMonths = (int) Math.floor(DateHelper.getMonths(birthDay, maturityDate));
						int BusinessTerm = Integer.parseInt(ba.getString("BusinessTerm"));
						int BusinessTermDay = Integer.parseInt(ba.getString("BusinessTermDay"));
						if(BusinessTermDay > 0) BusinessTerm += 1;
						if(upMonths > 840){
							//putMsg("融资易转贷期限不符合要求，该申请人的出生日期为【"+birthDay+"】，额度到期日+转贷期限不得超过【"+MaxDate+"】，请修改转贷期限或额度到期日！");
						}else if(BusinessTerm > 12){
							//putMsg("融资易转贷期限不能超过1年");
						}else if(BusinessTerm <= 12){
							if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID) && !"RPT-03".equals(RPTTermID) && !"RPT-04".equals(RPTTermID)){
								putMsg("还款方式有误，转贷期限一年（含）以内，可选等额本息、等额本金、一次还本付息和按期付息一次还本!");
							}
						}
					}
				}
				List<BusinessObject> arbas = ba.getBusinessObjects("jbo.app.BUSINESS_APPLY");
				if(arbas != null && !arbas.isEmpty())
				{
					for(BusinessObject arba:arbas)
					{
						maturityDate = arba.getString("MaturityDate");
						RPTTermID = arba.getString("RPTTermID");
						if("666".equals(arba.getString("BusinessType"))){
							if(birthDay != null && !"".equals(birthDay) && maturityDate != null && !"".equals(maturityDate) ){
								int birthYear = Integer.parseInt(birthDay.substring(0, 4));
								int MaxYear = birthYear+70;
								String MaxDate = MaxYear+birthDay.substring(4, 10);
								int upMonths = (int) Math.floor(DateHelper.getMonths(birthDay, maturityDate));
								int BusinessTerm = Integer.parseInt(arba.getString("BusinessTerm"));
								int BusinessTermDay = Integer.parseInt(arba.getString("BusinessTermDay"));
								if(BusinessTermDay > 0) BusinessTerm += 1;
								int sumMonths = upMonths+BusinessTerm;
								if(sumMonths > 840){
									//putMsg("消贷易转贷期限不符合要求，该申请人的出生日期为【"+birthDay+"】，额度到期日+转贷期限不得超过【"+MaxDate+"】，请修改转贷期限或额度到期日！");
								}else if(BusinessTerm > 120){
									//putMsg("消贷易转贷期限不能超过10年");
								}else if(BusinessTerm <= 12){
									if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID) && !"RPT-03".equals(RPTTermID) && !"RPT-04".equals(RPTTermID)){
										putMsg("还款方式有误，转贷期限一年（含）以内，可选等额本息、等额本金、一次还本付息和按期付息一次还本!");
									}
								}else if(BusinessTerm > 12 &&  BusinessTerm<= 120){
									if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID)){
										putMsg("还款方式有误，转贷期限在一年以上，可选等额本息和等额本金!");
									}
								}
							}
						}
						if("500".equals(arba.getString("BusinessType")) || "502".equals(arba.getString("BusinessType"))){
							if(birthDay != null && !"".equals(birthDay) && maturityDate != null && !"".equals(maturityDate) ){
								int birthYear = Integer.parseInt(birthDay.substring(0, 4));
								int MaxYear = birthYear+70;
								String MaxDate = MaxYear+birthDay.substring(4, 10);
								int upMonths = (int) Math.floor(DateHelper.getMonths(birthDay, maturityDate));
								int BusinessTerm = Integer.parseInt(arba.getString("BusinessTerm"));
								int BusinessTermDay = Integer.parseInt(arba.getString("BusinessTermDay"));
								if(BusinessTermDay > 0) BusinessTerm += 1;
								if(upMonths > 840){
									//putMsg("融资易转贷期限不符合要求，该申请人的出生日期为【"+birthDay+"】，额度到期日+转贷期限不得超过【"+MaxDate+"】，请修改转贷期限或额度到期日！");
								}else if(BusinessTerm > 12){
									//putMsg("融资易转贷期限不能超过1年");
								}else if(BusinessTerm <= 12){
									if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID) && !"RPT-03".equals(RPTTermID) && !"RPT-04".equals(RPTTermID)){
										putMsg("还款方式有误，转贷期限一年（含）以内，可选等额本息、等额本金、一次还本付息和按期付息一次还本!");
									}
								}
							}
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
