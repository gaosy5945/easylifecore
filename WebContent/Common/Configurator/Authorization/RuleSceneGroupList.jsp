<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String authorizeType = CurPage.getParameter("AuthorizeType");
	if(authorizeType == null || authorizeType == "undefined") authorizeType = "01";
	String orgID = CurUser.getOrgID();
	ASObjectModel doTemp = new ASObjectModel("RuleSceneGroupList");
	if("01".equals(authorizeType)){
		doTemp.setJboWhere("STATUS='1' and AuthorizeType = '01' and InputOrgID = :InputOrgID");
	}else{
		doTemp.setJboWhere("STATUS='1' and AuthorizeType = '02' and InputOrgID = :InputOrgID");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("InputOrgID", orgID);
	dwTemp.genHTMLObjectWindow(orgID);
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","",""},
			{"true","","Button","����","����","edit()","","","","",""},
			{"true","All","Button","ɾ��","ɾ��","deleteSceneGroup()","","","","",""},
			{"true","All","Button","����","����","copySceneGroup()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var authorizeType = "<%=authorizeType%>";
		 AsControl.PopView("/Common/Configurator/Authorization/RuleSceneGroupInfo.jsp","AuthorizeType="+authorizeType,"dialogWidth:400px;dialogHeight:320px;resizable:yes;scrollbars:no;status:no;help:no");
		 reloadSelf();
	}
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 var authorizeType = "<%=authorizeType%>";
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��ѡ��һ����¼��");
			return ;
		 }
		 AsControl.PopView("/Common/Configurator/Authorization/RuleSceneGroupInfo.jsp","SerialNo="+serialNo+"&authorizeType ="+authorizeType,"dialogWidth:400px;dialogHeight:320px;resizable:yes;scrollbars:no;status:no;help:no");
		 reloadSelf();
	}
	function deleteSceneGroup(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var sceneName = getItemValue(0, getRow(), "SceneName");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.flow.util.QueryRuleIsInuseForUser", "query", "SerialNo="+serialNo);
			if(returnValue.split("@")[0] == "true"){
				if(!confirm("ɾ����ģ���Ӱ�� "+returnValue.split("@")[1]+" λ�����ڵ�ϵͳ����Ȩ��ȷ��ɾ����")) return;
			}else{
				if(!confirm("��ͬʱɾ�������µ���Ȩģ��,ȷ��ɾ����Ȩ�����顾"+sceneName+"����?")) return;
			}
			as_delete('myiframe0');
			AsCredit.RunJavaMethodTrans("com.amarsoft.app.flow.util.RuleDelete","RuleDelete","SerialNo="+serialNo); 
		}
		reloadSelf();
	}
	/*����ģ��*/
	function copySceneGroup(){
		var authorizeType = "<%=authorizeType%>";
		AsControl.PopView("/Common/Configurator/Authorization/SelectCanCopyRuleList.jsp","AuthorizeType="+authorizeType,"dialogWidth:800px;dialogHeight:620px;resizable:yes;scrollbars:no;status:no;help:no");
		reloadSelf();
	}
	/*��¼��ѡ��ʱ�����¼�*/
	function mySelectRow(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var authorizeType = "<%=authorizeType%>";
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			return;
		}else{
			AsControl.OpenView("/Common/Configurator/Authorization/RuleSceneInfo.jsp","AuthSerialNo="+serialNo+"&AuthorizeType="+authorizeType,"rightdown","");
		}
	}
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
