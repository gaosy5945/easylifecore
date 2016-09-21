<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.XMLHelper" %>
<%@include file="/Frame/resources/include/include_begin_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>
<%
	String xmlFile = CurPage.getParameter("XMLFile");
	String xmlTags = CurPage.getParameter("XMLTags");
	String keys = CurPage.getParameter("Keys");
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("PRD_ComponentList", BusinessObject.createBusinessObject(), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.als.businessobject.web.XMLBusinessObjectProcessor");
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly="1";
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","","Button","新增","新增","newComponent()","","","","",""},
			{"true","","Button","编辑","编辑","editComponent()","","","","",""},
			{"true","","Button","复制","复制","copyComponent()","","","","",""},
			{"true","","Button","删除","删除","deleteComponent()","","","","",""},
			{"false","","Button","参数同步","参数同步","updateComponentParamter()","","","","",""},
	};
%>
<script type="text/javascript">
	function newComponent(){
		 AsCredit.openFunction("PRD_BusinessComponentInfo","XMLFile=<%=xmlFile%>&XMLTags=Component&Keys=<%=keys%>&ID=");
		 reloadSelf();
	}
	
	function editComponent(){
		var id = getItemValue(0,getRow(0),"ID");
		var format = getItemValue(0,getRow(0),"Format");
	    if(typeof(id)=="undefined" || id.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	       return ;
		}
	    AsCredit.openFunction("PRD_BusinessComponentInfo","XMLFile=<%=xmlFile%>&XMLTags=Component&Keys=<%=keys%>&ID="+id+"&Format="+format,"","_blank");
		reloadSelf();
	}
	
	function updateComponentParamter(){
		var result =AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.businesscomponent.config.BusinessComponentManager", "updateAllComponentParameter", "");
		if(result=="true") alert("同步完成！");
		else alert("同步失败！");
	}
	
	function deleteComponent(){
		var id = getItemValue(0,getRow(0),"ID");
	    if(typeof(id)=="undefined" || id.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
		
	    ALSObjectWindowFunctions.deleteSelectRow(0)
	}

	function copyComponent(){
		var id = getItemValue(0,getRow(0),"ID");
	    if(typeof(id)=="undefined" || id.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	   		return ;
		}
	    $("#input").show();
	}
	
	function doCopy(){
		$("#input").hide();
		var newID = $("#newComponentID").val();
		var newName = $("#newComponentName").val();
		var id = getItemValue(0,getRow(0),"ID");
		if(typeof(id)=="undefined" || id.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	   		return ;
		}
		
		if(typeof(newID)=="undefined" || newID.length==0) {
			alert("请输入新的组件编号！");
			return;
		}
		if(typeof(newName)=="undefined" || newName.length==0) {
			alert("请输入新的组件名称！");
			return;
		}
		
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.businesscomponent.config.BusinessComponentManager", 
				"copyComponent","XMLFile=<%=xmlFile%>,XMLTags=Component,Keys=<%=keys%>,ComponentID="+id+",NewComponentID="+newID+",NewComponentName="+newName );
		if(result){
			result=result.split("@");
			if(result[0]=="true"){
				alert(result[1]);
				reloadSelf();
			}
			else{
				alert(result[1]);
			}
		}
	}
	
	function doCancel(){
		$("#input").hide();
		$("#newComponentID").val("");
		$("#newComponentName").val("");
	}
	
</script>
<div style="width: 100%;height: 100%;background-color: #CCC;display: none"  id="input">
<div style="width: 200px;height: 150px;left: 30%;top:30%;position: relative;background-color: white">
	<table style="margin-left: 30px; top: 10px;position: relative;">
			<tr><td align="center">请输入新组件编号:</td></tr>
			<tr><td><input type="text" id= "newComponentID"></td></tr>
			<tr><td align="center">请输入新组件名称:</td></tr>
			<tr><td><input type="text" id= "newComponentName"></td></tr>
			<tr>
				<td align="center"><input type="button" value="确认"  onclick="doCopy();" >&nbsp;<input type="button" value="取消"  onclick="doCancel();" ></td>
			</tr>
</table>
</div>
</div>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@include file="/Frame/resources/include/include_end.jspf"%>