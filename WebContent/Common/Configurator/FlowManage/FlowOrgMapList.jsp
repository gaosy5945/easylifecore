<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String flowOrgMapType = CurPage.getParameter("FlowOrgMapType");
	if(flowOrgMapType == null || flowOrgMapType == "undefined") flowOrgMapType = "";
	ASObjectModel doTemp = new ASObjectModel("FlowOrgMapList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(flowOrgMapType);

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
		AsControl.PopView("/Common/Configurator/FlowManage/FlowOrgMapInfo.jsp","FlowOrgMapType=<%=flowOrgMapType%>","_self");
		reloadSelf();
	}
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		 AsControl.PopView("/Common/Configurator/FlowManage/FlowOrgMapInfo.jsp","SerialNo="+serialNo,"_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
