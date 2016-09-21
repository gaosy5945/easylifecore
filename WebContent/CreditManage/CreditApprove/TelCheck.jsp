<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.config.impl.*"%>
<%@page import="com.amarsoft.app.base.businessobject.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@include file="/IncludeBegin.jsp"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf"%>
<%
		String sPrevUrl = CurPage.getParameter("PrevUrl");
		if(sPrevUrl == null) sPrevUrl = "";
	//获得组件参数	
		String phaseNo = CurPage.getParameter("PhaseNo");
		String flowSerialNo = CurPage.getParameter("FlowSerialNo");
		String flowNo = Sqlca
				.getString(new SqlObject("select FlowNo from flow_instance where serialno = :SerialNo")
						.setParameter("SerialNo", flowSerialNo));
		String taskSerialNo = CurPage.getParameter("TaskSerialNo");
		String objectType = CurPage.getParameter("ObjectType");
		String objectNo = CurPage.getParameter("ObjectNo");
		String checkListName = CurPage.getParameter("CheckListName");
		String checkTypes = CurPage.getParameter("checkTypes");
		CurComp.setAttribute("CheckTypes", checkTypes);
		String sRightType = (String) CurPage.getAttribute("RightType");
		if (sRightType == null)
			sRightType = "";

		if (phaseNo == null)
			phaseNo = "";
		if (flowNo == null)
			flowNo = "";
		if (checkTypes == null)
			checkTypes = "";
		
		BusinessObject checkList = CreditCheckConfig.getCheckList(flowNo, phaseNo, checkListName);
		List<BusinessObject> checkGroupList = CreditCheckConfig.getCheckGroups(checkList);
		if (checkGroupList == null || checkGroupList.size() == 0 || phaseNo.equals("") || flowNo.equals("")) {
			out.println("该任务阶段未配置信息核查清单数据！");
			return;
		}
		Map<String,String> parametersMap = new HashMap<String,String>();
		parametersMap.put("flowSerialNo", flowSerialNo);
		parametersMap.put("orgname", CurUser.getOrgName());
		Map<String,String> checkListParameters = CreditCheckConfig.getCheckListParameters(checkList, Sqlca, parametersMap);
		
%>
<body class="pagebackground" style="overflow-x: scroll">
	<form name="creditCheckForm" method="post" action="<%=sWebRootPath%>/CreditManage/CreditApprove/CreditCheckSave.jsp?CompClientID=<%=CurComp.getClientID()%>" onSubmit="return pageValidate()" target="iframehide">
		<table class="list_data_tablecommon" id="ListTable">
			<tr>
				<td valign=top>
					<div class="creditcheck_main">
						<%
							//生成界面
								for (int i = 0; i < checkGroupList.size(); i++) {
									BusinessObject checkGroup = checkGroupList.get(i);
									if(!checkTypes.contains(checkGroup.getString("ID"))) continue;
									Map<String, List<String>> checkGroupDatas = CreditCheckConfig.getCheckGroupDataValues(checkGroup.getString("ID"), Sqlca, checkListParameters);
									List<BusinessObject> checkItemList = CreditCheckConfig.getCheckNonGroupItems(checkGroup.getString("ID"));
									List<BusinessObject> scripts = checkGroup.getBusinessObjects("referscript");
									Map<String,String> CGSalepoints = CreditCheckConfig.getCheckGroupSalepointDescription(checkGroup.getString("ID"), Sqlca, checkListParameters);
									List<BusinessObject> checkGroupItemList = CreditCheckConfig.getCheckGroupItems(checkGroup.getString("ID"));
									if(checkGroupItemList == null || checkGroupItemList.isEmpty() || checkGroupItemList.size() == 0) continue;
						%>
						

						<table class="list_data_tablecommon" width="100%"
							id="GroupBody_<%=checkGroup.getString("ID")%>">
							<tr>
								<td class="list_all_td" align="center" vAlign="middle" width="3%"><%=checkGroup.getString("label")%></td>
								<td>
									<div>
										<table class="list_data_tablecommon" width="100%"
											id="GroupBody_<%=checkGroup.getString("ID")%>">
											<tr>
												<!-- 检查组第一行-->
												<td class="list_all_td" align="left" vAlign="middle"
													width="70%">
													<!-- 检查组话述展示 --> 
													<%
 													if (CGSalepoints == null || CGSalepoints.size() == 0) {
													%> 
													 <span><font style="color: blue; font-style: italic;">未配置话述内容</font></span>
													<%
													}
													for (String key : CGSalepoints.keySet()) {
													%> 
													<span><%=CGSalepoints.get(key)%></span>
													<%
													 	}
													%>
												</td>
												<td class="list_all_td" align="center" vAlign="middle"
													width="30%">
													<!-- 检查组综合意见选择 -->
													<table id="list_data_tablecommon" width='100%'>
														<div style="clear: both;">
															<%
																for (BusinessObject checkgroupItem : checkGroupItemList) {
																	//获取对应checkitem是否必查
																	String checkGroupItemRequired = CreditCheckConfig
																			.getCheckItemRequired(checkGroup.getString("ID"), checkgroupItem.getString("ID"));
																	//获取数据库中对应checkitem已保存的核查结果数据
																	Map<String, String> parameterMap = new HashMap<String, String>();
																	parameterMap.put("checkGroupId", checkGroup.getString("ID"));
																	parameterMap.put("checkItemId", checkgroupItem.getString("ID"));
																	parameterMap.put("objectNo", objectNo);
																	parameterMap.put("objectType", objectType);
																	parameterMap.put("taskSerialNo", taskSerialNo);
																	String defaultOption = CreditCheckConfig.getParameterValue(checkgroupItem.getString("parameter"), Sqlca, parameterMap);
																	String defaultOptionValue = "";
															%>
															<div style="clear: both; position: relative;">
																<span> <select
																	onchange="selectValidate(this);this.parentNode.nextSibling.value=this.options[this.selectedIndex].text;this.parentNode.nextSibling.style.color='black';<%for (BusinessObject script : scripts) {%><%=script.getString("name")%>(this);<%}%>"
																	class="list_all_input_select" width="100%"
																	name="Opinion_<%=checkGroup.getString("ID")%>_<%=checkgroupItem.getString("ID")%>"
																	id="Opinion_<%=checkGroup.getString("ID")%>_<%=checkgroupItem.getString("ID")%>"
																	itemId="<%=checkgroupItem.getString("ID")%>"
																	groupId="<%=checkGroup.getString("ID")%>"
																	required="<%=checkGroupItemRequired%>">
																		<option value=""></option>
																		<%
																			List<BusinessObject> checkGroupItemOptions = CreditCheckConfig.getCheckItemStatusCodeValues(
																								checkgroupItem.getString("ID"), checkGroup.getString("ID"));
																						for (BusinessObject option : checkGroupItemOptions) {
																							String defaultselected = option.getString("ID").equals(defaultOption) ? "selected" : "";
																							if("selected".equals(defaultselected)) defaultOptionValue = option.getString("value");
																		%>
																		<option value="<%=option.getString("ID")%>"
																			<%=defaultselected%>><%=option.getString("value")%></option>
																		<%
																			}
																		%>
																</select>
																</span> 
																<input type="text" style="width: 90%; position: absolute; left: 0px;color:grey;" readonly value="<%=defaultOptionValue%>" 
																placeholder="电话核查结果"
																onfocus="if (value =='电话核查结果'){value ='';style.color='black';}"
																onBlur="if (value ==''){value='电话核查结果';style.color='grey'}"/> 
																<span align="right"
																	id=OpinionDiv_<%=checkGroup.getString("ID")%>_<%=checkgroupItem.getString("ID")%>
																	style="display: none"> <font color=red>*
																		请选择综合核查意见！</font>
																</span>
															</div>
															<%
																}
															%>
														</div>
													</table>
												</td>
											</tr>
										</table>

										<table class="list_data_tablecommon" width="100%"
											id="GroupBody_<%=checkGroup.getString("ID")%>">
											<%
											int itemno = 0;
											for (BusinessObject checkItem : checkItemList) {
												Map<String, List<String>> checkItemDatas = CreditCheckConfig.getCheckItemDataValues(checkItem,
														Sqlca, checkListParameters);
												List<BusinessObject> checkOpinionOptions = CreditCheckConfig
														.getCheckItemStatusCodeValues(checkItem.getString("ID"));
												String checkItemRequired = CreditCheckConfig.getCheckItemRequired(checkGroup.getString("ID"),checkItem.getString("ID"));
												//获取数据库中对应checkitem已保存的核查结果数据
												Map<String, String> parameterMap = new HashMap<String, String>();
												parameterMap.put("checkGroupId", checkGroup.getString("ID"));
												parameterMap.put("checkItemId", checkItem.getString("ID"));
												parameterMap.put("objectNo", objectNo);
												parameterMap.put("objectType", objectType);
												parameterMap.put("taskSerialNo", taskSerialNo);
												String defaultOption = CreditCheckConfig.getParameterValue(checkItem.getString("parameter"),Sqlca, parameterMap) + "";
												String defaultRemark = CreditCheckConfig.getParameterValue(checkItem.getString("remarkparam"),Sqlca, parameterMap) + "";
												if ("".equals(defaultOption) || defaultOption == null || "null".equals(defaultOption))
													defaultOption = "";
												if ("".equals(defaultRemark) || defaultRemark == null || "null".equals(defaultRemark))
													defaultRemark = "";
												String itemDescription = CreditCheckConfig.getCheckItemDescription(checkItem, Sqlca,
														checkItemDatas);
												String itemAnswer = CreditCheckConfig.getCheckItemAnswer(checkItem, Sqlca, checkItemDatas);
												if ("".equals(itemDescription))
													continue;		
											%>
											<tr>
												<!-- 检查组后续问题行 -->
												<td class="list_all_td" align="center" vAlign="middle"
													width="70%">
													<table class="list_data_tablecommon" width="100%">
														<tr>
															<td
																style="border-right: #BCBCBC 1px solid; height: 30px;"
																align="left" vAlign="middle" width="20%">
																<!-- 第一列展示问题 --> <span><%=++itemno%>.<%=itemDescription%></span>
															</td>
															<td align="left" vAlign="middle" width="20%">
																<!-- 第二列展示答案--> <span><%=itemAnswer%></span>
															</td>
														</tr>
													</table>
												</td>

												<td class="list_all_td" align="center" vAlign="middle"
													width="30%">
													<table class="list_data_tablecommon" width="100%">
														<tr>
															<td
																style="border-right: #BCBCBC 1px solid; height: 30px; width: 50%"
																align="center" vAlign="middle">
																<!-- 第三列展示核查项检查结果的横向单选框-->
																<div nowrap style="clear: both;">
																	<p>
																	<div style="float: left;">
																		<div style="clear: both;">
																			<%
																				if (checkOpinionOptions != null) {
																								for (BusinessObject option : checkOpinionOptions) {
																									String defaultchecked = option.getString("ID").equals(defaultOption) ? "checked" : "";
																			%>
																			<div nowrap style="float: left">
																				<input type="radio" <%=defaultchecked%>
																					ID="Opinion_<%=checkGroup.getString("ID")%>_<%=checkItem.getString("ID")%>"
																					name="Opinion_<%=checkGroup.getString("ID")%>_<%=checkItem.getString("ID")%>"
																					groupId="<%=checkGroup.getString("ID")%>"
																					itemId="<%=checkItem.getString("ID")%>"
																					required="<%=checkItemRequired%>"
																					onClick="radioValidate(this);telCheckRadioChange(this);<%for (BusinessObject script : scripts) {%><%=script.getString("name")%>(this);<%}%>"
																					value="<%=option.getString("ID")%>" />
																				<%=option.getString("value")%></div>
																			<%
																				}
																							}
																			%>
																		</div>
																	</div>
																	</p>
																</div>
																<div nowrap >
																	<span align="right" ID=OpinionDiv_<%=checkGroup.getString("ID")%>_<%=checkItem.getString("ID")%> style="display: none">
																		<font color=red>* 请选择该项核查结果！</font>
																	</span>
																</div>
															</td>
															<td align="center" vAlign="middle" style="overflow: hidden; width: 50%">
																<!-- 第四列展示核查项检查结果的备注框--> 
																<input type="text"
																style="width: 100%; border: 0; border-bottom: 1 solid grey; background: transparent; text-align: center; color: grey; padding: 6 0 0 0px;"
																name="Remark_<%=checkGroup.getString("ID")%>_<%=checkItem.getString("ID")%>"
																ID="Remark_<%=checkGroup.getString("ID")%>_<%=checkItem.getString("ID")%>"
																groupId="<%=checkGroup.getString("ID")%>"
																itemId="<%=checkItem.getString("ID")%>"
																required="<%=checkItemRequired%>"
																placeholder="不一致说明"
																onBlur="textValidate(this);"
																value="<%=defaultRemark%>"/>
																<span align="right" ID=OpinionText_<%=checkGroup.getString("ID")%>_<%=checkItem.getString("ID")%> style="display: none">
																		<font color=red>* 请填写不一致说明！</font>
																</span>
															</td>
														</tr>
													</table>
												</td>
											</tr>
											<%
											}
											if(itemno == 0){
											%>
											<tr>
												<td class="list_all_td" vAlign="middle">
												<font style="color: blue; font-style: italic;">未配置核查项内容</font></td>
											</tr>
											<%	
											}
											%>
										</table>
									</div>
								</td>
							</tr>
						</table>
						<%
							}
						%>
						<div class="creditcheck_end" style="position:relative;left:0;top:0">
							<table class="list_data_tablecommon" width='100%'>
								<tr class="listdw_out_buttonarea">
									<td align="center">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td height="30" align="center">
													<%
														if (!sRightType.equalsIgnoreCase("ReadOnly")) {
													%>
													<input type="submit" name="submit" value="保存/确定">
													<%
														}
													%>
													<input type="button" name="return" value="返回" onclick = "returnBack()">
													<div id=saveInfoDiv style="display:none">保存成功</div>
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
	<iframe name="iframehide" src="<%=com.amarsoft.awe.util.Escape.getBlankHtml(sWebRootPath)%>" style="display: none" width=0 height=0 frameborder=0></iframe>
</body>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/creditcheck.js"></script>
<script type="text/javascript">
window.onload = function() {
	var objs = document.getElementsByTagName("input");
	for(var obji=0;obji<objs.length;obji++){
		 if ("text" == objs[obji].type){
			 funPlaceholder(objs[obji]);
		 }
	}
	for(var obji=0;obji<objs.length;obji++){
		 if("radio" == objs[obji].type && objs[obji].checked){
			 var groupId = objs[obji].getAttribute("groupId");
			 var itemId = objs[obji].getAttribute("itemId");
			 var selectedValue = objs[obji].value; 
			 var RemarkObj = document.getElementById("Remark_"+groupId+"_"+itemId);
			 if(selectedValue == "0002" && !(RemarkObj == null)){ 
					RemarkObj.setAttribute("required","true");
					RemarkObj.removeAttribute("disabled"); 
				}else if(!(RemarkObj == null)){
					RemarkObj.value = ""; 
					RemarkObj.setAttribute("required","false");
					RemarkObj.setAttribute("disabled","true"); 
				}
		 }
	}
}

function returnBack(){
	parent.reloadPage();
}
</script>
<%@	include file="/IncludeEnd.jsp"%>