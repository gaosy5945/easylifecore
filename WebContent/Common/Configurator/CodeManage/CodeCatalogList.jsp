<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		Content: 代码目录列表
	 */
	//获得页面参数	
	String sCodeTypeOne =  CurPage.getParameter("CodeTypeOne");
	String sCodeTypeTwo =  CurPage.getParameter("CodeTypeTwo");
	//将空值转化为空字符串	
	if (sCodeTypeOne == null) sCodeTypeOne = ""; 
	if (sCodeTypeTwo == null) sCodeTypeTwo = ""; 

	ASObjectModel doTemp = new ASObjectModel("CodeCatalogList");
 		
	if(sCodeTypeOne!=null && !sCodeTypeOne.equals("")) doTemp.appendJboWhere(" and CodeTypeOne='"+sCodeTypeOne+"'");
	if(sCodeTypeTwo!=null && !sCodeTypeTwo.equals("")) doTemp.appendJboWhere(" and CodeTypeTwo='"+sCodeTypeTwo+"'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","",""},
		{"true","","Button","代码列表","查看/修改代码详情","viewAndEditCode()","","","",""},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
		{"false","","Button","生成SortNo","生成SortNo","GenerateCodeCatalogSortNo()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("CodeCatalogInfo","/Common/Configurator/CodeManage/CodeCatalogInfo.jsp","CodeTypeOne=<%=sCodeTypeOne%>&CodeTypeTwo=<%=sCodeTypeTwo%>","");
		reloadSelf();        
	}
	
	function viewAndEdit(){
       var sCodeNo = getItemValue(0,getRow(),"CodeNo");
       if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
  		popComp("CodeCatalogInfo","/Common/Configurator/CodeManage/CodeCatalogInfo.jsp","CodeNo="+sCodeNo,"");
	}
    
    /*~[Describe=查看及修改代码详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEditCode(){
       var sCodeNo = getItemValue(0,getRow(),"CodeNo");
       var sCodeName = getItemValue(0,getRow(),"CodeName");
       if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		popComp("CodeItem","/Common/Configurator/CodeManage/CodeItemList.jsp","CodeNo="+sCodeNo+"&CodeName="+sCodeName,"");  
	}

	function deleteRecord(){
		var sCodeNo = getItemValue(0,getRow(),"CodeNo");
		if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		if(confirm(getHtmlMessage('45'))){
			as_delete("myiframe0");
		}
	}
	
	function GenerateCodeCatalogSortNo(){
		RunJavaMethodTrans("com.amarsoft.app.configurator.bizlets.GenerateCodeCatalogSortNo ","generateCodeCatalogSortNo","");
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>