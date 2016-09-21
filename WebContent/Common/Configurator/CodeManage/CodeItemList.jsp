<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		Content: 代码表列表
	 */
	String sCodeNo = CurPage.getParameter("CodeNo"); //代码编号
	String sCodeName = CurPage.getParameter("CodeName");
	if(sCodeNo==null) sCodeNo="";
	if(sCodeName==null) sCodeName="";
	String sDiaLogTitle = "【"+sCodeName+"】代码：『"+sCodeNo+"』配置";

	ASObjectModel doTemp = new ASObjectModel("CodeItemList");
	if(sCodeNo!=null && !sCodeNo.equals("")){
		doTemp.appendJboWhere(" And CodeNo='"+sCodeNo+"'");
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage ,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(50);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{(sCodeNo.equals("")?"false":"true"),"","Button","新增","新增一条记录","newRecord()","","","",""},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","",""},		
		{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		popComp("CodeItemInfo","/Common/Configurator/CodeManage/CodeItemInfo.jsp","CodeNo=<%=sCodeNo%>&CodeName=<%=sCodeName%>","");
		reloadSelf();
	}
	
	function viewAndEdit(){
		var sCodeNo = getItemValue(0,getRow(),"CodeNo");
		var sItemNo = getItemValue(0,getRow(),"ItemNo");
		if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
        
       	popComp("CodeItemInfo","/Common/Configurator/CodeManage/CodeItemInfo.jsp","CodeName=<%=sCodeName%>&CodeNo="+sCodeNo+"&ItemNo="+sItemNo,"");
		reloadSelf();
	}
	
	function deleteRecord(){
		var sCodeNo = getItemValue(0,getRow(),"CodeNo");
       	if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		if(confirm(getHtmlMessage('2'))){
			as_delete("myiframe0");
		}
	}
	
	if(typeof("<%=sCodeNo%>")=="undefined" || "<%=sCodeNo%>".length==0){
	}else{
     	setDialogTitle("<%=sDiaLogTitle%>");
    }
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>