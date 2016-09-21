<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sSerialNo = CurPage.getParameter("ObjectNo");
	if(sSerialNo == null) sSerialNo = "";
	boolean flag = "1".equals(Sqlca.getString(new SqlObject("select Flag from DEMO_WIZARD_INFO where SerialNo = :SerialNo").setParameter("SerialNo", sSerialNo)));
	
	ASObjectModel doTemp = new ASObjectModel("DemoWizardInfo");
	doTemp.setVisible("Opinion", true);
	doTemp.setRequired("Opinion", true);
	if(flag) doTemp.setReadOnly("Opinion", true);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";
	dwTemp.genHTMLObjectWindow(sSerialNo);
	
	String sFlag = String.valueOf(!flag);
	String sButtons[][] = {
			{sFlag,"","Button","上一步","","parent.wizard.toPrevStep()","","","",""},
			{sFlag,"","Button","提交","","as_save(0, 'parent.wizard.reload()')","","","",""},
			{sFlag,"","Button","暂存","","as_saveTmp(0)","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>