<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("RuleSceneGroupList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����ģ��","����","add()","","","","",""},
			{"true","","Button","�༭ģ��","����","edit()","","","","",""},
			{"true","","Button","ɾ��ģ��","ɾ��","delete()","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 AsControl.OpenView("/Common/Configurator/Authorization/RuleSceneGroupInfo.jsp","","dialogWidth:400px;dialogHeight:320px;resizable:yes;scrollbars:no;status:no;help:no");
		 reloadSelf();
	}
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��ѡ��һ����¼��");
			return ;
		 }
		 AsControl.PopView("/Common/Configurator/Authorization/RuleSceneGroupInfo.jsp","SerialNo="+serialNo,"dialogWidth:400px;dialogHeight:320px;resizable:yes;scrollbars:no;status:no;help:no");
		 reloadSelf();
	}
	function deleteSceneGroup(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var sceneName = getItemValue(0, getRow(), "SceneName");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			if(!confirm("��ͬʱɾ�������µ���Ȩģ��,ȷ��ɾ����Ȩ�����顾"+sceneName+"����?")) return;
			as_delete('myiframe0');
			var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.flow.util.RuleDelete","RuleDelete","SerialNo="+serialNo); 
		}
		reloadSelf();
	}
	/*��¼��ѡ��ʱ�����¼�*/
	function mySelectRow(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			return;
		}else{
			AsControl.OpenView("/Common/Configurator/Authorization/RuleSceneList.jsp","AuthSerialNo="+serialNo,"rightdown","");
		}
	}
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
