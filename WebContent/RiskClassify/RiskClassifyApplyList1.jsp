<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    String CLASSIFYSTATUS = CurPage.getParameter("Itemno");
	ASObjectModel doTemp = new ASObjectModel("DUEBILL_RISK_APPLY");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	
	dwTemp.genHTMLObjectWindow(CLASSIFYSTATUS);
	
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","申请详情","申请详情","viewAndEdit()","","","","",""},
			{"true","","Button","查看意见","查看意见","edit()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

function viewAndEdit(){
	var serialNo=getItemValue(0,getRow(),"SerialNo");
	if(typeof(serialNo)=="undefined" || serialNo.length==0) 
	{
		alert(getHtmlMessage('1'));//请选择一条信息！
		return ;
	}
	AsControl.PopComp("/RiskClassify/SingleAdjust.jsp", "SerialNo="+serialNo);
	reloadSelf();
}


	 
	 
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
