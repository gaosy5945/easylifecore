<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	
    if(objectNo == null) objectNo = "";
    if(objectType == null) objectType = "";
	
    ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("PutoutConditionList", SystemHelper.getPageComponentParameters(CurPage), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	doTemp.setDDDWJbo("STATUS","jbo.sys.CODE_LIBRARY,itemNo,ItemName,Codeno='BPMCheckItemStatus'  and ItemNo like '2%' and IsInuse='1' ");
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "0";	 //只读模式
	dwTemp.setPageSize(3);
	dwTemp.genHTMLObjectWindow(objectNo+","+objectType);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","保存","保存","save()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function save(){
		if(getRowCount(0)<=0){
			return;
		}
		as_save("myiframe0","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
