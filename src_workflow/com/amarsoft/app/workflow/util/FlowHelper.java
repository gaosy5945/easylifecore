/**
 * 该类提供流程相关所有的对外服务
 */
package com.amarsoft.app.workflow.util;


import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.jdom.Element;
import org.jdom.output.XMLOutputter;

import com.amarsoft.amarscript.Any;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.AmarScriptHelper;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.interdata.IData;
import com.amarsoft.app.workflow.processdata.IProcess;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;

public class FlowHelper {
	
	public static final String FLOWSTATE_RUNNING="1";//运行
	public static final String FLOWSTATE_FININSHED="2";//完成
	public static final String FLOWSTATE_ARTIFICIALEND="3";//人工终止
	
	public static final String TASKSTATE_AVY="0";//可办-任务池中
	public static final String TASKSTATE_RUNNING="1";//待办
	public static final String TASKSTATE_HANDUP="2";//挂起
	public static final String TASKSTATE_FININSHED="3";//完成
	public static final String TASKSTATE_ARTIFICIALEND="4";//人工终止
	
	/**
	 * 通过流程参数配置和业务对象计算变量值
	 * @param paraList 流程输出参数定于列表
	 * @param boList 数据对象列表
	 * @param otherPara 其他补充参数
	 * @return 
	 * @throws Exception
	 */
	public static BusinessObject getContext(List<BusinessObject> paraList,List<BusinessObject> boList,BusinessObject context,BusinessObjectManager bomanager) throws Exception{
		if(paraList != null)
		{
			for(BusinessObject para:paraList)
			{
				String dataType = para.getString("DataType");
				String methodType = para.getString("MethodType");
				String method = para.getString("Method");
				String paraName = para.getString("ParameterName");
				
				String value = "";
				double dvalue = 0.0;
				if("Expression".equalsIgnoreCase(methodType))
				{
					String[] ss = method.split(",");
					for(String s:ss)
					{
						
						for(BusinessObject bo:boList)
						{
							String sss = s.substring(0,s.lastIndexOf("."));
							if(bo.getBizClassName().startsWith(sss))
							{
								if("1".equals(dataType)) //字符
								{
									value += bo.getString(s.substring(s.lastIndexOf(".")+1)) != null ? bo.getString(s.substring(s.lastIndexOf(".")+1)) : "";
									if((value == null || "".equals(value)) && context != null) value = context.getString(s.substring(s.lastIndexOf(".")+1));
								}
								else if("2".equals(dataType))//数字
								{
									dvalue+=bo.getDouble(s.substring(s.lastIndexOf(".")+1));
									value = String.valueOf(dvalue);
									if((value == null || "".equals(value)) && context != null) value = String.valueOf(context.getDouble(s.substring(s.lastIndexOf(".")+1)));
								}
							}
						}
					}
				}
				else if("Java".equalsIgnoreCase(methodType))
				{
					String className,classParaName;
					if(method.indexOf("(") > 0)
					{
						className = method.substring(0,method.indexOf("("));
						classParaName = method.substring(method.indexOf("(")+1).substring(0, method.substring(method.indexOf("(")+1).lastIndexOf(")"));
					}else
					{
						className = method;
						classParaName = "";
					}
					Class<?> c = Class.forName(className);
					IProcess ip = (IProcess)c.newInstance();
					value = ip.process(boList, bomanager, classParaName,dataType,context);
				}
				context.setAttributeValue(paraName, value);
			}
		}
		return context;
	}
	
	public static BusinessObject queryMultiPcsTask(
			BusinessObject taskContext, BusinessObject businessContext,
			int startNum, int pageNum, String[] states, boolean countFlag,BusinessObjectManager bomanager) throws Exception {
		BusinessObject rs = BusinessObject.createBusinessObject();
		
		List<String> values = new ArrayList<String>();
		String sql = "select FT.TASKSERIALNO,O.FLOWSERIALNO,FT.PHASENO,FT.CREATETIME,FT.BEGINTIME,FT.ENDTIME,FT.TASKSTATE,FT.USERID,FT.ORGID,FI.FLOWNO,FI.FLOWVERSION,FI.FLOWSTATE,FI.PARAMETER from jbo.flow.FLOW_TASK FT,jbo.flow.FLOW_INSTANCE FI, O where FT.FlowSerialNo=O.FlowSerialNo and FI.SerialNo=O.FlowSerialNo ";
		if(states != null && states.length > 0){
			sql+="and FT.TaskState in(''";
			for(int i = 0; i < states.length; i ++)
			{
				sql+=",:TaskState"+i;
			}
			sql+=") ";
		}
		
		sql += getSql(businessContext,values);
		sql += getSql(taskContext,values);
		
		String order ="";
		if(!StringX.isEmpty(businessContext.getString("order")))
			order += businessContext.getString("order");
		if(!StringX.isEmpty(order) && !StringX.isEmpty(taskContext.getString("order")))
			order +=",";
		if(!StringX.isEmpty(taskContext.getString("order")))
			order += taskContext.getString("order");
		if(!StringX.isEmpty(order))
			sql += " order by "+order;
		
		BizObjectManager bom = bomanager.getBizObjectManager(businessContext.getString("table"));
		BizObjectQuery boq = bom.createQuery(sql);
		for(int i = 0; i< values.size(); i ++)
		{
			boq.setParameter("value"+i, values.get(i));
		}
		
		if(states != null && states.length > 0){
			for(int i = 0; i < states.length; i ++)
			{
				boq.setParameter("TaskState"+i, states[i]);
			}
		}
		rs.appendBusinessObjects("jbo.flow.FLOW_TASK",bomanager.loadBusinessObjects(boq, startNum, startNum+pageNum));
		
		if(countFlag)
		{
			rs.setAttributeValue("TaskCount",boq.getTotalCount());
		}
		return rs;
		
	}
	
	public static BusinessObject queryMultiPcsTask(
			BusinessObject taskContext, BusinessObject businessContext,
			int startNum, int pageNum, String[] states, boolean countFlag, String userID,
			String orgID,BusinessObjectManager bomanager) throws Exception {
		BusinessObject rs = BusinessObject.createBusinessObject();
		
		List<String> values = new ArrayList<String>();
		String sql = "select FT.TASKSERIALNO,O.FLOWSERIALNO,FT.PHASENO,FT.CREATETIME,FT.BEGINTIME,FT.ENDTIME,FT.TASKSTATE,FT.USERID,FT.ORGID,FI.FLOWNO,FI.FLOWVERSION,FI.FLOWSTATE,FI.PARAMETER from jbo.flow.FLOW_TASK FT,jbo.flow.FLOW_INSTANCE FI, O where FT.FlowSerialNo=O.FlowSerialNo and FI.SerialNo=O.FlowSerialNo and FT.UserID=:UserID ";
		if(states != null && states.length > 0){
			sql+="and FT.TaskState in(''";
			for(int i = 0; i < states.length; i ++)
			{
				sql+=",:TaskState"+i;
			}
			sql+=") ";
		}
		
		sql += getSql(businessContext,values);
		sql += getSql(taskContext,values);
		
		String order ="";
		if(!StringX.isEmpty(businessContext.getString("order")))
			order += businessContext.getString("order");
		if(!StringX.isEmpty(order) && !StringX.isEmpty(taskContext.getString("order")))
			order +=",";
		if(!StringX.isEmpty(taskContext.getString("order")))
			order += taskContext.getString("order");
		if(!StringX.isEmpty(order))
			sql += " order by "+order;
		
		BizObjectManager bom = bomanager.getBizObjectManager(businessContext.getString("table"));
		BizObjectQuery boq = bom.createQuery(sql);
		for(int i = 0; i< values.size(); i ++)
		{
			boq.setParameter("value"+i, values.get(i));
		}
		
		if(states != null && states.length > 0){
			for(int i = 0; i < states.length; i ++)
			{
				boq.setParameter("TaskState"+i, states[i]);
			}
		}
		boq.setParameter("UserID", userID);
		rs.appendBusinessObjects("jbo.flow.FLOW_TASK",bomanager.loadBusinessObjects(boq, startNum, startNum+pageNum));
		
		if(countFlag)
		{
			rs.setAttributeValue("TaskCount",boq.getTotalCount());
		}
		return rs;
		
	}
	
	public static BusinessObject queryMultiPcsAvlTask(
			BusinessObject taskContext, BusinessObject businessContext,
			int startNum, int pageNum, String[] states, boolean countFlag, String userID,
			String orgID,BusinessObjectManager bomanager) throws Exception {
		BusinessObject rs = BusinessObject.createBusinessObject();
		
		List<String> values = new ArrayList<String>();
		String sql = "select FT.TASKSERIALNO,O.FLOWSERIALNO,FT.PHASENO,FT.CREATETIME,FT.BEGINTIME,FT.ENDTIME,FT.TASKSTATE,FT.USERID,FT.ORGID,FI.FLOWNO,FI.FLOWVERSION,FI.FLOWSTATE,FI.PARAMETER from jbo.flow.FLOW_TASK FT,jbo.flow.FLOW_INSTANCE FI, O where FT.FlowSerialNo=O.FlowSerialNo and FI.SerialNo=O.FlowSerialNo ";
		if(states != null && states.length > 0){
			sql+="and FT.TaskState in(''";
			for(int i = 0; i < states.length; i ++)
			{
				sql+=",:TaskState"+i;
			}
			sql+=") ";
		}
		
		sql += getSql(businessContext,values);
		sql += getSql(taskContext,values);
		
		List<BusinessObject> urs = bomanager.loadBusinessObjects("jbo.sys.USER_ROLE", "UserID=:UserID", "UserID",userID);
		String[] ls = BusinessObjectHelper.getDistinctValues(urs, "RoleID").toArray(new String[0]);
		sql+="and FT.Pool in(''";
		for(int i = 0; i < ls.length; i ++)
		{
			sql+=",:Pool"+i;
		}
		sql+=") ";
		String order ="";
		if(!StringX.isEmpty(businessContext.getString("order")))
			order += businessContext.getString("order");
		if(!StringX.isEmpty(order) && !StringX.isEmpty(taskContext.getString("order")))
			order +=",";
		if(!StringX.isEmpty(taskContext.getString("order")))
			order += taskContext.getString("order");
		if(!StringX.isEmpty(order))
			sql += " order by "+order;
		
		BizObjectManager bom = bomanager.getBizObjectManager(businessContext.getString("table"));
		BizObjectQuery boq = bom.createQuery(sql);
		for(int i = 0; i< values.size(); i ++)
		{
			boq.setParameter("value"+i, values.get(i));
		}
		
		if(states != null && states.length > 0){
			for(int i = 0; i < states.length; i ++)
			{
				boq.setParameter("TaskState"+i, states[i]);
			}
		}
		
		
		for(int i = 0; i < ls.length; i ++)
		{
			boq.setParameter("Pool"+i, ls[i]+"$"+orgID);
		}
		
		rs.appendBusinessObjects("jbo.flow.FLOW_TASK",bomanager.loadBusinessObjects(boq, startNum, startNum+pageNum));
		
		if(countFlag)
		{
			rs.setAttributeValue("TaskCount",boq.getTotalCount());
		}
		return rs;
		
	}
	
	private static String getSql(BusinessObject context,List<String> values) throws Exception{
		int n = values.size();
		String sql = "";
		BusinessObject where = context.getBusinessObject("where");
		if(where == null) return sql;
		List<BusinessObject> ands = where.getBusinessObjects("and");
		if(!ands.isEmpty()) sql+=" and ( 1=1 ";
		for(int i = 0 ; i < ands.size(); i ++){
			BusinessObject and = ands.get(i);
			List<BusinessObject> exprs = and.getBusinessObjects("expr");
			for(BusinessObject expr:exprs){
				String str=" and ";
				String field = expr.getString("field").trim();
				String op = expr.getString("op");
				if(op.equalsIgnoreCase("eq"))
				{
					str += field +" = :value"+(n++);
					values.add(expr.getString("value"));
				}else if(op.equalsIgnoreCase("like"))
				{
					str += field +" like :value"+(n++);
					values.add(expr.getString("value"));
				}else if(op.equalsIgnoreCase("between"))
				{
					str += field +" between :value"+(n++);
					values.add(expr.getString("value"));
					str += " and :value"+(n++);
					values.add(expr.getString("value"));
				}else if(op.equalsIgnoreCase("in"))
				{
					List<BusinessObject> vs = expr.getBusinessObjects("value");
					str += field +" in(";
					for(BusinessObject v:vs)
					{
						str+=":value"+(n++)+",";
						values.add(v.getString("value"));
					}
					str = str.substring(0, str.length()-1)+")";
					
					if(vs.isEmpty()) str = " and "+field +" in('') ";
				}
				
				sql += str;
			}
			if(!StringX.isEmpty(sql) && i != ands.size()-1)
				sql = sql+" or ";
		}
		if(!StringX.isEmpty(sql))
		{
			sql+=" )";
		}
		
		return sql;
	}
	
	
	public static List<BusinessObject> QueryObjectFromMessage(List<BusinessObject> imessage,BusinessObjectManager bomanager) throws Exception
	{
		if(imessage == null) return new ArrayList<BusinessObject>();
		//取Message中流程实例编号
		List<String> pcsInstanceIDs = new ArrayList<String>();
		pcsInstanceIDs.add("");
		List<BusinessObject> results = imessage;
		List<BusinessObject> remove = new ArrayList<BusinessObject>();
		for(BusinessObject i:imessage)
		{
			pcsInstanceIDs.add(i.getString("FlowSerialNo"));
		}
		List<BusinessObject> returnBos = new ArrayList<BusinessObject>();
		List<BusinessObject> fos = bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", "select distinct ObjectType from O where FlowSerialNo in(:FlowSerialNo)", "FlowSerialNo", pcsInstanceIDs.toArray(new String[0]));
		for(BusinessObject fo:fos)
		{
			
			String className = FlowConfig.getFlowObjectType(fo.getString("ObjectType")).getString("Script");//获取取数逻辑
			Class<?> c = Class.forName(className);
			IData data = (IData)c.newInstance();
			List<BusinessObject> boList = data.getFlowObjects(fo.getString("ObjectType"), bomanager, "FlowSerialNo", pcsInstanceIDs.toArray(new String[0]));
			
			List<BusinessObject> bos = new ArrayList<BusinessObject>();
			
			for(BusinessObject res:results)
			{
				for(BusinessObject bo:boList)
				{
					if(res.getString("FlowSerialNo").equals(bo.getString("FlowSerialNo")))
					{
						if(bos.contains(res)){
							BusinessObject resTmp = BusinessObject.createBusinessObject();
							resTmp.setAttributesValue(res);
							res = resTmp;
						}
						res.setAttributes(bo);
						if(res.getString("PhaseNo") != null && !"".equals(res.getString("PhaseNo")))
						{
							String phasenos =  res.getString("PhaseNo");
							boolean flag = false;
							for(String phaseno:phasenos.split(","))
							{	
								BusinessObject flowmodel = FlowConfig.getFlowPhase(res.getString("FlowNo"), res.getString("FlowVersion"),phaseno);
							
								if(flowmodel != null)
								{
									res.setAttributeValue("FunctionID",flowmodel.getString("FunctionID"));
									flag = true;
									res.setAttributeValue("PhaseNo",phaseno);
								}
							}
							
							if(!flag)
								remove.add(res);
							
						}
						data.transfer(res);
						bos.add(res);
					}
				}
			}
			
			bos = data.group(bos);
			
			returnBos.addAll(bos);
		}
		results.removeAll(remove);
		
		List<BusinessObject> sortBoList = new ArrayList<BusinessObject>();
		for(BusinessObject i:results)
		{
			for(BusinessObject bo:returnBos)
			{
				if(bo.getString("FlowSerialNo").equals(i.getString("FlowSerialNo")))
				{
					//functionID 处理
					String functionID = bo.getString("FunctionID");
					if(functionID != null && !"".equals(functionID) && (functionID.indexOf("'") >-1 || functionID.indexOf("\"") > -1 || functionID.indexOf("(") > -1))
					{
						functionID = StringHelper.replaceString(functionID,bo);
						functionID = StringHelper.replaceToSpace(functionID);
						Any a=AmarScriptHelper.getScriptValue(functionID, BusinessObjectManager.createBusinessObjectManager());
						functionID = a.toStringValue();
						bo.setAttributeValue("FunctionID", functionID);
					}
					sortBoList.add(bo);
					break;
				}
			}
		}
		
		return sortBoList;
	}
	
	/**
	 * 流程业务查询条件获取方法
	 * @param flowNos
	 * @param filters
	 * @return
	 * @throws Exception
	 */
	public static String getBusinessFilter(String flowTypes,String queryType,List<String[]> filters) throws Exception
	{
		if(flowTypes ==  null || "".equals(flowTypes)) return "";
		
		String tableName = "";
		String orderFields = "";
		for(String flowType:flowTypes.split(","))
		{
			List<BusinessObject> flowCatalogs = FlowConfig.getFlowCatalog(flowType);
			for(BusinessObject flowCatalog:flowCatalogs)
			{
				if(tableName == null || "".equals(tableName))
					tableName = flowCatalog.getString("BusinessTable");
				
				if(tableName != null && !tableName.equals(flowCatalog.getString("BusinessTable"))) throw new Exception("传入的流程定义名称必须采用同一业务信息，请检查！");
			}
			
			BusinessObject item = FlowConfig.getFlowType(flowType);
			if(item != null)
			{
				
				if("01".equals(queryType))//可办任务 - 任务池中
				{
					orderFields = item.getString("AvlBusinessOrderCondition");
				}else if("02".equals(queryType)) //待办任务
				{
					orderFields = item.getString("TodoBusinessOrder");
				}else if("03".equals(queryType)) //已处理任务
				{
					orderFields = item.getString("FinishBusinessOrderCondition");
				}
			}
		}
		
		if(tableName == null || "".equals(tableName)) return "";
		
		Element root =new Element("criteria");
		Element tableElement =new Element("table");
		tableElement.setText(tableName);
		root.addContent(tableElement);
		
		Element whereElement =new Element("where");
		whereElement.setAttribute("id", "1");
		root.addContent(whereElement);
		if(filters != null && !filters.isEmpty())
		{
			Element andElement =new Element("and");
			andElement.setAttribute("id", "1");
			whereElement.addContent(andElement);
			for(String[] filter:filters)
			{
				Element exprElement =new Element("expr");
				exprElement.setAttribute("id", "1");
				Element fieldElement =new Element("field");
				fieldElement.setText(filter[0].toUpperCase());
				exprElement.addContent(fieldElement);
				
				Element opElement =new Element("op");
				opElement.setText(filter[1]);
				exprElement.addContent(opElement);
				
				Element valueElement =new Element("value");
				valueElement.setText(filter[2]);
				exprElement.addContent(valueElement);
			}
		}
		Element orderElement =new Element("order");
		orderElement.setText(orderFields);
		root.addContent(orderElement);
		
		XMLOutputter out = new XMLOutputter();
		String xml = "<?xml version=\"1.0\" encoding=\""+ARE.getProperty("CharSet","GBK")+"\"?>"+out.outputString(root);
		return xml;
	}
	
	
	public static String getFlowFilter(String flowTypes,String queryType,String phaseTypes) throws Exception
	{
		if(flowTypes ==  null || "".equals(flowTypes) ||
				phaseTypes == null || "".equals(phaseTypes)) return "";
		//流程定义名称条件
		StringBuffer sb = new StringBuffer();
		sb.append("<criteria><where><and><expr><field>flowNo</field><op>in</op>");
		
		Element root =new Element("criteria");
		
		Element whereElement =new Element("where");
		whereElement.setAttribute("id", "1");
		root.addContent(whereElement);
		
		Element andElement =new Element("and");
		andElement.setAttribute("id", "1");
		whereElement.addContent(andElement);
		
		Element exprElement =new Element("expr");
		exprElement.setAttribute("id", "1");
		andElement.addContent(exprElement);
		
		Element fieldElement =new Element("field");
		fieldElement.setText("FI.flowNo");
		exprElement.addContent(fieldElement);
		
		Element opElement =new Element("op");
		opElement.setText("in");
		exprElement.addContent(opElement);
		
		
		Element expr2Element =new Element("expr");
		expr2Element.setAttribute("id", "1");
		
		Element field2Element =new Element("field");
		field2Element.setText("FT.phaseNo");
		expr2Element.addContent(field2Element);
		
		Element op2Element =new Element("op");
		op2Element.setText("in");
		expr2Element.addContent(op2Element);
		
		StringBuffer phasesb = new StringBuffer();
		String orderFields = "";
		for(String flowType:flowTypes.split(","))
		{
			List<BusinessObject> flowCatalogs = FlowConfig.getFlowCatalog(flowType);
			for(BusinessObject flowCatalog:flowCatalogs)
			{
				
				Element valueElement =new Element("value");
				valueElement.setText(flowCatalog.getString("FlowNo"));
				exprElement.addContent(valueElement);
				
				List<BusinessObject> flowModels = FlowConfig.getFlowPhases(flowCatalog.getString("FlowNo"));
				if(flowModels == null || flowModels.isEmpty()) continue;
				
				for(BusinessObject flowModel:flowModels)
				{
					for(String phaseType:phaseTypes.split(","))
					{
						if(phaseType.equals(flowModel.getString("PhaseType")) && phasesb.indexOf("<value>"+flowModel.getString("PhaseNo")+"</value>") == -1)
						{
							Element value2Element =new Element("value");
							value2Element.setText(flowModel.getString("PhaseNo"));
							expr2Element.addContent(value2Element);
							phasesb.append("<value>");
							phasesb.append(flowModel.getString("PhaseNo"));
							phasesb.append("</value>");
						}
					}
				}
				
				Element value2Element =new Element("value");
				value2Element.setText(" ");
				expr2Element.addContent(value2Element);
				Element value3Element =new Element("value");
				value3Element.setText(" ");
				exprElement.addContent(value3Element);
			}
			
			BusinessObject item =FlowConfig.getFlowType(flowType);
			if(item != null)
			{
				
				if("01".equals(queryType))//可办任务 - 任务池中
				{
					orderFields = item.getString("AvlFlowOrderCondition");
				}else if("02".equals(queryType)) //待办任务
				{
					orderFields = item.getString("TodoFlowOrderCondition");
				}else if("03".equals(queryType)) //已处理任务
				{
					orderFields = item.getString("FinishFlowOrderCondition");
				}
			}
		}
		
		if(!"ALL".equalsIgnoreCase(phaseTypes))
			andElement.addContent(expr2Element);
		
		Element orderElement =new Element("order");
		orderElement.setText(orderFields);
		root.addContent(orderElement);
		
		XMLOutputter out = new XMLOutputter();
		String xml = "<?xml version=\"1.0\" encoding=\""+ARE.getProperty("CharSet","GBK")+"\"?>"+out.outputString(root);
		return xml;
	}
	
	public static String getFlowPhase(String flowTypes,String phaseTypes) throws Exception
	{
		if(flowTypes ==  null || "".equals(flowTypes) ||
				phaseTypes == null || "".equals(phaseTypes)) return "";
		StringBuffer sb = new StringBuffer();
		for(String flowType:flowTypes.split(","))
		{
			List<BusinessObject> flowCatalogs = FlowConfig.getFlowCatalog(flowType);
			for(BusinessObject flowCatalog:flowCatalogs)
			{
				List<BusinessObject> flowModels = FlowConfig.getFlowPhases(flowCatalog.getString("FlowNo"));
				if(flowModels == null || flowModels.isEmpty()) continue;
				
				for(BusinessObject flowModel:flowModels)
				{
					for(String phaseType:phaseTypes.split(","))
					{
						if(phaseType.equals(flowModel.getString("PhaseType")))
						{
							sb.append(flowModel.getString("PhaseNo")+",");
						}
					}
				}
			}
			
		}
		
		return sb.toString();
	}
	
	
	/**
	 * 表达式解析
	 * @param preScript 多个类已逗号分隔
	 * @param bo
	 * @param otherPara
	 * @param tx
	 * @throws Exception
	 */
	public static void ExecuteScript(String scripts,BusinessObject bo,BusinessObject otherPara,JBOTransaction tx) throws Exception
	{
		if(scripts == null) return;
		String[] scriptArray = scripts.split(";");
		for(String script:scriptArray)
		{
			String args = script.substring(script.indexOf("(")+1);
			args = args.substring(0, args.lastIndexOf(")"));
			String classMethodName = script.substring(0, script.indexOf("("));
			String className = classMethodName.substring(0, script.lastIndexOf("."));
			String methodName = classMethodName.substring(script.lastIndexOf(".")+1);
			
			Class<?> c = Class.forName(className);
			Object object = c.newInstance();
			
			
			String[] argArray = args.split(",");
			for(String arg:argArray)
			{
				String argName,argValue;
				if(arg.indexOf("=") > -1)
				{
					argName = arg.split("=")[0];
					argValue = arg.split("=")[1];
					if(argValue.indexOf("${") > -1)
					{
						String value = bo.getString(argValue.substring(argValue.indexOf("${")+2, argValue.lastIndexOf("}")));
						if(value == null || "".equals(value))
							value = otherPara.getString(argValue.substring(argValue.indexOf("${")+2, argValue.lastIndexOf("}")));
						argValue = value;
					}
				}
				else
				{
					argName = arg.substring(arg.indexOf("${")+2, arg.lastIndexOf("}"));
					argValue = arg;
					if(argValue.indexOf("${") > -1)
					{
						String value = bo.getString(arg.substring(arg.indexOf("${")+2, arg.lastIndexOf("}")));
						if(value == null || "".equals(value))
							value = otherPara.getString(arg.substring(arg.indexOf("${")+2, arg.lastIndexOf("}")));
						argValue = value;
					}
				}
				
				String method = "set" + argName.substring(0, 1).toUpperCase() + argName.substring(1);
				
				Method m = c.getMethod(method, new Class[] { String.class });
				m.invoke(object, new Object[] { argValue });
			}
			
			Method m = c.getMethod(methodName, new Class[] { JBOTransaction.class });
			m.invoke(object, new Object[] { tx });
		}
	}
	
	
	//从一个流程节点向下查找，并将未结束的流程节点结束
	public static List<BusinessObject> endTask(String taskSerialNo,List<BusinessObject> fts,List<BusinessObject> frs,BusinessObjectManager bomanager) throws Exception{
		List<BusinessObject> ets = new ArrayList<BusinessObject>();
		List<BusinessObject> tmps = BusinessObjectHelper.getBusinessObjectsByAttributes(frs, "TaskSerialNo",taskSerialNo);
		for(BusinessObject tmp:tmps)
		{
			BusinessObject tmpt = BusinessObjectHelper.getBusinessObjectByAttributes(fts, "TaskSerialNo",tmp.getString("NextTaskSerialNo"));
			if(!FlowHelper.TASKSTATE_FININSHED.equals(tmpt.getString("TaskState")))
			{
				tmpt.setAttributeValue("EndTime", DateHelper.getBusinessDate()+" "+DateX.format(new Date(),DateHelper.AMR_NOMAL_FULLTIME_FORMAT));
				tmpt.setAttributeValue("TaskState", FlowHelper.TASKSTATE_FININSHED);
				ets.add(tmpt);
				bomanager.updateBusinessObject(tmpt);
			}
			ets.addAll(endTask(tmp.getString("NextTaskSerialNo"),fts,frs,bomanager));
		}
		return ets;
	}
	
	
	//从一个流程节点向下查找，并删除这些任务
	public static String deleteTask(String taskSerialNo,List<BusinessObject> frs,BusinessObjectManager bomanager) throws Exception{
		BizObjectManager bom = bomanager.getBizObjectManager("jbo.flow.FLOW_TASK");
		List<BusinessObject> tmps = BusinessObjectHelper.getBusinessObjectsByAttributes(frs, "TaskSerialNo",taskSerialNo);
		for(BusinessObject tmp:tmps)
		{
			int r = bom.createQuery("delete from O where TaskSerialNo = :TaskSerialNo and TaskState in(:TaskState1,:TaskState2,:TaskState3) ")
					.setParameter("TaskSerialNo", tmp.getString("NextTaskSerialNo"))
					.setParameter("TaskState1", FlowHelper.TASKSTATE_AVY)
					.setParameter("TaskState2", FlowHelper.TASKSTATE_HANDUP)
					.setParameter("TaskState3", FlowHelper.TASKSTATE_RUNNING)
					.executeUpdate();
			BizObjectManager brm = bomanager.getBizObjectManager("jbo.flow.FLOW_RELATIVE");
			brm.createQuery("delete from O where TaskSerialNo=:TaskSerialNo")
			.setParameter("TaskSerialNo", tmp.getString("NextTaskSerialNo"))
			.executeUpdate();
			
			brm.createQuery("delete from O where NextTaskSerialNo=:NextTaskSerialNo")
			.setParameter("NextTaskSerialNo", tmp.getString("NextTaskSerialNo"))
			.executeUpdate();
			
			if(r <= 0)
			{
				bomanager.rollback();
				return "false@该任务后续节点【"+tmp.getString("NextTaskSerialNo")+"】已处理不能收回。";
			}
			
			String s = deleteTask(tmp.getString("NextTaskSerialNo"),frs,bomanager);
			if(s.startsWith("false")) return s;
		}
		return "true@该任务向下业务已删除成功。";
	}
	

	/**
	 *  判断用户是否有审批权限，返回 true 有权限 false 没有权限
	 * @param authType 0 User; 1 Org
	 * @param userID
	 * @param boList
	 * @param conn
	 * @return
	 * @throws Exception
	 */
	public static boolean ApproveAuth(String authType,String authObjectNo,List<BusinessObject> boList,String approveModel,BusinessObjectManager bomanager) throws Exception
	{
		if(boList == null || boList.isEmpty()) return false;
		
		boolean flag = true;
		PreparedStatement psci = null,psar = null,psba = null,psbc = null,psbp = null,psbd=null;
		Connection conn = bomanager.getConnection();
		try
		{
			psci = conn.prepareStatement("select CustomerGrade from IND_INFO where CustomerID=? ");
			//授权人员检查
			String sql = "";
			if("0".equals(authType))
			{
				sql="select FAO.CSTCREDITBALANCE,FAR.BusinessType,FAR.VouchType,FAO.AUTHOBJECTNO from FLOW_AUTHORIZE FA,"
			       	 +" FLOW_AUTHORIZE_RULE   FAR,"
			       	 +" FLOW_AUTHORIZE_OBJECT FAO "
			       	 +" where FA.SerialNo = FAR.AUTHSERIALNO "
			       	 +" and FA.SERIALNO = FAO.AUTHSERIALNO "
			       	 +" and FAO.AUTHOBJECTTYPE='jbo.sys.USER_INFO' "
			       	 +" and FAO.AUTHOBJECTNO = ? "
			       	 +" and FA.EFFECTIVEDATE <= ? "
			       	 +" and FA.EXPIRYDATE >= ? "
			       	 +" and FAR.CUSTOMERGRADE like ? "
			       	 +" and FAR.CUSTOMERTYPE like ? "
			       	 +" and FAR.BUSINESSTYPE like ? "
			       	 +" and FAR.VOUCHTYPE like ? "
			       	 +" and FAR.EXCEPTREASON like ? "
			       	 +" and FAO.APPROVEMODEL = ? ";
			}else if("1".equals(authType))
			{
				sql="select FAO.CSTCREDITBALANCE,FAR.BusinessType,FAR.VouchType,FAO.AUTHOBJECTNO from FLOW_AUTHORIZE FA,"
				       	 +" FLOW_AUTHORIZE_RULE   FAR,"
				       	 +" FLOW_AUTHORIZE_OBJECT FAO "
				       	 +" where FA.SerialNo = FAR.AUTHSERIALNO "
				       	 +" and FA.SERIALNO = FAO.AUTHSERIALNO "
				       	 +" and FAO.AUTHOBJECTTYPE='jbo.sys.USER_INFO' "
				       	 +" and FAO.AUTHOBJECTNO in(select UserID from USER_INFO where BelongOrg=?) "
				       	 +" and FA.EFFECTIVEDATE <= ? "
				       	 +" and FA.EXPIRYDATE >= ? "
				       	 +" and FAR.CUSTOMERGRADE like ? "
				       	 +" and FAR.CUSTOMERTYPE like ? "
				       	 +" and FAR.BUSINESSTYPE like ? "
				       	 +" and FAR.VOUCHTYPE like ? "
				       	 +" and FAR.EXCEPTREASON like ? "
				       	 +" and FAO.APPROVEMODEL = ? ";
			}
		
			psar = conn.prepareStatement(sql);
			
			sql = " select sum(case when ? like '%' || BA.Businesstype || '%' and ? like '%' || BA.VOUCHTYPE || '%' then "
				  +" (case when BA.ApproveStatus in('01','02') and BA.OccurType = '0010' then "
			      +"    (select BusinessSum from BUSINESS_APPROVE where SerialNo in (select max(SerialNo) from BUSINESS_APPROVE where ApplySerialNo = BA.SerialNo)) "
			      +"  else "
			      +"     0 "
			      +"  end) "
			      +" else "
			      +"  0 "
			      +" end) as balance "
			      +" from BUSINESS_APPLY BA"
			      +" where CustomerID = ? ";
			psba = conn.prepareStatement(sql);
			
			sql = " select sum(case when ? like '%'||BC.Businesstype||'%' and ? like '%'||BC.VOUCHTYPE||'%' then "
				  +" (case "
				  +" when BC.OccurType <> '0010' then "
				  +" 	Balance "
				  +" when BC.Contractstatus in('01','02','03') and BC.Revolveflag = '1' and BC.MATURITYDATE >= ? then "
				  +" 	BC.BusinessSum "
				  +" when BC.Contractstatus in('01','02','03') and BC.Revolveflag = '1' and BC.MATURITYDATE < ? then "
				  +" 	Balance "
				  +" when BC.Contractstatus in('01','02') then "
				  +" 	BusinessSum "
				  +" when BC.CONTRACTSTATUS = '03' then "
				  +" 	Balance "
				  +" else "
				  +" 	0 "
				  +" end) "
				  +" else "
				  +" 	0 "
				  +" end) as balance "
				  +" from BUSINESS_CONTRACT BC "
				  +" where CustomerID = ? ";
			psbc = conn.prepareStatement(sql);
			
			sql = " select sum(case when ? like '%'||BP.Businesstype||'%' and ? like '%'||Bc.VOUCHTYPE||'%' then "
					  +" (case "
					  +" when BP.PutOutStatus in('01','02','03') then "
					  +" 	BP.BusinessSum "
					  +" else "
					  + "	0 "
					  +" end)"
					  +" else "
					  +" 	0 "
					  +" end) as balance "
					  +" from BUSINESS_CONTRACT BC,BUSINESS_PUTOUT BP "
					  +" where BC.SerialNo = BP.ContractSerialNo and BC.CustomerID = ? and BC.BusinessType in('555','999') ";
			psbp = conn.prepareStatement(sql);
			
			sql = " select sum(case when ? like '%'||BD.Businesstype||'%' and ? like '%'||BC.VOUCHTYPE||'%' then "
					  +" 	BD.Balance "
					  +" else "
					  +" 	0 "
					  +" end) as balance "
					  +" from BUSINESS_CONTRACT BC,BUSINESS_DUEBILL BD "
					  +" where BC.SerialNo = BD.ContractSerialNo and BC.CustomerID = ? and BC.BusinessType in('555','999') ";
			
			psbd = conn.prepareStatement(sql);
			
			for(BusinessObject bo:boList)
			{
				String customerID = bo.getString("CustomerID");
				String customerGrade = "";
				
				//查询客户服务等级
				psci.setString(1, customerID);
				ResultSet rsci = psci.executeQuery();
				if(rsci.next())
				{
					customerGrade = rsci.getString(1);
				}
				rsci.close();
				
				String customerType = bo.getString("CustomerType");
				String businessType = bo.getString("BusinessType");
				String vouchType = bo.getString("VouchType");
				String occurType = bo.getString("OccurType");
				String currency = bo.getString("BusinessCurrency");
				double businessSum = bo.getDouble("BusinessSum");
				String exceptReason = bo.getString("ExceptReason");
				if(exceptReason == null) exceptReason = "";
				
				
				psar.setString(1, authObjectNo);
				psar.setString(2, DateHelper.getBusinessDate());
				psar.setString(3, DateHelper.getBusinessDate());
				psar.setString(4, "%"+customerGrade+"%");
				psar.setString(5, "%"+customerType+"%");
				psar.setString(6, "%"+businessType+"%");
				psar.setString(7, "%"+vouchType+"%");
				psar.setString(8, "%"+exceptReason+"%");
				psar.setString(9, approveModel);
				
				ResultSet rs = psar.executeQuery();
				boolean singleFlag = false;
				while(rs.next())
				{
					double cstCreditBalance = rs.getDouble("CSTCREDITBALANCE");
					String businessTypes = rs.getString("BusinessType");
					String vouchTypes = rs.getString("VouchType");
					
					psba.setString(1, businessTypes);
					psba.setString(2, vouchTypes);
					psba.setString(3, customerID);
					ResultSet rsba = psba.executeQuery();
					double creditBalance = 0.0;
					if(rsba.next())
					{
						creditBalance+=rsba.getDouble(1);
					}
					rsba.close();
					
					psbc.setString(1, businessTypes);
					psbc.setString(2, vouchTypes);
					psbc.setString(3, DateHelper.getBusinessDate());
					psbc.setString(4, DateHelper.getBusinessDate());
					psbc.setString(5, customerID);
					ResultSet rsbc = psbc.executeQuery();
					if(rsbc.next())
					{
						creditBalance+=rsbc.getDouble(1);
					}
					rsbc.close();
					
					psbp.setString(1, businessTypes);
					psbp.setString(2, vouchTypes);
					psbp.setString(3, customerID);
					ResultSet rsbp = psbp.executeQuery();
					if(rsbp.next())
					{
						creditBalance+=rsbp.getDouble(1);
					}
					rsbp.close();
					
					psbd.setString(1, businessTypes);
					psbd.setString(2, vouchTypes);
					psbd.setString(3, customerID);
					ResultSet rsbd = psbd.executeQuery();
					if(rsbd.next())
					{
						creditBalance+=rsbd.getDouble(1);
					}
					rsbd.close();
					
					ARE.getLog().trace("客户【"+customerID+"】【"+rs.getString("AUTHOBJECTNO")+"】,客户额度【"+creditBalance+"】,权限额度【"+cstCreditBalance+"】。");
					if(creditBalance <= cstCreditBalance)
					{
						singleFlag = true;
						break;
					}
					
				}
				rs.close();
				
				flag = flag && singleFlag;
			}
		}catch(Exception ex)
		{
			throw ex;
		}finally
		{
			if(psci != null)psci.close();
			if(psar != null)psar.close();
			if(psba != null)psba.close();
			if(psbc != null)psbc.close();
			if(psbp != null)psbp.close();
			if(psbd != null)psbd.close();
		}
		return flag;
	}
	
	/**
	 * 获取业务使用影像流程和非影像流程标志
	 * 1 影像流程 0  非影像流
	 * @param bo
	 * @return
	 * @throws Exception
	 */
	public static String getImageFlag(BusinessObject bo) throws Exception
	{
		//获取业务对应主流程，判断主流程是否是影像
		String flowNo =  ProductAnalysisFunctions.getComponentDefaultValue(bo, "PRD04-02", "CreditApproveFlowNo","0010", "01");
		if(flowNo == null || "".equals(flowNo)) return "0";
		
		List<BusinessObject> fms = FlowConfig.getFlowPhases(flowNo);
		if(fms==null) return "0";
		for(BusinessObject fm:fms)
		{
			if("0020".equals(fm.getString("PhaseType")))
			{
				return "1";
			}
		}
		return "0";
	}
	
	public static String getImageFlagforStatis(String objectType,String objectNo) throws Exception
	{
		//先加载申请信息
		BusinessObjectManager bam = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject bo = bam.keyLoadBusinessObject(objectType, objectNo);
		if(bo != null)
		{
			return FlowHelper.getImageFlag(bo);
		}
		return "0";
	}
	
	public static String getFlowCodeTable(String flowTypes) throws Exception{
		String result="";
		for(String flowType:flowTypes.split(",")){
			List<BusinessObject> fcs = FlowConfig.getFlowCatalog(flowType);
			for(BusinessObject fc:fcs){
				result += fc.getString("FlowNo")+",";
				result += fc.getString("FlowName")+",";
			}
		}
		
		if(!StringX.isEmpty(result)) return result.substring(0, result.length()-1);
		else return result;
	}
}


