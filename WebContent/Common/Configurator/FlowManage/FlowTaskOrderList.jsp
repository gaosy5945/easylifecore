<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("FlowTaskOrderList",BusinessObject.createBusinessObject(),CurPage);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "0";	 //只读模式
	dwTemp.setPageSize(100);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","",""},
			{"true","","Button","保存","保存","saveRecord()","","","","",""},
			{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		as_add("myiframe0");
		setItemValue(0,getRow(),"ISINUSE","1");
		setItemValue(0,getRow(),"ORDERTYPE","jbo.app.BUSINESS_TYPE");
		setItemValue(0,getRow(),"INPUTUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"INPUTORGID","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(),"INPUTDATE","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
	}
	function saveRecord(){
		setItemValue(0,getRow(),"UpdateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"UPDATEORGID","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(),"UpdateDATE","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
		as_save("myiframe0");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
