<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	/*
        Author: undefined 2016-01-07
        Tester:
        Content: ʾ������ҳ��
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

	String sTempletNo = "MerchandiseInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDefaultValue("MERCHANDISETYPE", merchandiseType);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(merchandiseID);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","All","Button","����","�����б�","returnList()","","","",""}
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
			alert("��ƷƷ�ƺ���Ʒ�ͺŲ�һ�£�������ѡ��");
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