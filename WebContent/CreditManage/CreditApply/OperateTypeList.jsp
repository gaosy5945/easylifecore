<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%
	//获得页面参数	
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
	//通过显示模版产生ASDataObject对象doTemp
	ASObjectModel doTemp = new ASObjectModel("OperateTypeList","");
	
	//生成DataWindow对象	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="1";   
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页
	
	//设置是否只读 1:只读 0:可写
    //dwTemp.ReadOnly="1";
	
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	
    String sButtons[][] = {
		{"true","All","Button","新增","新增","newRecord()","","","",""},	
		{"true","","Button","详情","详情","viewDetail()","","","",""},	
		{"true","All","Button","删除","删除","deleteRecord()","","","",""},	
	};
%> 

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>

<script type="text/javascript">
	function newRecord(){
		var dialogStyle="dialogWidth=500px;dialogHeight=400px;center:yes;resizable:yes;scrollbars:no;status:no;help:no";
		AsControl.PopComp("/CreditManage/CreditApply/OperateTypeInfo.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>",dialogStyle);
		//popComp("SortFlagInfo","/CreditManage/CreditApply/SortFlagInfo.jsp","TypeNo="+sTypeNo+"&ObjectNo="+sObjectNo,"dialogWidth=400px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();	
	}

	function viewDetail(){
		var dialogStyle="dialogWidth=500px;dialogHeight=400px;center:yes;resizable:yes;scrollbars:no;status:no;help:no";
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	        alert(getMessageText('AWEW1001')); //请选择一条信息！
	        return;
	    }
		AsControl.PopComp("/CreditManage/CreditApply/OperateTypeInfo.jsp","SerialNo="+sSerialNo,dialogStyle);
		reloadSelf();
	}

	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	        alert(getMessageText('AWEW1001')); //请选择一条信息！
	        return;
	    }
		if(!confirm("确认删除信息吗？")) return;
		as_delete('myiframe0');
	}
</script>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
</script>
<%/*~END~*/%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>