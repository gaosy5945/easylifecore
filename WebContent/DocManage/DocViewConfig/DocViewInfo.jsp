<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sViewId = CurPage.getParameter("ViewId");
	if(sViewId == null) sViewId = " ";
	String sFolderId = CurPage.getParameter("FolderId");
	if(sFolderId == null) sFolderId = "root";
	String sParentFolder = CurPage.getParameter("ParentFolder");
	if(sParentFolder == null) sParentFolder = "root";
	String sGoBackType = CurPage.getParameter("GoBackType");
	if(sGoBackType == null) sGoBackType = " ";
	
	String sTempletNo = "DocViewInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sViewId + "," + sFolderId);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

	initRow();
	
	function returnList(){
		var sGoBackType = "<%=sGoBackType%>";
		if("1"==sGoBackType){
			OpenPage("/DocManage/DocViewConfig/DocViewConfigView.jsp", "_self");
		} else {
			OpenPage("/DocManage/DocViewConfig/DocViewList.jsp", "_self");
		}
	}
	
	function initRow(){
		if(getRowCount(0)==0){
			setItemValue(0,getRow(),"VIEWID","<%=sViewId%>");
			setItemValue(0,0,"FOLDERID","<%=sFolderId%>");
			setItemValue(0,0,"PARENTFOLDER","<%=sParentFolder%>");
		}
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
