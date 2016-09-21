<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    String isused=CurPage.getParameter("isused");
	String sSerialNo = CurPage.getParameter("SerialNo");
	
	if(sSerialNo == null) sSerialNo = "";
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("ClassifyConfirmList",BusinessObject.createBusinessObject(),CurPage);
	ASObjectWindow  dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{String.valueOf(isused.equals("0")),"All","Button","确认生效","确认生效","confirm()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function confirm(){	
		var serialNo = getItemValue(0,getRow(0),"CRSERIALNO");//分类编号		
		var classifyResult = getItemValue(0,getRow(0),"REFERENCEGRADE"); //系统分类结果

		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}	
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.ClassifyConfirm","confirm","SerialNo="+serialNo+",ClassifyResult="+classifyResult);
		alert(returnValue);
		reloadSelf();
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
