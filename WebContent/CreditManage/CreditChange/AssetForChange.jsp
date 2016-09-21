<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
    String sCONTRACTSERIALNO = CurPage.getParameter("CONTRACTSERIALNO");
    
	String sSERIALNO = CurPage.getParameter("SERIALNO");
	if(sSERIALNO == null)     sSERIALNO = "";
	String CUSTOMERID = CurPage.getParameter("CUSTOMERID");
	String CUSTOMERNAME = CurPage.getParameter("CUSTOMERNAME");
	String CERTTYPE = CurPage.getParameter("CERTTYPE");
	String CERTID = CurPage.getParameter("CERTID");
	ASObjectModel doTemp = new ASObjectModel("AssetForChange");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("sSERIALNO");
	
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","确定","确定","sure()","","","","",""},
		};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
function sure(){
	if(typeof(SERIALNO)=="undefined" || SERIALNO.length==0){
		alert("请选择一笔借据信息！");
		return;
	}else{
		AsControl.OpenPage("/CreditManage/CreditChange/AssetChangeInfo.jsp","SERIALNO="+SERIALNO,"frame_info1");
	}
}
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
