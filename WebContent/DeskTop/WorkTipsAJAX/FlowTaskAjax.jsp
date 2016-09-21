<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObjectManager"%>
<%@page import="com.amarsoft.app.workflow.exterdata.IFlowData" %>
<%@page import="com.amarsoft.app.workflow.util.FlowHelper"%>
<%@page import="com.amarsoft.app.workflow.web.FlowTaskBusinessProcessor"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%

	/*
	Author:  xjzhao 2014/01/16
	Tester:
	Content: 工作台待处理任务提醒
	Input Param:		
	Output param:		                
	History Log: 		                 
	*/
	
	//点击鼠标
	String flag = DataConvert.toString(CurPage.getParameter("Flag"));
	String flowType = DataConvert.toString(CurPage.getParameter("FlowType"));//流程类型
	String phaseType = DataConvert.toString(CurPage.getParameter("PhaseType"));//阶段类型，支持多个
	String queryType = DataConvert.toString(CurPage.getParameter("QueryType"));//查询类型
	String OlPcsFlag = DataConvert.toString(CurPage.getParameter("OlPcsFlag"));//是否在途中标志
	String showFields = DataConvert.toString(CurPage.getParameter("ShowFields"));//展示字段
	String displayName = DataConvert.toString(CurPage.getParameter("DisplayName"));//显示名称
	String functionID = DataConvert.toString(CurPage.getParameter("FunctionID"));//显示名称
	if("".equals(OlPcsFlag)){
		OlPcsFlag = "Y";
	}
	//zpli
	Map<String,String> flowQueryParameters = new HashMap<String,String>();
	flowQueryParameters.put("UserID", CurUser.getUserID());
	flowQueryParameters.put("PhaseNo",FlowHelper.getFlowPhase(flowType,phaseType));
	flowQueryParameters.put("CountFlag", "Y"); 
	flowQueryParameters.put("OrgID", CurUser.getOrgID());
	flowQueryParameters.put("StartNum", "0");
	flowQueryParameters.put("PageNum",  "1"); 
	
	String className = com.amarsoft.app.workflow.config.FlowConfig.getFlowQueryType(queryType).getString("Script");//获取取数逻辑
	Class<?> c = Class.forName(className);
	IFlowData flowData = (IFlowData)c.newInstance();
	JBOTransaction tx = Sqlca;
	flowQueryParameters.put("businessClause", FlowHelper.getBusinessFilter(flowType, queryType, null));
	flowQueryParameters.put("taskClause", FlowHelper.getFlowFilter(flowType,queryType, phaseType));
	Map<String,Object> oo = flowData.getData(flowQueryParameters,BusinessObjectManager.createBusinessObjectManager(tx));
	
	className = com.amarsoft.app.workflow.config.FlowConfig.getFlowQueryType("01").getString("Script");//获取取数逻辑
	c = Class.forName(className);
	flowData = (IFlowData)c.newInstance();
	tx = Sqlca;
	flowQueryParameters.put("businessClause", FlowHelper.getBusinessFilter(flowType, "01", null));
	flowQueryParameters.put("taskClause", FlowHelper.getFlowFilter(flowType,"01", phaseType));
	Map<String,Object> kb = flowData.getData(flowQueryParameters,BusinessObjectManager.createBusinessObjectManager(tx));
	int count = Integer.parseInt((String)oo.get("Count"));
	int kbCount = Integer.parseInt((String)kb.get("Count"));
	List<BusinessObject> ls = (List<BusinessObject>)oo.get("Result");
	if("0".equals(flag))
	{
		out.println(count+"@"+kbCount);
	}
	else if("1".equals(flag))
	{
		%>
		<table>
		<%
		for(BusinessObject l:ls){
			String showValue = "";
			if(showFields != null)
			{
				String[] fieldArray = showFields.split(",");
				for(String field:fieldArray)
				{
					showValue += l.getString(field)+",";
				}
			}
			
			if(showValue.length() > 1)
			{
				showValue = showValue.substring(0, showValue.length()-1);
			}
			
			String subFunctionID = l.getString("FunctionID");
			String phaseNo = l.getString("PhaseNo");
			String taskSerialNo = l.getString("TaskSerialNo");
			String flowSerialNo = l.getString("FlowSerialNo");
			%>
	   		<tr>
				<td align="left" >
					<a href='javascript:AsCredit.openFunction("<%=subFunctionID%>","TaskSerialNo=<%=taskSerialNo%>&FlowSerialNo=<%=flowSerialNo%>&PhaseNo=<%=phaseNo%>","");' ><%=showValue%>&nbsp;</a>
				</td>
				<td align="right" valign="bottom">&nbsp;</td>
			</tr>
			<%
			
		}
		%>
			</table>
		<%
	}
	%>
<%@ include file="/IncludeEndAJAX.jsp"%>