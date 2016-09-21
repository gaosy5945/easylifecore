package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * ���Ŷ������ҵ���������Ƿ񳬹����ý��
 * @author ������
 * @since 2014/04/03
 */

public class ApplyBusinessSumCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//��ò���
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ
		Boolean flag = true;
		String taskSerialNo = (String)this.getAttribute("TaskSerialNo");
		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject ba:baList)
			{
				String maturityDate = ba.getString("MaturityDate");//������ĵ�����
				String objectNo = Sqlca.getString(new SqlObject("select AR.OBJECTNO from APPLY_RELATIVE AR where AR.OBJECTTYPE = 'jbo.app.BUSINESS_CONTRACT' "
						+ "AND AR.RELATIVETYPE = '06' AND AR.APPLYSERIALNO = :APPLYSERIALNO").setParameter("APPLYSERIALNO", ba.getAttribute("SerialNo").getString()));
				String CLType = "";
				String CLmaturityDate = "";
				if(objectNo != null){
					CLType = Sqlca.getString(new SqlObject("select CLType from CL_INFO where ObjectType = 'jbo.app.BUSINESS_CONTRACT' and ObjectNo = :ObjectNo "
							+ "and CLType IN('0101','0102','0103','0104','0107','0108')").setParameter("ObjectNo", objectNo));
					if("666".equals(ba.getString("BusinessType")) || "500".equals(ba.getString("BusinessType")) || "502".equals(ba.getString("BusinessType"))){
						//������ȵĵ�����
						CLmaturityDate = Sqlca.getString(new SqlObject("select maturityDate from CL_INFO where ObjectType = 'jbo.app.BUSINESS_CONTRACT' and ObjectNo = :ObjectNo").setParameter("ObjectNo", objectNo));
						//��ѯ�����Ķ�������Ƿ���Ϊ�����������/������
						ASResultSet bc = Sqlca.getResultSet(new SqlObject("select BC.* from BUSINESS_CONTRACT BC,CONTRACT_RELATIVE CR where CR.ObjectType = 'jbo.app.BUSINESS_CONTRACT'"
								+ " and CR.ObjectNo = :ObjectNo and CR.RELATIVETYPE = '06' and CR.CONTRACTSERIALNO = BC.SERIALNO and BC.BusinessType = :BusinessType and "
								+ "BC.ContractStatus in ('01','02','03') and BC.SerialNo <> :CONTRACTARTIFICIALNO")
								.setParameter("ObjectNo", objectNo).setParameter("BusinessType", ba.getString("BusinessType")).setParameter("CONTRACTARTIFICIALNO", ba.getString("CONTRACTARTIFICIALNO")));
						if(bc.next()){
							putMsg("����ѡ��ĺ�ͬ��"+objectNo+"��������״̬Ϊδ����ġ�"+NameManager.getBusinessName(bc.getStringValue("BusinessType"))+"���������ô˶������"+NameManager.getBusinessName(bc.getStringValue("BusinessType"))+"��");
							flag = false;
						}
						bc.close();
						//��ѯ�����Ķ�������Ƿ�����;��������/����������
						ASResultSet oba = Sqlca.getResultSet(new SqlObject("select BA.* from APPLY_RELATIVE AR,BUSINESS_APPLY BA where AR.OBJECTTYPE = 'jbo.app.BUSINESS_CONTRACT' "
						+ "AND AR.OBJECTNO = :OBJECTNO AND AR.RELATIVETYPE = '06' AND AR.APPLYSERIALNO <> :APPLYSERIALNO AND BA.SERIALNO = AR.APPLYSERIALNO AND BA.BUSINESSTYPE = :BUSINESSTYPE AND BA.APPROVESTATUS IN ('01','02')")
						.setParameter("OBJECTNO", objectNo).setParameter("APPLYSERIALNO", ba.getString("SerialNo")).setParameter("BUSINESSTYPE", ba.getString("BusinessType")));
						if(oba.next()){
							putMsg("����ѡ��ĺ�ͬ��"+objectNo+"����������;��"+NameManager.getBusinessName(oba.getStringValue("BusinessType"))+"���룬�������ô˶������"+NameManager.getBusinessName(oba.getStringValue("BusinessType"))+"��");
							flag = false;
						}
						oba.close();
					}
				}
				if(maturityDate.compareTo(CLmaturityDate) >= 0 && "666".equals(ba.getString("BusinessType"))){
					putMsg("�����������׵����ա�"+maturityDate+"��ӦС�ڶ�ȵ����ա�"+CLmaturityDate+"��");
					flag = false;
				}else if(maturityDate.compareTo(CLmaturityDate) >= 0 && ("500".equals(ba.getString("BusinessType")) || "502".equals(ba.getString("BusinessType")))){
					putMsg("�����������׵����ա�"+maturityDate+"��ӦС�ڶ�ȵ����ա�"+CLmaturityDate+"��");
					flag = false;
				}
				if(CLType != null && !"".equals(CLType))
				{
					com.amarsoft.dict.als.object.Item item = com.amarsoft.dict.als.cache.CodeCache.getItem("CLType", CLType);
					String className = item.getItemDescribe();
					if(className != null)
					{
						Class c = Class.forName(className);
						com.amarsoft.app.als.cl.CreditObject co = (com.amarsoft.app.als.cl.CreditObject)c.newInstance();
						co.load(Sqlca.getConnection(), "jbo.app.BUSINESS_CONTRACT", objectNo);
						co.calcBalance();
						co.saveData(Sqlca.getConnection());
						if(co.RiskMessage.size()>0)
						{
							putMsg(co.RiskMessage.toString());
							flag = false;
						}
						else if(co.AlarmMessage.size()>0)
						{
							putMsg(co.AlarmMessage.toString());
						}
					}
				}
				
				//���+�ױ�У��
				String businessType = ba.getString("BusinessType");
				double businessSum = ba.getDouble("BusinessSum");
				double barovebusinessSum = 0.0;
				double arbaroveBusinessSum  = 0.0;
				String baroveMaturityDate = "";
				String arbaroveMaturityDate = "";
				List<BusinessObject> arbas = ba.getBusinessObjects("jbo.app.BUSINESS_APPLY");
				if(arbas != null && !arbas.isEmpty())
				{
					for(BusinessObject arba:arbas)
					{
						ASResultSet barove = Sqlca.getASResultSet(new SqlObject("select * from BUSINESS_APPROVE where ApplySerialNo = :ApplySerialNo and TaskSerialNo = :TaskSerialNo ").setParameter("ApplySerialNo", ba.getString("SerialNo")).setParameter("TaskSerialNo", taskSerialNo));
						if(barove.next()){
							barovebusinessSum = barove.getDouble("BusinessSum");
							baroveMaturityDate = barove.getString("MaturityDate");
							ASResultSet arbarove = Sqlca.getASResultSet(new SqlObject("select * from BUSINESS_APPROVE where ApplySerialNo = :ApplySerialNo and TaskSerialNo = :TaskSerialNo ").setParameter("ApplySerialNo", arba.getString("SerialNo")).setParameter("TaskSerialNo", taskSerialNo));
							if(arbarove.next()){
								arbaroveBusinessSum = arbarove.getDouble("BusinessSum");
								arbaroveMaturityDate = arbarove.getString("MaturityDate");
							}
							arbarove.close();
						}
						barove.close();
						
						String subBusinessType = arba.getString("BusinessType");
						double subBusinessSum = arba.getDouble("BusinessSum");
						String subMaturityDate = arba.getString("MaturityDate");
						if(("555".equals(businessType) || "999".equals(businessType)))
						{
							if(businessSum < subBusinessSum)
							{
								putMsg("��������ױ�ҵ���"+DataConvert.toMoney(subBusinessSum)+"�������˿��ö�Ƚ�"+DataConvert.toMoney(businessSum)+"��");
								flag = false;
							}
							
							if(maturityDate.compareTo(subMaturityDate) <= 0)
							{
								putMsg("��������ױ�ҵ�����ա�"+subMaturityDate+"��ӦС�ڶ�ȵ����ա�"+maturityDate+"��");
								flag = false;
							}
							
							if(barovebusinessSum < arbaroveBusinessSum && barovebusinessSum > 0 && arbaroveBusinessSum > 0){
								putMsg("����׼���ױ�ҵ���"+DataConvert.toMoney(arbaroveBusinessSum)+"�������˿��ö�Ƚ�"+DataConvert.toMoney(barovebusinessSum)+"��");
								flag = false;
							}
							if(arbaroveMaturityDate != null && !"".equals(arbaroveMaturityDate) 
									&& baroveMaturityDate != null && !"".equals(baroveMaturityDate) && arbaroveMaturityDate.compareTo(baroveMaturityDate) >= 0){
								putMsg("����׼���ױ�ҵ�����ա�"+arbaroveMaturityDate+"��ӦС�ڶ�ȵ����ա�"+baroveMaturityDate+"��");
								flag = false;
							}
						}
						
						
					}
				}
				
			}
			
		}
		setPass(flag);
		
		return null;
	}
}
