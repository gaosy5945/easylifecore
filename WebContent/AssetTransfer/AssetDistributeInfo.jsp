<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

	String sTempletNo = "AssetDistributeInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(CurPage.getParameter(""));
	String sButtons[][] = {
		{"true","All","Button","ȷ��","ȷ��","ok()","","","",""},
		{"true","All","Button","ȡ��","ȡ��","top.close()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function ok(){
		var sManageOrgId = getItemValue(0,0,"ManageOrgId");
		var sManageUserId = getItemValue(0,0,"ManageUserId");
		top.returnValue = sManageOrgId+"@"+sManageUserId;
		top.close();
	}
	
	function selectOrg(){
		var selValue = AsDialog.OpenSelector( "SelectAllOrg", "", "" );//ѡ�����
		if(typeof(selValue) == "undefined" || selValue == "_CLEAR_" || selValue == "_CANCEL_"){
			return;
		}
		
		setItemValue(0,0,"ManageOrgId",selValue.split("@")[0]);
		setItemValue(0,0,"ManageOrgName",selValue.split("@")[1]);
	}
	
	function selectUser(){
		var orgId = getItemValue(0,0,"ManageOrgId");
		if(typeof(orgId) == 'undefined' || orgId.length == 0){
			alert("����ѡ�����");
			return;
		}
		
		var selValue = AsDialog.OpenSelector( "SelectUserBelongOrg", "BelongOrg,"+orgId, "" );//ѡ��������û�
		if(typeof(selValue) == "undefined" || selValue == "_CLEAR_" || selValue == "_CANCEL_"){
			return;
		}
		
		setItemValue(0,0,"ManageUserId",selValue.split("@")[0]);
		setItemValue(0,0,"ManageUserName",selValue.split("@")[1]);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
