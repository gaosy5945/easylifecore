<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String endDays = CurPage.getParameter("EndDays");
	String MaturityDate = com.amarsoft.app.base.util.DateHelper.getRelativeDate(com.amarsoft.app.base.util.DateHelper.getBusinessDate(), com.amarsoft.app.base.util.DateHelper.TERM_UNIT_DAY, Integer.parseInt(endDays));
	ASObjectModel doTemp = new ASObjectModel("CLToDate");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	dwTemp.setParameter("MaturityDate", MaturityDate);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","详情","详情","view()","","","","btn_icon_detail",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function view(){
	 var serialNo = getItemValue(0,getRow(0),"SERIALNO");
	 if(typeof(serialNo) == "undefined" || serialNo.length == 0){
		 alert("请选择一条申请！");
		 return;
	 }
	 AsControl.PopComp("/CreditLineManage/CreditLineLimit/CreditLine/CLInfo.jsp","SerialNo="+serialNo,"resizable=yes;dialogWidth=900px;dialogHeight=420px;center:yes;status:no;statusbar:no");
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
