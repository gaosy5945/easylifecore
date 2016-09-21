package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �����ס������׼��
 * @author ������
 * @since 2014/04/08
 */

public class ApplyBusinessTermCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//��ò���
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ
		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
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
							//putMsg("������ת�����޲�����Ҫ�󣬸������˵ĳ�������Ϊ��"+birthDay+"������ȵ�����+ת�����޲��ó�����"+MaxDate+"�������޸�ת�����޻��ȵ����գ�");
						}else if(BusinessTerm > 120){
							//putMsg("������ת�����޲��ܳ���10��");
						}else if(BusinessTerm <= 12){
							if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID) && !"RPT-03".equals(RPTTermID) && !"RPT-04".equals(RPTTermID)){
								putMsg("���ʽ����ת������һ�꣨�������ڣ���ѡ�ȶϢ���ȶ��һ�λ�����Ϣ�Ͱ��ڸ�Ϣһ�λ���!");
							}
						}else if(BusinessTerm > 12 &&  BusinessTerm<= 120){
							if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID)){
								putMsg("���ʽ����ת��������һ�����ϣ���ѡ�ȶϢ�͵ȶ��!");
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
							//putMsg("������ת�����޲�����Ҫ�󣬸������˵ĳ�������Ϊ��"+birthDay+"������ȵ�����+ת�����޲��ó�����"+MaxDate+"�������޸�ת�����޻��ȵ����գ�");
						}else if(BusinessTerm > 12){
							//putMsg("������ת�����޲��ܳ���1��");
						}else if(BusinessTerm <= 12){
							if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID) && !"RPT-03".equals(RPTTermID) && !"RPT-04".equals(RPTTermID)){
								putMsg("���ʽ����ת������һ�꣨�������ڣ���ѡ�ȶϢ���ȶ��һ�λ�����Ϣ�Ͱ��ڸ�Ϣһ�λ���!");
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
									//putMsg("������ת�����޲�����Ҫ�󣬸������˵ĳ�������Ϊ��"+birthDay+"������ȵ�����+ת�����޲��ó�����"+MaxDate+"�������޸�ת�����޻��ȵ����գ�");
								}else if(BusinessTerm > 120){
									//putMsg("������ת�����޲��ܳ���10��");
								}else if(BusinessTerm <= 12){
									if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID) && !"RPT-03".equals(RPTTermID) && !"RPT-04".equals(RPTTermID)){
										putMsg("���ʽ����ת������һ�꣨�������ڣ���ѡ�ȶϢ���ȶ��һ�λ�����Ϣ�Ͱ��ڸ�Ϣһ�λ���!");
									}
								}else if(BusinessTerm > 12 &&  BusinessTerm<= 120){
									if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID)){
										putMsg("���ʽ����ת��������һ�����ϣ���ѡ�ȶϢ�͵ȶ��!");
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
									//putMsg("������ת�����޲�����Ҫ�󣬸������˵ĳ�������Ϊ��"+birthDay+"������ȵ�����+ת�����޲��ó�����"+MaxDate+"�������޸�ת�����޻��ȵ����գ�");
								}else if(BusinessTerm > 12){
									//putMsg("������ת�����޲��ܳ���1��");
								}else if(BusinessTerm <= 12){
									if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID) && !"RPT-03".equals(RPTTermID) && !"RPT-04".equals(RPTTermID)){
										putMsg("���ʽ����ת������һ�꣨�������ڣ���ѡ�ȶϢ���ȶ��һ�λ�����Ϣ�Ͱ��ڸ�Ϣһ�λ���!");
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
