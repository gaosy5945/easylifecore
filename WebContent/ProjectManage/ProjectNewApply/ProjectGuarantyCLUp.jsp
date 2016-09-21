<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String prjSerialNo = CurComp.getParameter("SerialNo");
	if(prjSerialNo == null) prjSerialNo = "";

	//处理额度信息
	String CLType = "",objectType = "",objectNo = "";
	
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select CL.CLType,CL.ObjectType,CL.ObjectNo from CL_INFO CL,PRJ_RELATIVE PR where CL.OBJECTNO=PR.ObjectNo and CL.OBJECTTYPE=PR.OBJECTTYPE and CL.ParentSerialNo is null and PR.ObjectType = 'jbo.guaranty.GUARANTY_CONTRACT' and PR.ProjectSerialNo=:ProjectSerialNo ").setParameter("ProjectSerialNo", prjSerialNo));
	if(rs.next())
	{
		CLType = rs.getString(1);
		objectType = rs.getString(2);
		objectNo = rs.getString(3);
	}
	rs.close();
	
	if(CLType != null && !"".equals(CLType))
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
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("ProjectGuarantyCL",BusinessObject.createBusinessObject(),CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("ProjectSerialNo", prjSerialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			{"true","All","Button","保存","保存","saveRecord()","","","","btn_icon_save",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function saveRecord(){
		var sReturn = ProjectManage.selectIsSaveProjectInfo("<%=prjSerialNo%>");
		if(sReturn != "SUCCEED"){
			alert("请先保存项目基本信息！");
			return;
		}else{
			changeBusinessAmt();
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			as_save("reloadPage()");
		}
	}

	function mySelect(){
		var divideType = getItemValue(0,getRow(),"DIVIDETYPE");
		var clSerialNo = getItemValue(0,getRow(),"CLSERIALNO");
		var guarantyPeriodFlag = getItemValue(0,getRow(),"GUARANTYPERIODFLAG");
		var businessAppAmt = getItemValue(0,getRow(),"BUSINESSAPPAMT");
		var prjSerialNo = "<%=prjSerialNo%>";
		if(typeof(clSerialNo) == "undefined" || clSerialNo.length == 0) return;
		if(divideType == "00"){
			AsControl.OpenView("/Blank.jsp","","rightdown","");
		}else if(divideType == "10"){
			AsControl.OpenView("/ProjectManage/ProjectNewApply/ScaleGuarantyCLDownListProject.jsp","parentSerialNo="+clSerialNo+"&PrjSerialNo="+prjSerialNo+"&divideType="+divideType+"&businessAppAmt="+businessAppAmt,"rightdown","");
		}else{
			AsControl.OpenView("/ProjectManage/ProjectNewApply/ScaleGuarantyCLDownListOrg.jsp","parentSerialNo="+clSerialNo+"&PrjSerialNo="+prjSerialNo+"&divideType="+divideType+"&businessAppAmt="+businessAppAmt,"rightdown","");
		}
	}
	function reloadPage(){
		parent.OpenInfo();
		mySelect();
	}
	function selectType(){
		var guarantyTermType = getItemValue(0,getRow(),"GUARANTYTERMTYPE");
		if(guarantyTermType == "02"){
			setItemRequired("myiframe0","GUARANTYPERIODFLAG",true);
			showItem("myiframe0","GUARANTYPERIODFLAG");
		}else{
			setItemRequired("myiframe0","GUARANTYPERIODFLAG",false);
			hideItem("myiframe0","GUARANTYPERIODFLAG");
			setItemValue(0,0,"GUARANTYPERIODFLAG","");
		}
	}
	function changeBusinessAmt(){
		var guarantyTermType = getItemValue(0,getRow(),"GUARANTYVALUE");
		setItemValue(0,0,"BUSINESSAPPAMT",guarantyTermType);
	}
	function initRow(){
		var sReturn = ProjectManage.selectPrjStatus("<%=prjSerialNo%>");
		if(sReturn == "13"){
			setItemValue(0,0,"STATUS","20");
		}
		mySelect();
		selectType();
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
