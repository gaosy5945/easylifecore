package com.amarsoft.app.check.apply;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ���������ƻ���Ա������Ŀ���
 * @author ����ǿ
 * @since 2015/03/24
 */

public class CreditGroupPBICheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		HashMap<String,HashSet<String>> map = new HashMap<String,HashSet<String>>();//�����洢���������ƻ���Ա����������Ŀ
		//��ò���
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ

		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject ba:baList)
			{
			    if("052".equals(ba.getString("ProductID"))){//���������ƻ�����
			    	String serialNo = ba.getString("SerialNo");
					HashSet<String> set = new HashSet<String>();
					map.put(serialNo, set);
					String sSql = "select nvl(O.ProjectSerialNo,' ') from PRJ_RELATIVE O"+
					              " where O.ObjectType='jbo.app.BUSINESS_APPLY' and O.ObjectNo=:ObjectNo";
					ASResultSet rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("ObjectNo", serialNo));
					while(rs.next()){
						set.add(rs.getString(1));
					}
					rs.close();
			    }				
			}
			
			Set<String> mkeyset = map.keySet();
			if(mkeyset.size()>1){
				Object[] keys =  mkeyset.toArray();
				//�ö���ѭ���ж�
				for(int i=0;i<keys.length-1;i++){
					for(int j=i+1;j<keys.length;j++){
						if(!isSetEqual(map.get(keys[i].toString()),map.get(keys[j].toString()))){
							String customerName1 = Sqlca.getString(new SqlObject("select nvl(CustomerName,' ') from Business_Apply where SerialNo=:SerialNo").setParameter("SerialNo", keys[i].toString()));
							String customerName2 = Sqlca.getString(new SqlObject("select nvl(CustomerName,' ') from Business_Apply where SerialNo=:SerialNo").setParameter("SerialNo", keys[j].toString()));
							putMsg("���뷽��("+customerName1+")�����뷽��("+customerName2+")�����ĺ�����Ŀ��ͬ");
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
	
	public boolean isSetEqual(HashSet<String> set1,HashSet<String> set2){
		if(set1.size()!=set2.size()) return false;
		Iterator ite1 = set1.iterator();
		Iterator ite2 = set2.iterator();
		while(ite1.hasNext()){
			if(!ite1.next().equals(ite2.next())) return false;
		}
		return true;
	}
	
}
