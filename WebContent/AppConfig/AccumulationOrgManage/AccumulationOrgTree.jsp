<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sDefaultNode = CurPage.getParameter("DefaultNode"); //默认打开节点
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"支行分组","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	tviTemp.initWithSql("SortNo","OrgName","SortNo","","","from ORG_INFO where BELONGORGID = '9800' and ORGLEVEL = '3'","Order By SortNo",Sqlca);
	String sButtons[][] = {
	};
%><%@include file="/Resources/CodeParts/View07.jsp"%>
<script type="text/javascript">
function startMenu(){
	<%=tviTemp.generateHTMLTreeView()%>
	expandNode('root');
	selectItem('<%=sDefaultNode%>');
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
		var SortNo = getCurTVItem().value;
		if(!SortNo){
			OpenPage("/AppMain/Blank.jsp?TextToShow=请选择左边树图节点!", "frameright");
		}else if(SortNo=="root"){
		}else{
	      	OpenPage("/AppConfig/AccumulationOrgManage/AccumulationInfo.jsp?SortNo="+SortNo, "frameright"); 
		}
	}
	
	startMenu();
</script>
<%@ include file="/IncludeEnd.jsp"%>