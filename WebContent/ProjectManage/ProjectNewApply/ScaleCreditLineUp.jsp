<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String prjSerialNo = CurPage.getParameter("ObjectNo");
	if(prjSerialNo == null) prjSerialNo = "";
	String ProductList = "";
	String ParticipateOrg = "";
	
	
	//��������Ϣ
	String CLType = Sqlca.getString(new SqlObject("select CLType from CL_INFO where ObjectType = :ObjectType and ObjectNo = :ObjectNo and ParentSerialNo is null ").setParameter("ObjectType", "jbo.prj.PRJ_BASIC_INFO").setParameter("ObjectNo", prjSerialNo));
	
	if(CLType != null)
	{
		com.amarsoft.dict.als.object.Item item = com.amarsoft.dict.als.cache.CodeCache.getItem("CLType", CLType);
		String className = item.getItemDescribe();
		if(className != null)
		{
			Class c = Class.forName(className);
			com.amarsoft.app.als.cl.CreditObject co = (com.amarsoft.app.als.cl.CreditObject)c.newInstance();
			co.load(Sqlca.getConnection(), "jbo.prj.PRJ_BASIC_INFO", prjSerialNo);
			co.calcBalance();
			co.saveData(Sqlca.getConnection());
			Sqlca.commit();
		}
	}
	
	String sTempletNo = "ScaleCreditLineInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform

	dwTemp.genHTMLObjectWindow(prjSerialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","","btn_icon_save",""},
	};

%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function saveRecord(){
		var sReturn = ProjectManage.selectIsSaveProjectInfo("<%=prjSerialNo%>");
		if(sReturn != "SUCCEED"){
			alert("���ȱ�����Ŀ������Ϣ��");
			return;
		}else{
			as_save(0,"reloadPage()");
		}
	}
	function reloadPage(){
		var SerialNo = getItemValue(0,getRow(),"SERIALNO");
		var ProjectSerialNo = "<%=prjSerialNo%>";
		var DivideType = getItemValue(0,getRow(),"DIVIDETYPE");
		var ObjectNo = getItemValue(0,getRow(),"OBJECTNO");
		var ObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
		var BusinessAppAmt = getItemValue(0,getRow(),"BUSINESSAPPAMT");
		var RevolvingFlag = getItemValue(0,getRow(),"REVOLVINGFLAG");
		var InputUserID = "<%=CurUser.getUserID()%>";
		var InputOrgID = "<%=CurOrg.getOrgID()%>";
		var InputDate = "<%=DateHelper.getBusinessDate()%>";
		var sReturn = ProjectManage.CreateAndUpdateCL(SerialNo,ProjectSerialNo,DivideType,ObjectNo,ObjectType,BusinessAppAmt,RevolvingFlag,InputUserID,InputOrgID,InputDate);
		if(sReturn == "SUCCEED"){
			parent.OpenInfo();
		}
	}

	function mySelect(){
		var divideType = getItemValue(0,getRow(),"DIVIDETYPE");
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		var prjSerialNo = "<%=prjSerialNo%>";
		var businessAppAmt = getItemValue(0,getRow(),"BUSINESSAPPAMT");
		var ProductList = "<%=ProductList%>";
		var ParticipateOrg = "<%=ParticipateOrg%>";
		if(typeof(serialNo) == "undefined" || serialNo.length == 0) return;
		
		if(divideType == "00"){
			AsControl.OpenView("/Blank.jsp","","rightdown","");
		}else if(divideType == "10"){
			AsControl.OpenView("/ProjectManage/ProjectNewApply/ScaleCLDownListProduct.jsp","parentSerialNo="+serialNo+"&PrjSerialNo="+prjSerialNo+"&divideType="+divideType+"&businessAppAmt="+businessAppAmt+"&ProductList="+ProductList,"rightdown","");
		}else{
			AsControl.OpenView("/ProjectManage/ProjectNewApply/ScaleCLDownListOrg.jsp","parentSerialNo="+serialNo+"&PrjSerialNo="+prjSerialNo+"&divideType="+divideType+"&businessAppAmt="+businessAppAmt+"&ParticipateOrg="+ParticipateOrg,"rightdown","");
		}
	}
	function initRow(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		var sReturn = ProjectManage.selectPrjStatus("<%=prjSerialNo%>");
		if(sReturn == "13"){
			setItemValue(0,0,"STATUS","20");
		}
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateHelper.getBusinessDate()%>");
			setItemValue(0,0,"OBJECTNO","<%=prjSerialNo%>");
			setItemValue(0,0,"OBJECTTYPE","jbo.prj.PRJ_BASIC_INFO");
		}
		mySelect();
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
