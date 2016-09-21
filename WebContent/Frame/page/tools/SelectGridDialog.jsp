<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.are.util.json.JSONObject"%>
<%@page import="com.amarsoft.are.util.json.JSONDecoder"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	String sDoNo = CurPage.getParameter("DoNo");
	String manualQueryFlag = CurPage.getParameter("ManualQueryFlag");
	if(manualQueryFlag == null) manualQueryFlag = "";
	String sParameters = CurPage.getParameter("Parameters");
	String sFields = CurPage.getParameter("Fields");
	boolean isMulti = "true".equals(CurPage.getParameter("IsMulti"));
	if(sParameters == null) sParameters = "";
	
	String[] tFields = sFields.split("@");
	List<String> fields = new ArrayList<String>();
	for(String field : tFields){
		if(StringX.isSpace(field)) continue;
		fields.add(field);
	}
	
	ASDataObject doTemp;
	ASObjectWindow dwTemp;
	
	
	try
	{
		JSONObject inputParameters=JSONDecoder.decode(sParameters);
		dwTemp = ObjectWindowHelper.createObjectWindow_List(sDoNo, BusinessObject.createBusinessObject(), CurPage, request);
		doTemp=dwTemp.getDataObject();
		
		
		for (int i = 0; i < inputParameters.getElementTable().size(); ++i) {
			Element localElement = (Element)inputParameters.getElementTable().get(i);
			if (localElement.isNull())
				continue;
			CurPage.setAttribute(localElement.getName(), (String)localElement.getValue());
		}
		
		if(!StringX.isEmpty(CurPage.getParameter("BusinessProcess")))
		{
			doTemp.setBusinessProcess(CurPage.getParameter("BusinessProcess"));
		}
		
	}catch(Exception ex)
	{
		doTemp = new ASObjectModel(sDoNo);
		dwTemp = new ASObjectWindow(CurPage ,(ASObjectModel)doTemp,request);
	}
	doTemp.setLockCount(0);
	if(manualQueryFlag.equals("1"))
		doTemp.setJboWhereWhenNoFilter("1=2");
	if(!isMulti) doTemp.setHtmlEvent("","ondblclick","doSure");
	
	dwTemp.ConvertCode2Title = "1";
	dwTemp.MultiSelect = isMulti;
	dwTemp.setPageSize(20);
	dwTemp.ReadOnly = "1";
	
	dwTemp.genHTMLObjectWindow(sParameters);

	String sDoName = doTemp.getDoName();
	if("".equals(sDoName)) sDoName = "列表选择器";

	String[][] sButtons = {
			/*
			{"true", "", "Button", "确定", "", "doSure()", "", "", "", ""},
			{"true", "", "Button", "清空", "", "doClear()", "", "", "", ""},
			{"true", "", "Button", "取消", "", "doCancel()", "", "", "", ""},
			*/
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"
%><%@page import="com.amarsoft.are.lang.StringX"%>
<script type="text/javascript">
	document.onkeydown = function(e){
		var e = e || window.event;
		if(e.keyCode==27){
			parent.doCancel();
		}
	};

	var aSelected = new Array();
	function doSure(){
		beforeSubmitFilter();
		if(aSelected.length < 1){
			alert("请选择记录！");
			return;
		}
		var sReturn = "";
		if(<%=isMulti%>){
			for(var i = 0; i < aSelected.length; i++){
				if(sReturn != "") sReturn += "~";
				for(var j = 0; j < aSelected[i].length; j++){
					if(j != 0) sReturn += "@";
					sReturn += aSelected[i][j];
				}
			}
		}else{
			for(var i = 0; i < aSelected.length; i++){
				if(i != 0) sReturn += "@";
				sReturn += aSelected[i];
			}
		}
		parent.closeDialog(sReturn);
	}
	
	/**
	 * 翻页后调用
	 */
	function afterSubmitFilter(){
		var rowCount = getRowCount(0);
		var rows  = new Array();
		for(var i = 0; i < rowCount; i++){
			if(removeSelected(i)) rows.push(i);
		}
		selectRows(0, rows);
	}
	
	function removeSelected(num){
		var sValue = getItemValue(0, num, "<%=fields.size() > 0 ? fields.get(0) : ""%>");
		if(<%=isMulti%>){
			for(var i = 0; i < aSelected.length; i++){
				if(aSelected[i][0] == sValue){
					aSelected.splice(i, 1);
					return true;
				}
			}
		}else{
			if(aSelected.length > 0 && aSelected[0] == sValue){
				lightRow(0, num);
			}
		}
		return false;
	}
	
	/**
	 * 翻页前调用
	 */
	function beforeSubmitFilter(){
		if(<%=isMulti%>){
			var rows = getCheckedRows(0);
			for(var i = 0; i < rows.length; i++){
				aSelected.push(getValue(rows[i]));
			}
		}else{
			aSelected = getValue(getRow());
		}
	}

	function getValue(iRow){
		var aReturn = new Array();
		if(iRow < 0) return aReturn;
		<%for(String field : fields){%>
			aReturn.push(getItemValue(0, iRow, "<%=field%>"));
		<%}%>
		return aReturn;
	}
	
	$(function(){
		setDialogTitle("<%=sDoName%>");
		var initSelected = !top.dialogArguments ? "" : top.dialogArguments;
		if(typeof initSelected == "string") initSelected = [initSelected];
		// 补全参数
		for(var i = initSelected.length; i < <%=fields.size()%>; i++){
			initSelected[i] = initSelected[0];
		}
		// 没有
		if(!initSelected[0]) return;
		// aSelected
		var aSel0 = initSelected[0].split(",");
		for(var i = 0; i < aSel0.length; i++){
			var selected = new Array();
			aSelected.push(selected);
			selected.push(aSel0[i]);
			for(var j = 1; j < initSelected.length; j++){
				if(!initSelected[j]) selected.push("");
				selected.push(initSelected[j].split(",")[i]);
			}
		}
		afterSubmitFilter();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>