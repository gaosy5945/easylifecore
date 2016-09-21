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

public class ApplyDocsCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//��ò���
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ

		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject ba:baList)
			{
				String docs = ProductAnalysisFunctions.getComponentMandatoryValue(BusinessObject.convertFromBizObject(ba), "PRD04-01", "BusinessDocs", "0010", "01");
				ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select FileID from DOC_FILE_INFO where ObjectType = 'contract' and ObjectNo = :ObjectNo").setParameter("ObjectNo", ba.getString("ContractArtificialNo")));
				Map paraHashmap = new HashMap();
				while(rs.next()){
					paraHashmap.put(rs.getStringValue("FileID"), rs.getStringValue("FileID"));
				}
				if(docs != null && !"".equals(docs)){
					String[] docArray = docs.split(",");
					for(String docID:docArray){
						String has = "";
						try{
							has = paraHashmap.get(docID).toString();
						}catch(Exception e){
							
						}
						if(has == null || "".equals(has)){
							String FileName = SYSNameManager.getFileName(docID);
							putMsg("��"+FileName+"��Ϊ��ѡ���ϣ��벹�䣡");
						}
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
