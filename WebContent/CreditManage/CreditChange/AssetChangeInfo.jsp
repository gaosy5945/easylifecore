<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sSerialNo = CurPage.getParameter("RelativeObjectNo");
	if(sSerialNo == null) sSerialNo = "";
	String sTempletNo = "AssetChangeInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sSerialNo);
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			//{"true","","Button","提交","提交","commit()","","","","btn_icon_detail",""},
		};
	
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
function commit(){
	var serialNo = '<%=sSerialNo%>';
	var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.contract.action.RmnTfrRsrvAmtAplCommit", "rmnTfrRsrvAmtAplCommit",   "SERIALNO="+serialNo);
	if(typeof(sReturn) == "undefined" || sReturn.length == 0) return;
	
	if(sReturn.split("@")[0] == "true")
	{
		alert(sReturn.split("@")[1]);
		AsControl.OpenView("/BillPrint/OnetimeChg.jsp","SerialNo="+serialNo,"_blank");//专户一次性转备用金
	}
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>