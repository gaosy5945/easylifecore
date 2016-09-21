<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String teamID = CurPage.getParameter("TeamID");
	if(teamID == null || teamID == "undefined") teamID = "";
	String teamType = CurPage.getParameter("TeamType");
	if(teamType == null || teamType == "undefined") teamType = "";
	ASObjectModel doTemp = new ASObjectModel("FlowTeamList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	//dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("TeamID", teamID);
	dwTemp.setParameter("OrgID", CurOrg.getOrgID());
	dwTemp.setParameter("TeamType", teamType);
	dwTemp.genHTMLObjectWindow("");
	String flag = teamType.equals("01") ? "false" : "true";
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�����Ŷ�","����","add()","","","",""},
			{"true","All","Button","�Ŷ�����","����","view()","","","",""},
			{"true","","Button","ɾ���Ŷ�","ɾ��","deleteTeam()","","","","",""},
			{flag,"","Button","ҵ����Ȩ","��Ȩ","addRule()","","","","",""},
		};
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		AsControl.PopView("/Common/Configurator/FlowManage/FlowTeamInfo.jsp","","dialogWidth:500px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no","");
		reloadSelf();
	}
	function view(){
		var teamID = getItemValue(0,getRow(),"TeamID");
		var orgID = getItemValue(0,getRow(),"OrgID");
		AsControl.PopView("/Common/Configurator/FlowManage/FlowTeamInfo.jsp","TeamID="+teamID+"&OrgID="+orgID,"dialogWidth:500px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no","");
		reloadSelf();
	}
	function deleteTeam(){
		var teamID = getItemValue(0,getRow(),"TeamID");
		var teamName = getItemValue(0,getRow(),"TeamName");
		if(typeof(teamID)=="undefined" || teamID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			if(!confirm("ȷ��ɾ���Ŷӡ�"+teamName+"����?")) return;
			as_delete('myiframe0');
			var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.flow.util.RuleDelete","TeamDelete","TeamID="+teamID); 
		}
		reloadSelf();
	}
	function addRule(){
		var teamID = getItemValue(0,getRow(),"TeamID");
		var orgID = getItemValue(0,getRow(),"OrgID");
		AsControl.PopView("/Common/Configurator/Authorization/TeamRuleList.jsp","TeamID="+teamID+"&OrgID="+orgID,"dialogWidth:750px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no","");
	}
	/*��¼��ѡ��ʱ�����¼�*/
	function mySelectRow(){
		var teamID = getItemValue(0,getRow(),"TeamID");
		var orgID = getItemValue(0,getRow(),"OrgID");
		if(typeof(teamID)=="undefined" || teamID.length==0) {
			return;
		}else{
			AsControl.OpenView("/Common/Configurator/FlowManage/TeamUserList.jsp","TeamID="+teamID+"&OrgID="+orgID,"rightdown","");
		}
	}
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
