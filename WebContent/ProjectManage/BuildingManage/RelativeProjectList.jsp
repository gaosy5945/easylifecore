<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	ASObjectModel doTemp = new ASObjectModel("RelativeProjectList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","项目详情","项目详情","edit()","","","","btn_icon_detail",""},
		};
%>
<HEAD>
<title>关联项目查询</title>
</HEAD>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("请选择一条信息！");
			return;
		}
	    AsCredit.openFunction("ProjectInfoTab", "SerialNo="+serialNo+"&RightType="+"ReadOnly");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
