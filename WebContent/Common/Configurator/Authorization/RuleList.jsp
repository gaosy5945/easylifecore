<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	String userID = CurPage.getParameter("UserID");
	if(userID == null || userID == "undefined") userID = "";
	ASObjectModel doTemp = new ASObjectModel("RuleList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setParameter("UserID", userID);
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","",""},
			{"true","","Button","��Ȩģ������","����","edit()","","","","",""},
			{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var returnValue =AsDialog.SelectGridValue("RuleSelect", "<%=CurUser.getOrgID()%>", "SerialNo@SceneName","", true,"dialogWidth:800px;dialogHeight:600px;resizable:yes;scrollbars:no;status:no;help:no");
		if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		var serialNo = "";
		var inputOrgID = "<%=CurUser.getOrgID()%>";
		var inputUserID = "<%=CurUser.getUserID()%>";
		returnValue = returnValue.split("~");
		for(var i in returnValue){
			if(typeof returnValue[i] ==  "string" && returnValue[i].length > 0 ){
				var parameter = returnValue[i].split("@");
				serialNo = parameter[0];
				AsCredit.RunJavaMethodTrans("com.amarsoft.app.flow.util.RuleUpload","addUser",
				"SerialNo="+serialNo+",InputOrgID="+inputOrgID+",InputUserID="+inputUserID+",UserID=<%=userID%>"); 
			}
		}
		reloadSelf();
	}
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.PopView('/Common/Configurator/Authorization/RuleInfo.jsp','SerialNo=' +serialNo+"&AuthorizeType=01" ,'dialogWidth:750px;dialogHeight:500px;resizable:yes;scrollbars:no;status:no;help:no','');
		reloadSelf();
	}
	function reloadSelf(){
		var userID = "<%=userID%>";
		AsControl.OpenComp("/Common/Configurator/Authorization/RuleList.jsp","UserID="+userID,"_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
