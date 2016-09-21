<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String sObjectNo = CurPage.getParameter("ObjectNo");//项目编号
	if(sObjectNo == null) sObjectNo = "";
	String sObjectType = DataConvert.toString(CurPage.getParameter("ObjectType"));//项目类型

	String sTempletNo = "ProjectAssetAcctFeeList";//--模板号--
	String sTempletFilter = "1=1"; 
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setReadOnly("*", true);
	doTemp.setJboWhere("O.ObjectNo=:sObjectNo and ObjectType=:sObjectType");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "0";	 //编辑模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	String sButtons[][] = {
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除","del()","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	function add(){
		initSerialNo();
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sUrl = "/AssetTransfer/AcctFeeInfo.jsp";
		AsControl.OpenPage(sUrl,"SerialNo="+sSerialNo+"&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","_self");
	}
	
	function edit(){
	 	var sUrl = "/AssetTransfer/AcctFeeInfo.jsp";
	 	var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
	 	//alert(sSerialNo);
		if(typeof(sSerialNo) == 'undefined' || sSerialNo.length == 0){
			alert("请先选择一条记录");
			return;
		}
		AsControl.OpenPage(sUrl,"SerialNo="+sSerialNo+"&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","_self");
	}
	
	function del(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(serialNo) == 'undefined' || serialNo.length == 0){
			alert("请先选择一条记录");
			return;
		}
		
		if(confirm('确实要删除吗?')){
			as_delete(0);
		}
	}
	
	function initSerialNo() 
	{
		var sTableName = "ACCT_FEE";//表名
		var sColumnName = "SERIALNO";//字段名
		var sPrefix = "";//前缀
		var sSerialNo = PopPageAjax("/Frame/page/sys/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>