<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sDefaultNode = CurPage.getParameter("DefaultNode"); //默认打开节点
	String UserID = CurPage.getParameter("UserID");
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"机构分组","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	tviTemp.initWithSql("SerialNo","TagName","SerialNo","","","from OBJECT_TAG_CATALOG where SUBSCRIBERTYPE = '02' and SUBSCRIBERID='"+UserID+"'","Order By SerialNo",Sqlca);
	String sButtons[][] = {
		{"true","All","Button","新增分组","新增一条记录","newRecord()","","","","btn_icon_add"},
		{"true","All","Button","删除分组","删除所选中的记录","deleteRecord()","","","","btn_icon_delete"},
	};
%><%@include file="/Resources/CodeParts/View07.jsp"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script><script type="text/javascript">
function startMenu(){
	<%=tviTemp.generateHTMLTreeView()%>
	expandNode('root');
	selectItem('<%=sDefaultNode%>');
}
	<%/*[Describe=新增记录;]*/%>
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
	
	<%/*[Describe=点击节点事件,查看及修改详情;]*/%>
	function TreeViewOnClick(){
		var sSerialNo = getCurTVItem().value;
		if(!sSerialNo){
			OpenPage("/AppMain/Blank.jsp?TextToShow=请选择左边树图节点!", "frameright");
		}else if(sSerialNo=="root"){
		}else{
	      	OpenPage("/CustomerManage/MyOrgCustomerTagList.jsp?SerialNo="+sSerialNo, "frameright"); 
		}
	}

	<%/*[Describe=删除记录;]*/%>
	function deleteRecord(){
		var sSerialNo = getCurTVItem().value;
		if(sSerialNo == "root" || !sSerialNo){
			alert("请选择一个分组！");
			return ;
		}
		if(confirm("删除该分组将同时删除该分组所属的客户，\n您确定删除吗？")){
			var sReturn = CustomerManage.deleteCustomerTag(sSerialNo);
			if(typeof sReturn != "undefined" && sReturn == "SUCCEED"){
			AsControl.OpenView("/CustomerManage/MyCustomerTree.jsp", "", "frameleft", "");
			AsControl.OpenView("/Blank.jsp","TextToShow=请在左侧选择一项","frameright","");
			}
		}
	}

	
	startMenu();
</script>
<%@ include file="/IncludeEnd.jsp"%>