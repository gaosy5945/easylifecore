<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String itemNo = CurPage.getParameter("ItemNo");
	if(itemNo == null) itemNo = "";

	String sTempletNo = "BusinessTypeCoreInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.setParameter("ItemNo", itemNo);
	dwTemp.genHTMLObjectWindow(itemNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","save()","","","",""},
		{"true","All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function save(){
		if(!iV_all("0")) return ;
		var itemNo = getItemValue(0, getRow(0), "ItemNo");
		var attribute2 = getItemValue(0, getRow(0), "Attribute2");
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.prd.config.loader.BusinessTypeCoreQuery", "query", "OldItemNo=<%=itemNo%>,ItemNo="+itemNo+",Attribute2="+attribute2);
		if(returnValue.split("@")[0] == "false"){
			alert(returnValue.split("@")[1]);
			return;
		}
		setItemValue(0, getRow, "SortNo", itemNo);
		setItemValue(0, getRow, "Attribute1", attribute2);
		as_save(0);
	}
	function returnList(){
		self.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
