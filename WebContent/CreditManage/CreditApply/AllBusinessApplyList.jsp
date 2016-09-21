<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String approveStatus = CurPage.getParameter("ApproveStatus");
	ASObjectModel doTemp = new ASObjectModel("AllBusinessApplyList");
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");//	
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
		//{"true","","Button","流转信息","流转信息","taskQry()","","","","",""},
		{"true","","Button","详情","查看/修改详情","edit()",""},
		//{"true","","Button","历史签署意见","历史签署意见","opinionLast()","","","","",""},
		{"true","","Button","导出","导出Excel","Export()","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function taskQry(){
		var flowSerialNo = getItemValue(0,getRow(),"FlowSerialNo");
		var isShowOpinion = "Y";
		if(typeof(flowSerialNo) == "undefined" || flowSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		AsControl.PopView("/Common/WorkFlow/QueryFlowTaskList.jsp", "FlowSerialNo="+flowSerialNo+"&IsShowOpinion="+isShowOpinion,"dialogWidth:1300px;dialogHeight:590px;");
	}
	function opinionLast(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		} 
		var flowSerialNo = getItemValue(0,getRow(0),'FlowSerialNo');
		AsControl.PopView("/CreditManage/CreditApprove/CreditApproveList.jsp", "FlowSerialNo="+flowSerialNo);
	}
	function edit(){
		var serialNo = getItemValue(0, getRow(0), "SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//打开页面
		AsCredit.openFunction("ApplyMessageInfo","ObjectNo="+serialNo+"&ObjectType=jbo.app.BUSINESS_APPLY&RightType=ReadOnly","");
	}
	
	function Export(){
		if(s_r_c[0] > 1000){
			alert("导出数据量过大，请控制在1000笔内。");
			return;
		}
		as_defaultExport();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
