<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sSerialNo = CurPage.getParameter("SerialNo");
	
	if(sSerialNo == null) sSerialNo = "";

	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("ClassifyRemindList",BusinessObject.createBusinessObject(),CurPage);
	ASObjectWindow  dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","业务详情","业务详情","view()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function view(){
		 var serialNo = getItemValue(0,getRow(0),"SERIALNO");//借据编号
		 var crSerialNo = getItemValue(0,getRow(0),"CRSERIALNO");//分类编号
		 AsCredit.openFunction("ClassifyRemindInfo","DuebillNo="+serialNo+"&CRSerialNo="+crSerialNo);
	     reloadSelf();
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
