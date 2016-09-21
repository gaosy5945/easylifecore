<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String sDoNo = CurPage.getParameter("DONO");
	if(sDoNo==null) sDoNo = "";

    ASObjectModel doTemp = new ASObjectModel("ObjectModelCatalogInfo");
    ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
    dwTemp.Style = "2";//freeform
    dwTemp.genHTMLObjectWindow(sDoNo);
    
    String sButtons[][] = {
        {"true","All","Button","保存","保存所有修改","as_save(0)","","","","btn_icon_save"},
    };
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>