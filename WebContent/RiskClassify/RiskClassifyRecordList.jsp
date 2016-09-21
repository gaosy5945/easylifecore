<%@ page contentType="text/html; charset=GBK"%>
 <%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String status = CurPage.getParameter("Status");
	if(status == null) status = "";
	
	ASObjectModel doTemp = new ASObjectModel("RiskClassifyRecordList");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.setParameter("Status", status);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	function edit(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("请选择一条记录！");
			return ;
		}
		var returnValue =RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.ClassifyAdjustInfo","getFlowSerialNo","SerialNo="+serialNo);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		AsCredit.openFunction("ViewClassifyInfo","SerialNo="+serialNo+"&RightType=ReadOnly&FlowSerialNo="+returnValue);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
