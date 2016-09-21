<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sCustomerID =  CurPage.getParameter("CustomerID");
	String sListType = CurPage.getParameter("ListType");

	if(sCustomerID == null) sCustomerID = "";
	String SerialNo =  CurPage.getParameter("SerialNo");
	if(SerialNo == null) SerialNo = "";

	String sTempletNo = "CustomerTelInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	if("0020".equals(sListType) || "0021".equals(sListType)){//�����̻��ŵ꣬��ϵ��ʽ��Ҫ������ϵ��
		doTemp.setVisible("OWNER",true);
		doTemp.setRequired("OWNER",true);
		doTemp.setVisible("RELATIONSHIP",true);
		doTemp.setRequired("RELATIONSHIP",true);
		doTemp.setDDDWJbo("RELATIONSHIP","jbo.sys.CODE_LIBRARY,itemNo,ItemName,Codeno='CustomerRelationShip' and itemNo in ('6000','1002') and IsInuse='1'");	
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("SerialNo", SerialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"true","","Button","����","�����б�","returnBack()","","","",""}
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<HEAD>
<title>��ϵ�绰��Ϣ</title>
</HEAD>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	function returnBack()
	{
	  AsControl.OpenPage("/CustomerManage/CustomerTelList.jsp","CustomerID="+"<%=sCustomerID%>","_self","");
	} 
	function changeFlag(){
		var TelType = getItemValue(0,getRow(),"TelType");
		if(TelType == "PB2004"){
			showItem(0,"ISINFORMATION");
			setItemRequired(0,"ISINFORMATION",true);
		}else{
			setItemValue(0,0,"ISINFORMATION","");
			setItemRequired(0,"ISINFORMATION",false);
			hideItem(0,"ISINFORMATION");
		}

	}
	function initRow(){
		changeFlag();
		var SerialNo = "<%=SerialNo%>";
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
		}
		setItemValue(0,0,"INTAREA","86");
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
