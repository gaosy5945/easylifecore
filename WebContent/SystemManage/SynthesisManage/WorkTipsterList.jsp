 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
 
<%
	//工作台提示 配置功能页面
	ASObjectModel doTemp = new ASObjectModel("WorkTipsList");
	String codeNo=CurPage.getParameter("CodeNo");
	doTemp.setHTMLStyle("RELATIVECODE","onClick='selctRole()'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "0";	 //编辑模式
	dwTemp.setPageSize(50);
	dwTemp.genHTMLObjectWindow(codeNo);
	
	String sButtons[][] = {
			{"true","","Button","新增","新增","add()","","","","",""},
			{"true","","Button","保存","保存","saveRecord()","","","","",""},
			{"true","","Button","设置角色","设置提示信息可查看角色","selctRole()","","","","",""},
			{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","",""},
		};
%> 
<script type="text/javascript">
	function add(){
		  as_add(0);  
		  setItemValue(0,getRow(),"CodeNo","<%=codeNo%>");
	}
	function saveRecord(){
		as_save("myiframe0","");		
	}
	function selctRole(){
		roles=getItemValue(0,getRow(),"RELATIVECODE");
		sReturn=AsDialog.OpenSelector("SelectAllRoles","","");
		if(typeof(sReturn)=="undefined" || sReturn=="_CANCEL_") return ;
		setItemValue(0,getRow(),"RELATIVECODE",sReturn);
		
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
 