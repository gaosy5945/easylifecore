package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �����Ѽ��ػ��棬������������SQL����
 * ҵ��������Ϣ�����Լ��
 * @author xjzhao
 * @since 2014/12/10
 */

public class ApplyPRJCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//��ò���
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ

		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject ba:baList)
			{
				ASResultSet pbi = Sqlca.getResultSet(new SqlObject("select PBI.ProjectType,PBI.ProjectName,PBI.SerialNo from PRJ_RELATIVE O, PRJ_BASIC_INFO PBI where "
						+ "O.ProjectSerialNo = PBI.SerialNo and PBI.PROJECTTYPE = '0110' and O.RelativeType = '01' and O.ObjectType = "
						+ "'jbo.app.BUSINESS_APPLY' and O.OBJECTNO = :ObjectNo").setParameter("ObjectNo", ba.getString("SerialNo")));
				while(pbi.next()){
					//��������ĺ�����Ŀ�����������ڷ���Ŀ��ҪУ���Ƿ񳬹����õ�������
					if("0110".equals(pbi.getStringValue("ProjectType"))){
						String serialNo = ba.getString("SerialNo");
						int i = 0;
						//��ѯ�����ڷ���Ŀ�����˶��ٱ���Ч�����루�����ʣ�
						ASResultSet ra = Sqlca.getResultSet(new SqlObject("select * from PRJ_RELATIVE O, PRJ_BASIC_INFO PBI, BUSINESS_APPLY BA where "
								+ "O.ProjectSerialNo = PBI.SerialNo and PBI.PROJECTTYPE = '0110' and O.RelativeType = '01' and O.ObjectType = "
								+ "'jbo.app.BUSINESS_APPLY' and O.OBJECTNO = BA.SERIALNO and BA.Approvestatus in ('01','02','03') and PBI.SerialNo = "
								+ ":PBISerialNo and BA.SerialNo <> :SerialNo")
								.setParameter("PBISerialNo", pbi.getStringValue("SerialNo"))
								.setParameter("SerialNo", serialNo));
						while(ra.next()){
							i++;
						}
						ra.close();
						//��ѯ���õ�������
						ASResultSet fd = Sqlca.getASResultSet(new SqlObject("select O.MAXBUSINESSNUM from FLOW_DELIVERYHOUSE O where exists (select 1 from ORG_BELONG OB where OB.BelongOrgID = :OrgID and OB.OrgID = O.OrgID)")
						.setParameter("OrgID", ba.getString("OperateOrgID")));
						while(fd.next()){
							int maxBusinessSum = Integer.parseInt(fd.getStringValue("MAXBUSINESSNUM"));
							//��������ڷ���Ŀ�����ʾʹﵽ�������ñ����������ټ�������
							if(i >= maxBusinessSum){
								putMsg("�����ڷ���Ŀ��"+pbi.getStringValue("ProjectName")+"���ѳ������ҵ�����������������ҵ��");
								break;
							}
						}
						fd.close();
					}
				}
				pbi.close();
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
