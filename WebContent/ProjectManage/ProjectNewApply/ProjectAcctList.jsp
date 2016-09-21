<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectNo = CurPage.getParameter("ObjectNo");
	if(objectNo == null) objectNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("ProjectAcctList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","",""},
			{"true","","Button","详情","详情","edit()","","","","",""},
			{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var objectType = "jbo.guaranty.CLR_MARGIN_INFO";
		var SerialNo = "";
		AsControl.OpenView("/ProjectManage/ProjectNewApply/ProjectAcctInfo.jsp","ObjectType="+objectType+"&SerialNo="+SerialNo+"&ObjectNo="+"<%=objectNo%>","_self","");
	}
	function edit(){
		 var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		 if(typeof(SerialNo)=="undefined" || SerialNo.length==0 ){
			alert("请选择一条信息！");
			return ;
		 }
		 AsControl.OpenView("/ProjectManage/ProjectNewApply/ProjectAcctInfo.jsp","SerialNo="+SerialNo+"&ObjectNo="+"<%=objectNo%>","_self","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
