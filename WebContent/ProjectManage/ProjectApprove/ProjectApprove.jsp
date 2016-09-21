<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%		
	String Status = CurPage.getParameter("Status");
	if(Status == null) Status = ""; 
	ASObjectModel doTemp = new ASObjectModel("ProjectApprove");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("STATUS", Status);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","合作项目详情","合作项目详情","editProject()","","","","",""},
			{"02".equals(Status)?"false":"true","All","Button","签署意见","签署意见","signOpinion()","","","","",""},
			{"02".equals(Status)?"false":"true","All","Button","提交","提交","submitProject()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function editProject(){
		
	}
	function signOpinion(){
		
	}
	function submitProject(){
		var result = AsControl.PopComp("/ProjectManage/ProjectApprove/submitProjectDialog.jsp","","resizable=yes;dialogWidth=500px;dialogHeight=200px;center:yes;status:no;statusbar:no");

	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
