<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String LAWCASESERIALNO = CurPage.getParameter("LAWCASESERIALNO");
	if(LAWCASESERIALNO == null) LAWCASESERIALNO = "";
	String SerialNo = CurPage.getParameter("SerialNo");
	if(SerialNo == null) SerialNo = "";
	String sTempletNo = "CloseDownAssetInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	//doTemp.setDefaultValue("BOOKTYPE","100");
	
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(SerialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"true","All","Button","取消","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		self.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
