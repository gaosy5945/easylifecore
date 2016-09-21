package com.amarsoft.app.workflow.web;

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
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
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

public class FlowTaskBusinessProcessor extends ALSBusinessProcess implements BusinessObjectOWQuerier{
	private int totalCount = 0;
	private boolean filterFlag = false;
	private BusinessObject[] data = null;
	private List<BusinessObject> flowTaskList = new ArrayList<BusinessObject>();
	
	@Override
	public int query(BusinessObject inputParameters,ALSBusinessProcess businessProcess) throws Exception {
		data = this.getBusinessObjectList(0, 15);
		return this.totalCount;
	}
	private Element getExprElement(String fieldName,String operation,Object value) throws Exception{
		Element exprElement =new Element("expr");
		exprElement.setAttribute("id", "1");
		Element fieldElement =new Element("field");
		fieldElement.setText(fieldName);
		exprElement.addContent(fieldElement);
		
		Element opElement =new Element("op");
		opElement.setText(operation);
		exprElement.addContent(opElement);
		if(value instanceof List){
			for(Object value_t:(List)value){
				Element valueElement =new Element("value");
				valueElement.setText(String.valueOf(value_t));
				exprElement.addContent(valueElement);
			}
		}
		else{
			Element valueElement =new Element("value");
			valueElement.setText(String.valueOf(value));
			exprElement.addContent(valueElement);
		}
		return exprElement;
	}

	private String getBusinessFilterXMLString() throws Exception{
		Element root =new Element("criteria");
		String flowTypeString=asPage.getParameter("FlowType");//流程类型
		String queryType=asPage.getParameter("QueryType");//任务查询类型，全部任务、可办、待办等等
		
		if(StringX.isEmpty(flowTypeString)) return "";
		String[] flowTypeArray = flowTypeString.split(",");
		
		String tableName="";
		StringBuffer sb = new StringBuffer();
		for(String flowType:flowTypeArray){
			List<BusinessObject> flowCatalogs = FlowConfig.getFlowCatalog(flowType);
			
			for(BusinessObject flowCatalog:flowCatalogs){
				if(StringX.isEmpty(tableName))
					tableName = flowCatalog.getString("BusinessTable");
				if(!tableName.equals(flowCatalog.getString("BusinessTable"))) throw new Exception("传入的流程定义名称必须采用同一业务信息，请检查！");
			}
			
			BusinessObject item = FlowConfig.getFlowType(flowType);
			if(item == null) continue;
			String orderFields = "";
			if("01".equals(queryType)){//可办任务 - 任务池中
				orderFields = item.getString("AvlBusinessOrderCondition");
			}else if("02".equals(queryType)) //待办任务
			{
				orderFields = item.getString("TodoBusinessOrder");
			}else if("03".equals(queryType)) //已处理任务
			{
				orderFields = item.getString("FinishBusinessOrderCondition");
			}
			
			if(!StringX.isEmpty(orderFields)){
				String[] orderFieldArray = orderFields.split(",");
				for(String orderField:orderFieldArray){
					if(sb.indexOf(orderField) <= -1 && orderField != null && !"".equals(orderField))
					{
						Element orderElement =new Element("order");
						orderElement.setText(orderField);
						root.addContent(orderElement);
					}
				}
				sb.append(orderFields);
			}
		}
		
		if(tableName == null || "".equals(tableName)) return "";
		Element tableElement =new Element("table");
		tableElement.setText(tableName);
		root.addContent(tableElement);
		
		Element whereElement =new Element("where");
		whereElement.setAttribute("id", "1");
		root.addContent(whereElement);
		
		Element andElement =new Element("and");
		andElement.setAttribute("id", "1");
		String applyType = asPage.getParameter("ApplyType");//默认都有此条件
		if(!StringX.isEmpty(applyType)){
			Element applyTypeElement = getExprElement("ApplyType","eq",applyType);
			andElement.addContent(applyTypeElement);
		}
		
		this.filterFlag = false;
		ASDataObject dataObject = this.getASDataObject();
		if(dataObject.Filters!=null){
			for(int k=0;k<dataObject.Filters.size();k++){
				ASDataObjectFilter asFilter = (ASDataObjectFilter)dataObject.Filters.get(k);
				if(asFilter.sFilterInputs==null) continue;
				String colName = asFilter.acColumn.getAttribute("ColName");
				
				String sColFilterRefId = dataObject.getColumn(colName).getAttribute("COLFILTERREFID");
				if(sColFilterRefId!=null && sColFilterRefId.length()>0)
					colName = sColFilterRefId;
				String upperCaseColName = colName.toUpperCase();
				String option = "";
				String value = "";
				String value2 = "";
				if(request.getParameter("DOFILTER_DF_"+ upperCaseColName +"_1_OP")!=null){
					option = URLDecoder.decode(request.getParameter("DOFILTER_DF_"+ upperCaseColName +"_1_OP").toString(),"UTF-8");
				}
				if(request.getParameter("DOFILTER_DF_"+ upperCaseColName +"_1_VALUE")!=null){
					value = URLDecoder.decode(request.getParameter("DOFILTER_DF_"+ upperCaseColName +"_1_VALUE").toString(),"UTF-8");
				}
				if(request.getParameter("DOFILTER_DF_"+ upperCaseColName +"_2_VALUE")!=null){
					value2 = URLDecoder.decode(request.getParameter("DOFILTER_DF_"+ upperCaseColName +"_2_VALUE").toString(),"UTF-8");
				}
				
				String xmlOperation = "";
				Object xmlValue=null;
				if(option.equalsIgnoreCase("In")){
					if(StringX.isEmpty(value)) continue;
					String[] s = value.split("\\|");
					List<String> l = new ArrayList<String>();
					for(String s1:s){
						l.add(s1);
					}
					xmlValue=l;
					xmlOperation="in";
				}
				else if(option.equalsIgnoreCase("Area")){
					if(StringX.isEmpty(value)&&StringX.isEmpty(value2)) continue;
					List<String> l = new ArrayList<String>();
					l.add(value);
					l.add(value2);
					xmlValue=l;
					xmlOperation="between";
				}
				else if(option.equalsIgnoreCase("Like")){
					if(StringX.isEmpty(value)) continue;
					xmlValue="%"+value+"%";
					xmlOperation="like";
				}
				else if(option.equalsIgnoreCase("BeginsWith")){
					if(StringX.isEmpty(value)) continue;
					xmlValue=value+"%";
					xmlOperation="like";
				}else{
					if(StringX.isEmpty(value)) continue;
					xmlValue=value;
					xmlOperation="eq";
				}
				
				Element filterElement = getExprElement(colName,xmlOperation,xmlValue);
				andElement.addContent(filterElement);
				this.filterFlag = true;
			}
		}
		if(andElement.getContent() != null && !andElement.getContent().isEmpty())
		{
			whereElement.addContent(andElement);
		}
		XMLOutputter out = new XMLOutputter();
		String xml = "<?xml version=\"1.0\" encoding=\""+ARE.getProperty("CharSet","GBK")+"\"?>"+out.outputString(root);
		return xml;
	}
	
	@Override
	public BusinessObject[] getBusinessObjectList(int fromIndex, int toIndex) throws Exception {
		
		if(fromIndex == 0 && toIndex == 15 && data != null) return data;
		
		BizObjectClass bizClass = ObjectWindowHelper.getBizObjectClass(this.asDataObject);
		
		Map<String,String> flowQueryParameters = new HashMap<String,String>();
		flowQueryParameters.put("UserID", this.getCurUser().getUserID());
		
		String flowType=asPage.getParameter("FlowType");//流程类型
		String queryType=asPage.getParameter("QueryType");//任务查询类型，全部任务、可办、待办等等
		String phaseType=asPage.getParameter("PhaseType");//流程阶段类型
		String filterFlag=asPage.getParameter("FilterFlag");//查询条件标志，如果为1表示没有查询条件时不显示
		String taskFilterString = FlowHelper.getFlowFilter(flowType,queryType, phaseType);
		flowQueryParameters.put("taskClause", taskFilterString);
		flowQueryParameters.put("PhaseNo",FlowHelper.getFlowPhase(flowType,phaseType));
		String olPcsFlag = this.asPage.getParameter("OlPcsFlag");//是否在途中标志
		if(StringX.isEmpty(olPcsFlag)){
			olPcsFlag = "Y";
		}
		flowQueryParameters.put("OlPcsFlag", olPcsFlag);//在途、或已终结
		
		String businessFilterString = getBusinessFilterXMLString();
		flowQueryParameters.put("businessClause", businessFilterString);
		flowQueryParameters.put("CountFlag", "Y"); 
		flowQueryParameters.put("UserID", curUser.getUserID());
		flowQueryParameters.put("OrgID", curUser.getOrgID());
		
		if("1".equals(filterFlag) && !this.filterFlag)
		{
			totalCount=0;
			return new BusinessObject[0];
		}
		
		
		flowQueryParameters.put("StartNum", String.valueOf(fromIndex));
		
		int pageSize=toIndex-fromIndex;
		flowQueryParameters.put("PageNum",  String.valueOf(pageSize)); 
		
		String className = FlowConfig.getFlowQueryType(queryType).getString("Script");//获取取数逻辑
		Class<?> c = Class.forName(className);
		IFlowData flowData = (IFlowData)c.newInstance();
		
		if(this.transaction==null) transaction = JBOFactory.getFactory().createTransaction();
		try{
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager fo = f.getManager("jbo.flow.FLOW_OBJECT");
			transaction.join(fo);
			
			Map<String,Object> response=  flowData.getData(flowQueryParameters,BusinessObjectManager.createBusinessObjectManager(this.transaction));//待修改
			transaction.commit();
			if(response == null){
				ARE.getLog().warn("查询类型【"+queryType+"】用户编号【"+this.curUser.getUserID()+"】，未取到流程任务！");
				totalCount=0;
				return null;
			}
			else{
				totalCount=Integer.parseInt((String)response.get("Count"));
				this.flowTaskList=(List<BusinessObject>)response.get("Result");
				BusinessObject[] businessObjectArray = new BusinessObject[flowTaskList.size()];
				for(int i=0;i<flowTaskList.size();i++){
					businessObjectArray[i]=BusinessObject.createBusinessObject(bizClass);
					for(int j=0; j < this.asDataObject.Columns.size(); j ++)
					{
						String colname = this.asDataObject.getColumn(j).getAttribute("ColName");
						if(colname.indexOf(".") > -1)
							businessObjectArray[i].setAttributeValue(colname,flowTaskList.get(i).getObject(colname.substring(colname.indexOf(".")+1)));
						else
							businessObjectArray[i].setAttributeValue(colname,flowTaskList.get(i).getObject(colname));
					}
				}
				return businessObjectArray;
			}
		}
		catch(Exception e){
			if(transaction!=null){
				transaction.rollback();
			}
			throw e;
		}
	}

	@Override
	public int getTotalCount() throws Exception {
		return totalCount;
	}
}
