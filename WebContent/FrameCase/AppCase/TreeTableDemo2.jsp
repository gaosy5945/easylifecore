<%@page import="com.amarsoft.app.als.sys.widget.DWToTreeTable"%>
<%@page import="com.amarsoft.app.als.sys.widget.TreeTable"%>
<%@page import="com.amarsoft.awe.dw.ASObjectModel"%>
<%@page import="com.amarsoft.awe.dw.ASObjectWindow"%>
 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
 //OBJECTTYPE=CreditApply,OBJECTNO=2014031400000025
	String objectType="CreditApply";
	String objectNo="2014031400000025";
	ASObjectModel doTemp = new ASObjectModel("CLList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(objectType+","+objectNo);
	
	 	
 	DWToTreeTable dwTree=new DWToTreeTable(dwTemp,"PARENTSERIALNO","SERIALNO","");
 	dwTree.setDefaultValue("Button","<a href='#' onClick='javascript:viewAndEdit(this)'>����</a> <a  href='#' onClick='javascript:viewAndEdit(this)'>ɾ��</a> <a  href='#' onClick='javascript:addClInfo(this)'>����</a>");
 	String sButtons[][] = {
		{"true","","Button","�������䷽��","�������䷽��","addRecord()","","","",""},
	   	{"true","","Button","����","����","viewAndEdit()","","","",""},
	   	{"true","","Button","ɾ��","ɾ��","viewHistory()","","","",""}
 	};
%><%@ include file="/AppMain/resources/include/treetable_include.jsp"%>
<%
 	out.print(dwTree.getHTML());
%> 
 <script type="text/javascript">
	$(document).ready(function() {
		initTreeTable("<%=dwTree.getTableId()%>");
	});

	function add(){
		 var sUrl = "/CreditLineManage/CreditLineAccount/CLInfo.jsp";
		 AsControl.OpenPage(sUrl,"ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","_self");
	}

	function viewAndEdit(obj){ 
		 alert(getValue(obj,"INPUTUSERID"));
	}

	function addClInfo(obj){
		var serialNo=getValue(obj,"SerialNo");
		var sUrl = "/CreditLineManage/CreditLineAccount/CLInfo.jsp";
		AsControl.PopComp(sUrl,"ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&ParentSerialNo="+serialNo,"");
	}

	function addRecord(){
		var sUrl = "/CreditLineManage/CreditLineAccount/CLInfo.jsp";
		AsControl.PopComp(sUrl,"ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>