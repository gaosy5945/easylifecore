package com.amarsoft.app.check.apply;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.app.als.sys.tools.SYSNameManager;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �����Ѽ��ػ��棬������������SQL����
 * ҵ�����ϼ��
 * @author zhangwl
 * @since 2014/03/25
 */

public class ApplyImageDocsCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//��ò���
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ

		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject ba:baList)
			{
				ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select treedata from FLOW_OBJECT where ObjectType = :ObjectType and ObjectNo = :ObjectNo").setParameter("ObjectNo", ba.getKeyString()).setParameter("ObjectType", ba.getBizClassName()));
				while(rs.next()){
					String treeData = rs.getString(1);
					if(treeData == null || "".equals(treeData))
					{
						putMsg("���롾"+ba.getString("ContractArtificialNo")+"��δ�ϴ�Ӱ�������ϴ���");
					}
				}
				rs.close();
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
