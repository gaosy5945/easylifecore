 
<%@page import="com.amarsoft.app.als.sys.widget.DWToTreeTable"%>
<%@page import="com.amarsoft.app.als.sys.widget.TreeTable"%>
<%@page import="com.amarsoft.dict.als.object.Item"%>

<%@page import="com.amarsoft.awe.dw.ASObjectModel"%>
<%@page import="com.amarsoft.awe.dw.ASObjectWindow"%>
<%@page import="com.amarsoft.app.als.sys.widget.MutilDWToTreeTable"%>
<%@page import="com.amarsoft.app.als.credit.common.model.CreditConst"%>
 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 
<style>
	.div_detail{
		position:relative; 
		width:100%; 
		height:400px;
		z-index: 100;
		background-color: white; 
	}
 
</style>
 
 <%
 //OBJECTTYPE=CreditApply,OBJECTNO=2014031400000025
	 String objectType=CurPage.getParameter("ObjectType");
	 String objectNo=CurPage.getParameter("ObjectNo");
	ASObjectModel doTemp = new ASObjectModel("CLList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(objectType+","+objectNo);
	
	 	
	 	MutilDWToTreeTable dwTree=new MutilDWToTreeTable(dwTemp,"PARENTSERIALNO","SERIALNO",objectNo);
	 if(objectType.equals(CreditConst.CREDITOBJECT_CONTRACT_REAL)){
		 	dwTree.setDefaultValue("Button","<a href='#' onClick='javascript:viewBusiness(this)'>ʹ�����</a>");

	 }else{
		 
	 	dwTree.setDefaultValue("Button","<a href='#' onClick='javascript:viewAndEdit(this)'>����</a> <a  href='#' onClick='javascript:deleteRecord(this)'>ɾ��</a> <a  href='#' onClick='javascript:addClInfo(this)'>����</a>");
	 }
	 	String sButtons[][] = {
	 		   {"true","","Button","�������䷽��","�������䷽��","addRecord()","","","",""},
	 		   {"true","","Button","ʹ�����","ʹ�����","viewUse()","","","",""},
	 		   {"false","","Button","����","����","viewAndEdit()","","","",""},
	 		   {"false","","Button","ɾ��","ɾ��","viewHistory()","","","",""}
	 };
 %>
 
<%@ include file="/AppMain/resources/include/treetable_include.jsp"%>
 <%
 	out.print(dwTree.getHtml());
	 List<String>	lstTable=dwTree.getTreeTableId();
 %> 
<script type="text/javascript">
	$(document).ready(function() {
	    <%
	    	for(String tableId:lstTable){
	    		
	    		out.print("initTreeTable('"+tableId+"')\n");
	    	}
	    %>
	});
	 var sUrl = "/CreditLineManage/CreditLineAccount/CLInfo.jsp";

	function add(){
		 var sUrl = "/CreditLineManage/CreditLineAccount/CLInfo.jsp";
		 AsControl.OpenPage(sUrl,"ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","_self");
	}

	function viewAndEdit(obj){ 	
		var serialNo=getValue(obj,"SerialNo");
		AsControl.PopComp(sUrl,"SerialNo="+serialNo,"");
		reloadSelf2();

	}

	function deleteRecord(obj){
		//alert(typeof(DZ));
		//alert(JSON.stringify(DZ));
		var serialNo=getValue(obj,"SerialNo");
		if(!confirm("��ɾ����ǰ�ڵ㼰���½ڵ�,��ȷ��Ҫɾ����?")) return ;
		sReturn=AsCredit.doAction("5010","SerialNo="+serialNo);
	//	alert(sReturn);
		if(sReturn=="success"){
			//alert("ɾ���ɹ�!");
			reloadSelf2();
		}else{
			alert(sReturn);
		}
	}

	function reloadSelf2(){
		 AsControl.OpenPage("/CreditLineManage/CreditLineAccount/CLTreeList.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&ParentSerialNo=<%=objectNo%>","_self");
	}
	function addClInfo(obj){
			var serialNo=getValue(obj,"SerialNo"); 
			var sUrl = "/CreditLineManage/CreditLineAccount/CLInfo.jsp";
			AsControl.PopComp(sUrl,"ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&ParentSerialNo="+serialNo,"");
			reloadSelf2();
	 }
	function viewUse(){
		objectType="<%=objectType%>";
		objectNo="<%=objectNo%>";
		AsCredit.openFunction("CreditLineUse","ObjectType="+objectType+"&ObjectNo="+objectNo);
	}

	 function addRecord(){
		 var sUrl = "/CreditLineManage/CreditLineAccount/CLInfo.jsp";
		 AsControl.PopComp(sUrl,"ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&ParentSerialNo=<%=objectNo%>","");
		 reloadSelf2();
	 }
	var detail;
	 function viewBusiness(obj){
		var serialNo=getValue(obj,"SerialNo"); 
		if(detail==null){
			$(".div_bg").show();
			detail=$("<div class='div_detail'></div>").appendTo(document.body);
			// $("<a class=''>�ر�</a>").appendTo(detail);
			$("<iframe name='detail' style='width:99%;height:100%'  frameborder=\"0\"></iframe>").appendTo(detail);
			 
			AsControl.OpenPage("/CreditManage/CreditLine/lineSubList.jsp","LineNo="+serialNo,"detail","");
		}else{
			detail.show();
			AsControl.OpenPage("/CreditManage/CreditLine/lineSubList.jsp","LineNo="+serialNo,"detail","");
		}
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>
 