<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sDefaultNode = CurPage.getParameter("DefaultNode"); //Ĭ�ϴ򿪽ڵ�
	String UserID = CurPage.getParameter("UserID");
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��������","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	tviTemp.initWithSql("SerialNo","TagName","SerialNo","","","from OBJECT_TAG_CATALOG where SUBSCRIBERTYPE = '02' and SUBSCRIBERID='"+UserID+"'","Order By SerialNo",Sqlca);
	String sButtons[][] = {
		{"true","All","Button","��������","����һ����¼","newRecord()","","","","btn_icon_add"},
		{"true","All","Button","ɾ������","ɾ����ѡ�еļ�¼","deleteRecord()","","","","btn_icon_delete"},
	};
%><%@include file="/Resources/CodeParts/View07.jsp"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script><script type="text/javascript">
function startMenu(){
	<%=tviTemp.generateHTMLTreeView()%>
	expandNode('root');
	selectItem('<%=sDefaultNode%>');
}
	<%/*[Describe=������¼;]*/%>
	function newRecord(){
        OpenPage("/CustomerManage/MyOrgCustomerInfo.jsp","frameright","");
        reloadSelf();
	}
	
    function openChildComp(sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		AsControl.OpenView(sURL,sParaStringTmp,"frameright");
	}
	
	<%/*[Describe=����ڵ��¼�,�鿴���޸�����;]*/%>
	function TreeViewOnClick(){
		var sSerialNo = getCurTVItem().value;
		if(!sSerialNo){
			OpenPage("/AppMain/Blank.jsp?TextToShow=��ѡ�������ͼ�ڵ�!", "frameright");
		}else if(sSerialNo=="root"){
		}else{
	      	OpenPage("/CustomerManage/MyOrgCustomerTagList.jsp?SerialNo="+sSerialNo, "frameright"); 
		}
	}

	<%/*[Describe=ɾ����¼;]*/%>
	function deleteRecord(){
		var sSerialNo = getCurTVItem().value;
		if(sSerialNo == "root" || !sSerialNo){
			alert("��ѡ��һ�����飡");
			return ;
		}
		if(confirm("ɾ���÷��齫ͬʱɾ���÷��������Ŀͻ���\n��ȷ��ɾ����")){
			var sReturn = CustomerManage.deleteCustomerTag(sSerialNo);
			if(typeof sReturn != "undefined" && sReturn == "SUCCEED"){
			AsControl.OpenView("/CustomerManage/MyCustomerTree.jsp", "", "frameleft", "");
			AsControl.OpenView("/Blank.jsp","TextToShow=�������ѡ��һ��","frameright","");
			}
		}
	}

	
	startMenu();
</script>
<%@ include file="/IncludeEnd.jsp"%>