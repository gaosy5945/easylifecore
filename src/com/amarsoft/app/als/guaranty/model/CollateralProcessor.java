package com.amarsoft.app.als.guaranty.model;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jdom.Element;
import org.jdom.output.XMLOutputter;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWQuerier;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.exterdata.IFlowData;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.dw.ASDataObjectFilter;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

public class CollateralProcessor extends ALSBusinessProcess implements BusinessObjectOWQuerier{
	private int totalCount = 0;
	private List<BusinessObject> flowTaskList = new ArrayList<BusinessObject>();
	
	@Override
	public int query(BusinessObject inputParameters,ALSBusinessProcess businessProcess) throws Exception {
		//this.getBusinessObjectList(0, 1);
		return this.totalCount;
	}
	
	@Override
	public BusinessObject[] getBusinessObjectList(int fromIndex, int toIndex) throws Exception {
		BizObjectClass bizClass = ObjectWindowHelper.getBizObjectClass(this.asDataObject);
				
		String collNos=asPage.getParameter("SerialNos");
		String collNames=asPage.getParameter("CollNames");
		String collTypes=asPage.getParameter("CollTypes");
		String collVals=asPage.getParameter("CollVals");

		totalCount=collNos.split(",").length;
		String colNos[] = collNos.split(",");
		String colNames[] = collNames.split(",");
		String colTypes[] = collTypes.split(",");
		String colVals[] = collVals.split(",");
		
		for(int i = 0;i < totalCount;i++){
			BusinessObject bo = BusinessObject.createBusinessObject();
			bo.setAttributeValue("SerialNo", colNos[i]);
			//bo.setAttributeValue("CollName", colNames[i]);
			//bo.setAttributeValue("CollType", colTypes[i]);
			if(!colNames[i].equals("NAV")){//接口返回为空时置换成NAV
				bo.setAttributeValue("CollName", colNames[i]);
			}
			else{
				bo.setAttributeValue("CollName", "");
			}
			if(!colTypes[i].equals("NAV")){//接口返回为空时置换成NAV
				bo.setAttributeValue("CollType", colTypes[i]);
			}
			else{
				bo.setAttributeValue("CollType", "");
			}
			if(!colVals[i].equals("NAV")){//接口返回为空时置换成NAV
				bo.setAttributeValue("CollValue", colVals[i]);
			}
			else{
				bo.setAttributeValue("CollValue", "");
			}
			this.flowTaskList.add(bo);
		}
		
		BusinessObject[] businessObjectArray = new BusinessObject[flowTaskList.size()];
		for(int i=0;i<flowTaskList.size();i++){
			businessObjectArray[i]=BusinessObject.createBusinessObject(bizClass);
			businessObjectArray[i].setAttributesValue(flowTaskList.get(i));
		}
		return businessObjectArray;
			
		
	}

	@Override
	public int getTotalCount() throws Exception {
		return totalCount;
	}
}
