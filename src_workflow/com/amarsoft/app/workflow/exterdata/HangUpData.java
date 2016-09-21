package com.amarsoft.app.workflow.exterdata;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.are.util.xml.Document;


/**
 * ͨ�������ӿڲ�ѯ�ѹ�������
 * @author ������
 */
public class HangUpData implements IFlowData {

	/**
	 * ͨ�������ӿڻ�ȡ���̹���ϵͳ�ṩ���ѹ�����������
	 * @param para ����ӿڲ������ò���ͨ���������üӹ��õ�
	 * @return �ӿ����ݱ�׼����
	 */
	public Map<String,Object> getData(Map<String,String> para,BusinessObjectManager bomanager) throws Exception{
		Map<String,Object> oo = new HashMap<String,Object>();
		InputStream in = new ByteArrayInputStream(para.get("taskClause").getBytes());
		Document document = new Document(in);
		in.close();
		
		BusinessObject taskContext = BusinessObject.createBusinessObject(document.getRootElement());
		
		in = new ByteArrayInputStream(para.get("businessClause").getBytes());
		document = new Document(in);
		in.close();
		
		BusinessObject businessContext = BusinessObject.createBusinessObject(document.getRootElement());
		
		
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		BusinessObject rs = fm.queryMultiPcsHangUpTask(taskContext, businessContext, Integer.parseInt(para.get("StartNum")), Integer.parseInt(para.get("PageNum")), true, para.get("UserID"), para.get("OrgID"));
		
		
		oo.put("Count",rs.getString("TaskCount"));
		oo.put("Result",FlowHelper.QueryObjectFromMessage(rs.getBusinessObjects("jbo.flow.FLOW_TASK"), bomanager));
		return oo;
	}

}
