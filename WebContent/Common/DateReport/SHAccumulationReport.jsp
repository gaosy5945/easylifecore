<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	BusinessObject inputParameter = SystemHelper.getPageComponentParameters(CurPage);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("SHAccumulationReport", inputParameter, CurPage, request);
	
	ASDataObject doTemp = dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.als.report.action.SHAccumulationReport");
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
	};
	sASWizardHtml = "<p><font color='red' size='3'>&nbsp;&nbsp;请选择要查询月份的月末日期</font></p>";
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">


</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
