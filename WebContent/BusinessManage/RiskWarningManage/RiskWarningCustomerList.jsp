<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//<!---------当前用户的所有客户信息------------------>
	ASObjectModel doTemp = new ASObjectModel("RiskWarningCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	//用户编号
	String UserId = CurUser.getUserID();
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(UserId);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","预警详情","预警详情","edit()","","","","",""},		
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	function edit(){
		
		 var sUrl = "BusinessManage/RiskWarningManage/CustomerRiskWarning.jsp";
		 var sCustomerId = getItemValue(0,getRow(0),'CUSTOMERID');
		 if(typeof(sCustomerId)=="undefined" || sCustomerId.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		//AsControl.OpenPage(sUrl,'SerialNo=' +sPara ,'_self','');
		AsControl.PopComp(sUrl,"sCustomerId="+sCustomerId, "resizable=yes;dialogWidth=1200px;dialogHeight=1200px;center:yes;status:no;statusbar:no");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
