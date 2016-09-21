<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String userID = CurUser.getUserID();
	ASObjectModel doTemp = new ASObjectModel("BusinessApplyAllList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("UserID", userID);
	dwTemp.genHTMLObjectWindow(userID);

	String sButtons[][] = {
		//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
		{"true","","Button","详情","详情","edit()","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		var serialNo = getItemValue(0, getRow(0), "SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//打开页面
		AsCredit.openFunction("ApplyInfo","ObjectNo="+serialNo+"&ObjectType=jbo.app.BUSINESS_APPLY&RightType=ReadOnly","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
