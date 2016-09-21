<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

	<%
	String PG_TITLE = "合作项目信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%	
	String serialNo = CurPage.getParameter("PrjSerialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "ProjectInfo";//模型编号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage ,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
%>
<%/*~END~*/%>

	<%
	String sButtons[][] = {
		{"true","All","Button","保存","保存","saveRecord()","","","",""},
		};
	%> 
<%/*~END~*/%>


<%@include file="/Frame/resources/include/ui/include_info.jspf"%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	function saveRecord()
	{
	    var projectSerialNo=getItemValue(0,getRow(),"SerialNo");
	    as_save("myiframe0");	
	}
	
	
	</script>
<%/*~END~*/%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>