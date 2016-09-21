package com.amarsoft.app.workflow.web;


import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWQuerier;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.BizObjectClass;


/**
 * 通过联机接口查询流转信息
 * @author 张万亮
 */
public class FlowInstanceTaskBusinessProcessor extends ALSBusinessProcess implements BusinessObjectOWQuerier{

	private int totalCount;
	private BusinessObject[] data = null;
	public BusinessObject[] getBusinessObjectList(int fromIndex, int toIndex) throws Exception {
		if(fromIndex == 0 && toIndex == 15 && data != null) return data;
		
		BizObjectClass bizClass = ObjectWindowHelper.getBizObjectClass(this.asDataObject);
		
		String flowSerialNo = asPage.getParameter("FlowSerialNo");
		
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(this.transaction);
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		BusinessObject fi = fm.queryInstanceTask(flowSerialNo, fromIndex, toIndex-fromIndex, this.curUser.getUserID(), this.curUser.getOrgID());
		List<BusinessObject> tasks = fi.getBusinessObjects("jbo.flow.FLOW_TASK");
		
		totalCount = fi.getInt("TaskCount");
		
		BusinessObject[] businessObjectArray = new BusinessObject[tasks.size()];
		for(int i = 0; i < businessObjectArray.length ; i ++)
		{
			businessObjectArray[i]=BusinessObject.createBusinessObject(bizClass);
			for(int j=0; j < this.asDataObject.Columns.size(); j ++)
			{
				String colname = this.asDataObject.getColumn(j).getAttribute("ColName");
				businessObjectArray[i].setAttributeValue(colname,tasks.get(i).getObject(colname));
			}
		}
		
		return businessObjectArray;
	}

	@Override
	public int query(BusinessObject inputParameters,
			ALSBusinessProcess businessProcess) throws Exception {
		// TODO Auto-generated method stub
		data = this.getBusinessObjectList(0, 15);
		return this.totalCount;
	}

	@Override
	public int getTotalCount() throws Exception {
		// TODO Auto-generated method stub
		return totalCount;
	}
}