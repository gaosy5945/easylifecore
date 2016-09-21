 <%@page import="com.amarsoft.app.als.ui.function.FunctionObjectWindowManager"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.als.ui.function.FunctionWebTools"%>
<%@page import="com.amarsoft.awe.dw.ASObjectWindow"%>
<%@page import="com.amarsoft.app.base.util.StringHelper"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@page import="com.amarsoft.app.als.sys.function.model.FunctionInstance"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<script type="text/javascript" src="<%=sWebRootPath%>/ProductManage/ComponentConfig/js/BusinessComponent.js"></script>
<%	
	FunctionInstance functionInstance=FunctionInstance.getFunctionInstance(CurPage, CurUser);
	String functionID = functionInstance.getFunction().getKeyString();
	String functionItemID =functionInstance.getCurFunctionItemID();
	CurPage.setAttribute("HideScroll", "true");
	
	String sButtons[][] = FunctionWebTools.genButtons(functionInstance, functionItemID);
	if(sButtons == null) sButtons = new String[0][6];
	
	FunctionObjectWindowManager multipleOWPageGenerator = new FunctionObjectWindowManager(CurPage,request,functionInstance);
%>
<html>
<head>
</head>
<body class=pagebackground leftmargin="0" topmargin="0" style="overflow-y:auto;overflow-x:hidden;" >
<%@include file="/Common/FunctionPage/jspf/MessageBox.jspf" %>
<script>var functionOWMap={};</script>
<div id="Layer1" style="position:absolute;width:99.9%; height:99.9%; z-index:1; overflow: auto">
<table align='center' width='100%'  cellspacing="0" cellpadding="0">
  <tr height=1 id="ButtonTR">
		<td id="ListButtonArea" class="ListButtonArea" valign=top>
			<%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%>
	    </td>
  </tr>
  <tr height=5></tr>
<%
//分组信息
List<BusinessObject> groupList = functionInstance.getFunctionItemList("", FunctionInstance.FUNCTION_ITEM_TYPE_OWGROUP);
if(groupList.isEmpty()){
	BusinessObject defaultGroupItem = BusinessObject.createBusinessObject();
	defaultGroupItem.setAttributeValue("FunctionItemID","SYS_FUNCTION_DEFAULT_GROUP");
	defaultGroupItem.setAttributeValue("FunctionItemName","");
	groupList.add(defaultGroupItem);
}
for(BusinessObject groupFunctionItem:groupList){
	String groupID=groupFunctionItem.getString("FunctionItemID");
	String groupTitle=groupFunctionItem.getString("FunctionItemName");
	String functionGroupItemID=groupID;
	if(functionGroupItemID.equals("SYS_FUNCTION_DEFAULT_GROUP")) functionGroupItemID="";
%>
	<tr> 
		<td> 
			<div id="DIV_Group_<%=groupID%>">
			<%if(groupList.size()>1){%>
			<!-- 分组栏 -->
				<table class="info_data_tablecommon info_group_table" width='100%'>
					<tr>
						<td style="width:7px;" >&nbsp;</td>
						<td class="info_group_backgourd_2 info_group_backgourd_3">
						 	<span id="imgexpand<%=groupID%>" class="info_group_expand" expand="1" onclick="ALSObjectWindowFunctions.showGroup('<%=groupID%>')">&nbsp;</span>
						 </td>
						<td class="info_group_backgourd_2"	onclick="ALSObjectWindowFunctions.showGroup('<%=groupID%>')">
							<span class="info_group_title" id="Group_<%=groupID%>" style="dispaly:inline-block;float:left;"><%=groupTitle%></span>
							<span id="Group_Button_<%=groupID%>" style="text-align:left;dispaly:inline-block;float:right;">
							<%
							List<BusinessObject> buttonList = functionInstance.getFunctionItemList(functionGroupItemID, FunctionInstance.FUNCTION_ITEM_TYPE_BUTTON);
							if(buttonList!=null&&!buttonList.isEmpty()){
								for(BusinessObject buttonItem:buttonList){
							%>
									<a onclick="<%=buttonItem.getString("URL")%>"><%=buttonItem.getString("FunctionItemName")%><a/>
							<%
								}
							}
							%>
							</span>
						</td>
					</tr>
				</table>
			<%} %>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" id="GroupBody_<%=groupID%>">
					<tr>
						<td class="info_2side_border" style="height: auto;">
							<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="table_line">
								<tr>
									<td width="100%" colspan="2" class="borderLRB" style="height: auto;">
										<div id="DIV_GroupBody_<%=groupID%>">
										<%
											List<BusinessObject> owlist = functionInstance.getFunctionItemList(functionGroupItemID, FunctionInstance.FUNCTION_ITEM_TYPE_INFO+","+FunctionInstance.FUNCTION_ITEM_TYPE_LIST);
											if(owlist!=null&&!owlist.isEmpty()){
												for(BusinessObject owitem:owlist){
													ASObjectWindow dwTemp = multipleOWPageGenerator.getObjectWindow(owitem.getString("FunctionItemID"));
													if(dwTemp!=null){
														String dwname = ObjectWindowHelper.getObjectWindowName(dwTemp.getDataObject());
										%>
												<script>functionOWMap["<%=owitem.getString("FunctionItemID")%>"]="<%=dwname%>";</script>
												<table style="width:100%" id="TABLE_GROUP_DW_<%=owitem.getString("FunctionItemID")%>">
													<tr id="TR_GROUP_DW_<%=owitem.getString("FunctionItemID") %>">
														<td style="width:60%">
															<b><i><%=owitem.getString("FunctionItemName") %></i></b>
														</td>
														<td align=right>
														<%
															List<BusinessObject> dwbuttonList = functionInstance.getFunctionItemList(owitem.getString("FunctionItemID"), "Link");
															if(dwbuttonList!=null&&!dwbuttonList.isEmpty()){
																for(BusinessObject dwbuttonItem:dwbuttonList){
															%>
																	<a onclick="<%=dwbuttonItem.getString("URL")%>"><%=dwbuttonItem.getString("FunctionItemName")%><a/>
															<%
																}
															}
															%>
														</td>
													</tr>
												
													<tr>
														<td colspan=2 style="width:97%;align:center">
															<div id="DIV_GROUP_DW_DESCRIBE_<%=owitem.getString("FunctionItemID")%>"></div>
														</td>
													</tr>
													<tr>
														<td colspan=2>
															<%
														//dwHTML
															
															Vector v = dwTemp.genHTMLDataWindow("");
															StringBuffer sb = new StringBuffer();
															for(Object s:v){
																String s1=(String)s;
																if("DZ[i] = new Array();\n".equals(s1)) continue;
																sb.append((String)s);
															}
															String dwStyle = dwTemp.Style;
															if(dwStyle.equals("1")){
																out.println(sb.toString());					
															%>
																<div id="DIV_DW_<%=owitem.getString("FunctionItemID")%>">
																	<form name="listvalid<%=dwname%>" id="listvalid<%=dwname%>">
																		<hidden name="element_listvalid<%=dwname%>" id="element_listvalid<%=dwname%>">
																	</form>
																	<table class="list_data_tablecommon" id="ListTable">
																		<tr height=1 id="ButtonTR1">
																			<td id="ListButtonArea1" class="ListButtonArea" valign=top>
																				<%
																				String listButtons[][] = FunctionWebTools.genButtons(functionInstance, owitem.getString("FunctionItemID"));
																				if(listButtons!=null&&listButtons.length>0){
																					ButtonItem[] _listItems = ItemHelp.getButtonItemArray(CurUser,listButtons,CurComp.getAttribute("RightType",10),request.getRequestURI().substring(request.getRequestURI().indexOf(sWebRootPath)+sWebRootPath.length()));
																					if(_listItems != null){
																						for(ButtonItem _item : _listItems){
																							out.print(new Button(_item).getHtmlText());
																						}
																					}
																				}
																				%>
																		    </td>
																		</tr>
																		<tr id="DWTR">
																			<td class="listdw_out_data" id="DWTD" style="position:relative;">
																				<div id="Table_Content_<%=dwname%>"></div>
																			</td>
																		</tr>
																	</table>
																</div>
																<script type="text/javascript">
																document.getElementById("Table_Content_<%=dwname%>").innerHTML = TableFactory.createTableHTML(<%=dwname%>);
																$("#myiframe<%=dwname%>_float,#myiframe<%=dwname%>_static,#myiframe<%=dwname%>_cells").css({
																		"overflow-x":"auto",
																		"overflow-y":"auto"
																	});
																</script>
															<%
															}
															else if(dwStyle.equals("2")){
															%>
																<table class="info_data_tablecommon" id="InfoTable">
																	<tr id="DWTR">
																		<td valign=top class="infodw_top_area" id="DWTD">
																			<div id="<%=dwname%>" style="overflow:auto;margin:0px;">
																				<form name="myiframe<%=dwname%>" id="myiframe<%=dwname%>" style="margin:0px;">
																					<%=sb.toString() %>
																				</form>
																			</div>
																		</td>
																	</tr>
																</table>
														<%
															}
														%>
														</td>
													</tr>
												</table>
												
										<%
													}
												}
											}
										%>
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
<%
}
%>
</table>
</div>
<%@ include file="/Frame/page/jspf/ui/widget/ow/overdiv.jspf"%>
</body>
</html>

<%@include file="/Common/FunctionPage/jspf/FunctionScript.jspf" %>
<%@ include file="/IncludeEnd.jsp"%>