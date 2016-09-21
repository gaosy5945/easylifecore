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
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly="1";
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","","Button","����","����","newComponent()","","","","",""},
			{"true","","Button","�༭","�༭","editComponent()","","","","",""},
			{"true","","Button","����","����","copyComponent()","","","","",""},
			{"true","","Button","ɾ��","ɾ��","deleteComponent()","","","","",""},
			{"false","","Button","����ͬ��","����ͬ��","updateComponentParamter()","","","","",""},
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
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	       return ;
		}
	    AsCredit.openFunction("PRD_BusinessComponentInfo","XMLFile=<%=xmlFile%>&XMLTags=Component&Keys=<%=keys%>&ID="+id+"&Format="+format,"","_blank");
		reloadSelf();
	}
	
	function updateComponentParamter(){
		var result =AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.businesscomponent.config.BusinessComponentManager", "updateAllComponentParameter", "");
		if(result=="true") alert("ͬ����ɣ�");
		else alert("ͬ��ʧ�ܣ�");
	}
	
	function deleteComponent(){
		var id = getItemValue(0,getRow(0),"ID");
	    if(typeof(id)=="undefined" || id.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
		
	    ALSObjectWindowFunctions.deleteSelectRow(0)
	}

	function copyComponent(){
		var id = getItemValue(0,getRow(0),"ID");
	    if(typeof(id)=="undefined" || id.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
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
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	   		return ;
		}
		
		if(typeof(newID)=="undefined" || newID.length==0) {
			alert("�������µ������ţ�");
			return;
		}
		if(typeof(newName)=="undefined" || newName.length==0) {
			alert("�������µ�������ƣ�");
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
			<tr><td align="center">��������������:</td></tr>
			<tr><td><input type="text" id= "newComponentID"></td></tr>
			<tr><td align="center">���������������:</td></tr>
			<tr><td><input type="text" id= "newComponentName"></td></tr>
			<tr>
				<td align="center"><input type="button" value="ȷ��"  onclick="doCopy();" >&nbsp;<input type="button" value="ȡ��"  onclick="doCancel();" ></td>
			</tr>
</table>
</div>
</div>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@include file="/Frame/resources/include/include_end.jspf"%>