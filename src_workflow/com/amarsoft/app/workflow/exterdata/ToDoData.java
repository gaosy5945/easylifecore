package com.amarsoft.app.workflow.exterdata;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.xml.Document;

/**
 * 通过联机接口查询待办理数据
 * @author 赵晓建
 */
public class ToDoData implements IFlowData {

	/**
	 * 通过联机接口获取流程管理系统提供的待办理任务数据
	 * @param para 输入接口参数，该参数通过流程配置加工得到
	 * @return 接口数据标准对象
	 */
	public Map<String,Object> getData(Map<String,String> para,BusinessObjectManager bomanager) throws Exception{
		Map<String,Object> oo = new HashMap<String,Object>();
		
		BusinessObject taskContext = BusinessObject.createBusinessObject();
		if(!StringX.isEmpty(para.get("taskClause")))
		{
			InputStream in = new ByteArrayInputStream(para.get("taskClause").getBytes());
			Document document = new Document(in);
			in.close();
			
			taskContext = BusinessObject.createBusinessObject(document.getRootElement());
		}
		
		BusinessObject businessContext = BusinessObject.createBusinessObject();
		if(!StringX.isEmpty(para.get("businessClause")))
		{
			InputStream in = new ByteArrayInputStream(para.get("businessClause").getBytes());
			Document document = new Document(in);
			in.close();
			
			businessContext = BusinessObject.createBusinessObject(document.getRootElement());
		}
		
		
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		BusinessObject rs = fm.queryMultiPcsTodoTask(taskContext, businessContext, Integer.parseInt(para.get("StartNum")), Integer.parseInt(para.get("PageNum")), true, para.get("UserID"), para.get("OrgID"));
		
		
		oo.put("Count",rs.getString("TaskCount"));
		oo.put("Result",FlowHelper.QueryObjectFromMessage(rs.getBusinessObjects("jbo.flow.FLOW_TASK"), bomanager));
		return oo;
	}

}
