<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

    String flowSerialNo = CurPage.getParameter("FlowSerialNo");
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String flowNo = Sqlca.getString(new SqlObject("select FlowNo from FLOW_OBJECT where FlowSerialNo = :FlowSerialNo").setParameter("FlowSerialNo", flowSerialNo));
	String flowVersion = Sqlca.getString(new SqlObject("select FlowVersion from FLOW_OBJECT where FlowSerialNo = :FlowSerialNo").setParameter("FlowSerialNo", flowSerialNo));
	String phaseNo = CurPage.getParameter("PhaseNo");
    if(flowSerialNo == null) flowSerialNo = "";
    if(taskSerialNo == null) taskSerialNo = "";
    if(flowNo == null) flowNo = "";
    if(phaseNo == null) phaseNo = "";
    String tempno = "";
	if("".equals(taskSerialNo)){
		tempno = "CreditApproveList1";
	}else{
		tempno = "CreditApproveList";
	}
    ASObjectModel doTemp = new ASObjectModel(tempno);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("FlowSerialNo", flowSerialNo);
	dwTemp.setParameter("TaskSerialNo", taskSerialNo);
	dwTemp.setParameter("PhaseNo", phaseNo);
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","详情","详情","edit()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		var taskSerialNo = getItemValue(0,getRow(),"TASKSERIALNO");
		var flowSerialNo = getItemValue(0,getRow(),"FLOWSERIALNO");
		var phaseNo = getItemValue(0,getRow(),"PHASENO");
		var flowNo = "<%=flowNo%>";
		var flowVersion = "<%=flowVersion%>";
		if(typeof(taskSerialNo)=="undefined" || taskSerialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var returnValue = AsControl.RunASMethod("BusinessManage","QueryIsCanReadOpinion","<%=CurUser.getUserID()%>,"+flowSerialNo);
		//只有在统计查询时这样控制
		if(returnValue == "false" && "<%=tempno%>" == "CreditApproveList1"){
			alert("对不起！您没有权限查看详情。");
			return;
		}else{
			AsCredit.openFunction("SignTApproveInfo","FlowNo="+flowNo+"&FlowVersion="+flowVersion+"&TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo+"&RightType=ReadOnly");
		}
	}
/* function mySelectRow(){
		var taskSerialNo = getItemValue(0,getRow(),"TASKSERIALNO");
		var flowSerialNo = getItemValue(0,getRow(),"FLOWSERIALNO");
		var phaseNo = getItemValue(0,getRow(),"PHASENO");
		var flowNo = getItemValue(0,getRow(),"FLOWNO");
		var flowVersion = getItemValue(0,getRow(),"FLOWVERSION");
		 
		if(typeof(taskSerialNo)=="undefined" || taskSerialNo.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","rightdown","");
		}else{
			AsControl.OpenView("/CreditManage/CreditApprove/CreditApproveInfo01.jsp","RightType=ReadOnly&TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo+"&FlowNo="+flowNo+"&FlowVersion="+flowVersion,"rightdown","");
		}
	}
	mySelectRow();  */
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
