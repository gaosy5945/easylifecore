<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.flow.util.TeamUserUpload"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String teamID = CurPage.getParameter("TeamID");
	String userID = CurPage.getParameter("UserID");
	String orgID = CurPage.getParameter("OrgID");
	if(orgID == null || orgID == "undefined") orgID = "";
	if(teamID == null || teamID == "undefined") teamID = "";
	if(userID == null || userID == "undefined") userID = "";

	ASObjectModel doTemp = new ASObjectModel("TeamUserList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.MultiSelect = true; //�����ѡ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("UserID", userID);
	dwTemp.setParameter("TeamID", teamID);
	dwTemp.setParameter("OrgID", orgID);
	dwTemp.genHTMLObjectWindow("");
	
	TeamUserUpload myTeamUserUpload = new TeamUserUpload();
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�����Ŷӳ�Ա","����","add()","","","","btn_icon_add",""},
			{"true","","Button","�Ŷӳ�Ա����","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ���Ŷӳ�Ա","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var returnValue =AsDialog.SelectGridValue("SelectUser", "<%=orgID%>,<%=teamID%>", "UserID", "", true);
		if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		returnValue = returnValue.split("~");
		for(var i in returnValue){
			if(typeof returnValue[i] ==  "string" && returnValue[i].length > 0 ){
				var parameter = returnValue[i].split("@");
				AsCredit.RunJavaMethodTrans("com.amarsoft.app.flow.util.TeamUserUpload","addUser",
						"UserID="+parameter+",TeamID=<%=teamID%>,InputUserID=<%=CurUser.getUserID()%>,InputOrgID=<%=CurUser.getOrgID()%>");
			}
		}
		reloadSelf();
	}
	function edit(){
		 var sUrl = "/Common/Configurator/FlowManage/TeamUserInfo.jsp";
		 var teamID = getItemValue(0,getRow(0),'TeamID');
		 var userID = getItemValue(0,getRow(0),'UserID');
		 if(typeof(teamID)=="undefined" || teamID.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.PopView(sUrl,'UserID='+userID+'&TeamID='+teamID,'dialogWidth:400px;dialogHeight:300px;','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
