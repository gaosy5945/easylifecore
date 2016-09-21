<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String projectSerialNo = CurPage.getParameter("SerialNo");
	if(projectSerialNo == null) projectSerialNo = "";

	ASObjectModel doTemp = new ASObjectModel("PrjAlterHistory");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ObjectNo", projectSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","变更详情","变更详情","view()","","","","",""},
		};
%>
<HEAD>
<title>项目变更历史</title>
</HEAD>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function view(){
		var SerialNo = getItemValue(0,getRow(),"SERIALNO");
		var ProjectSerialNo = getItemValue(0,getRow(),"PROJECTSERIALNO");
		var ObjectNo = getItemValue(0,getRow(),"OBJECTNO");
		var RelativeType = getItemValue(0,getRow(),"RELATIVETYPE");
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			alert("请选择一条信息！");
			return;
		}
		var CustomerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var functionID = "ProjectAlterInfo";
		var readFlag = "ReadOnly";
		var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectFlowSerialNo", "selectFlowSerialNo", "ObjectNo="+ProjectSerialNo);
		AsCredit.openFunction(functionID,"SerialNo="+ProjectSerialNo+"&CustomerID="+CustomerID+"&RightType="+readFlag+"&flowSerialNo="+flowSerialNo,"");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
