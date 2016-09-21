<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.config.impl.*"%>
<%@page import="com.amarsoft.app.base.businessobject.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@include file="/IncludeBegin.jsp"%> 
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	//获得组件参数	
	String phaseNo = CurPage.getParameter("PhaseNo");
	String flowSerialNo = CurPage.getParameter("FlowSerialNo");
	String flowNo = Sqlca.getString(new SqlObject("select FlowNo from flow_instance where serialno = :SerialNo").setParameter("SerialNo", flowSerialNo));
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	String checkListName = CurPage.getParameter("CheckListName");

	String sRightType = (String)CurComp.getAttribute("RightType");
	if(sRightType == null) sRightType = "";
	
	if(phaseNo == null) phaseNo = "";
	if(flowNo == null) flowNo = "";
	BusinessObject checkList = CreditCheckConfig.getCheckList(flowNo, phaseNo, checkListName);
	List<BusinessObject> checkGroupList = CreditCheckConfig.getCheckGroups(checkList);
	if(checkGroupList == null || checkGroupList.size()==0 || phaseNo.equals("") || flowNo.equals("")){
		out.println("该任务阶段未配置信息核查清单数据！");
		return;
	}
	Map<String,String> parametersMap = new HashMap<String,String>();
	parametersMap.put("flowSerialNo", flowSerialNo);
	Map<String,String> checkListParameters = CreditCheckConfig.getCheckListParameters(checkList, Sqlca, parametersMap);
%>
<body class="pagebackground" style="overflow-x:scroll">
	<form name="creditCheckForm" method="post" action="<%=sWebRootPath%>/CreditManage/CreditApprove/CreditCheckSave.jsp?CompClientID=<%=CurComp.getClientID()%>" onSubmit="return pageValidate()" target="iframehide">
		<table class="list_data_tablecommon" id="ListTable" >
			<tr >
				<td valign=top>
					<div class="creditcheck_main">
						<%
							//生成界面
								int count = 0;
								for (int i = 0; i < checkGroupList.size(); i++) {
									BusinessObject checkGroup = checkGroupList.get(i);
									List<BusinessObject> checkItemList = CreditCheckConfig.getCheckNonGroupItems(checkGroup.getString("ID"));
									List<BusinessObject> scripts = checkGroup.getBusinessObjects("referscript");
						%>
						<table class="info_data_tablecommon info_group_table" width='100%'>
							<tr>
								<td style="width: 7px;">&nbsp;</td>
								<td class="info_group_backgourd_2 info_group_backgourd_3">
									<span id="imgexpand<%=checkGroup.getString("ID")%>" class="info_group_expand" onclick="ALSObjectWindowFunctions.showGroup('<%=checkGroup.getString("ID")%>')">&nbsp;</span>
								</td>
								<td class="info_group_backgourd_2" onclick="ALSObjectWindowFunctions.showGroup('<%=checkGroup.getString("ID")%>')">
									<span class="info_group_title" id="Group_<%=checkGroup.getString("ID")%>"
									style="dispaly: inline-block; float: left;"><%=checkGroup.getString("label")%></span>
								</td>
							</tr>
						</table>
						
						<table class="list_data_tablecommon" width = "80%" id="GroupBody_<%=checkGroup.getString("ID")%>">
							<tbody>
								<%
									for (int j = 0; j < checkItemList.size(); j++) {
												count++;
												BusinessObject checkItem = checkItemList.get(j);
												String checkItemLabel = checkItem.getString("label");
												//获取对应checkitem需要展示的数据
												Map<String,List<String>> checkItemDatas = CreditCheckConfig
														.getCheckItemDataValues(checkItem, Sqlca, checkListParameters);
												List<BusinessObject> checkOpinionOptions = CreditCheckConfig
														.getCheckItemStatusCodeValues(checkItem.getString("ID"));
												//获取对应checkitem是否必查
												String checkItemRequired = CreditCheckConfig.getCheckItemRequired(checkGroup.getString("ID"),
														checkItem.getString("ID"));
												//获取数据库中对应checkitem已保存的核查结果数据
												Map<String, String> parameterMap = new HashMap<String, String>();
												parameterMap.put("checkGroupId", checkGroup.getString("ID"));
												parameterMap.put("checkItemId", checkItem.getString("ID"));
												parameterMap.put("objectNo", objectNo);
												parameterMap.put("objectType", objectType);
												parameterMap.put("taskSerialNo", taskSerialNo);
												String defaultOption = CreditCheckConfig.getParameterValue(checkItem.getString("parameter"),
														Sqlca, parameterMap);
												if(defaultOption == null) defaultOption="";
								%>
								<tr>
									<td align="center"  vAlign="middle" width="3%"><%=count%>.</td>
									<td align="left"  vAlign="middle">
										<p align="left"><%=checkItemLabel%>&nbsp;<span id="OpinionRequiredSign_<%=checkGroup.getString("ID")%>_<%=checkItem.getString("ID")%>" style="display:"><font color="red"><%=("true".equalsIgnoreCase(checkItemRequired)) ? "*" : ""%></font></span>&nbsp;&nbsp;
											<%
											if (checkOpinionOptions != null) {
												for (BusinessObject option : checkOpinionOptions) {
													String defaultchecked = option.getString("ID").equals(defaultOption) ? "checked" : "";				
											%>
											<input type="radio" <%=defaultchecked%>
												name="Opinion_<%=checkGroup.getString("ID")%>_<%=checkItem.getString("ID")%>"
												ID="Opinion_<%=checkGroup.getString("ID")%>_<%=checkItem.getString("ID")%>"
												groupId="<%=checkGroup.getString("ID")%>"
												itemId="<%=checkItem.getString("ID")%>"
												required="<%=checkItemRequired%>"
												onClick="radioValidate(this);<% for(BusinessObject script:scripts){%><%=script.getString("name")%>(this);<%}%>"
												value="<%=option.getString("ID")%>" />
											<%=option.getString("value")%>
											<%
												}
											} else {
											%>
											<input type="text" style="border:0;border-bottom:1 solid grey;background:transparent;text-align:center;padding:6 0 0 0px" 
												name="Remark_<%=checkGroup.getString("ID")%>_<%=checkItem.getString("ID")%>"
												ID="Remark_<%=checkGroup.getString("ID")%>_<%=checkItem.getString("ID")%>"
												groupId="<%=checkGroup.getString("ID")%>"
												itemId="<%=checkItem.getString("ID")%>"
												required="<%=checkItemRequired%>" 
												onBlur="textValidate(this)"
												value="<%=defaultOption%>" />
											<%
											}
											%>
											<span id=OpinionDiv_<%=checkGroup.getString("ID")%>_<%=checkItem.getString("ID")%> style="display: none">&nbsp;
												<font color=red>* 请录入该项核查结果！</font>
											</span>
										</p>
									</td>
									
									
								</tr>
								<%
									}
								%>
							</tbody>
						</table>
						<%
							}
						%>
						<div class="creditcheck_end">
							<table class="list_data_tablecommon" width='100%'>
								<tr class="listdw_out_buttonarea">
									<td align="center">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td height="30" align="center">
														<%
															if (!sRightType.equals("ReadOnly")) {
														%><input type="submit" name="submit" value="保存/确定">
														<%
															}
														%>
														<div id=saveInfoDiv style="display: none">保存成功</div>
													</td>
												</tr>
										</table> 
									</td>
								</tr>
							</table>
						</div>
					</div>
				</td>
			</tr>
		</table>
	</form>
 	<iframe name="iframehide" src="<%=com.amarsoft.awe.util.Escape.getBlankHtml(sWebRootPath)%>" style="display:none" width=0 height=0 frameborder=0></iframe>
</body>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/creditcheck.js"></script>
<script type="text/javascript">
initAccompanyGroup();
</script>
<%@	include file="/IncludeEnd.jsp"%>