 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String menuId=CurPage.getParameter("MenuID");
	if(menuId==null) menuId="";
	ASObjectModel doTemp = new ASObjectModel("SysFunctionCatalogList");
	doTemp.appendJboWhere(" MenuID like '"+menuId+"%'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("SerialNo");
	
	String sButtons[][] = {
			{"true","","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","复制","复制","copy()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'')","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	function add(){
		 AsControl.PopComp("/AppConfig/FunctionManage/FunctionCatalogInfo.jsp","FunctionID=&MenuID=<%=menuId%>","");
		 reloadSelf();
	}
	
	function copy(){
		var functionID = getItemValue(0,getRow(),"FunctionID");		
		if (typeof(functionID)=="undefined" || functionID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		var result = RunJavaMethodTrans("com.amarsoft.app.als.sys.function.action.SysFunctionService", "copyFunctionConfig", "FunctionID="+functionID);
		if(result == "false"){
			alert("已存在复制信息！");
		} else {
			alert("复制成功，FunctionID为CopyOf"+functionID);
		}
		reloadSelf();
	}
	
	function edit(){
		var functionID = getItemValue(0,getRow(),"FunctionID");		
		if (typeof(functionID)=="undefined" || functionID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		AsControl.PopComp("/AppConfig/FunctionManage/FunctionCatalogInfo.jsp","FunctionID="+functionID,'','');
		reloadSelf();
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
 