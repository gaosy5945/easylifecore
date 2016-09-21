<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	/*
        Author: undefined 2016-01-07
        Tester:
        Content: 示例详情页面
        Input Param:
        Output param:
        History Log: 
    */
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String merchandiseType = CurPage.getParameter("MerchandiseType");
	if(merchandiseType == null) merchandiseType = "";
	String merchandiseID = CurPage.getParameter("MERCHANDISEID");
	if(merchandiseID == null) merchandiseID = "";

	String sTempletNo = "MerchandiseInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDefaultValue("MERCHANDISETYPE", merchandiseType);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(merchandiseID);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/MerchandiseManage/js/Merchandise.js"></script>
<script type="text/javascript">
	function saveRecord(){
		var brandmodel = getItemValue(0,getRow(),'BRANDMODEL');
		var brand = getItemValue(0,getRow(),'MERCHANDISEBRAND');
		if(brandmodel.split("-")[0]!=brand){
			alert("商品品牌和商品型号不一致，请重新选择");
			return;
		}
		as_save(0);
		returnList();
	}
	function returnList(){
		 AsControl.OpenView("/MerchandiseManage/MerchandiseList.jsp", "MerchandiseType="+getItemValue(0,getRow(),'MERCHANDISETYPE'),"_self","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>