 <%@ page contentType="text/html; charset=GBK"%><%@
  include file="/Frame/resources/include/include_begin_info.jspf"%><%
	//获得参数	
	String sDoNo = CurPage.getParameter("DONO");
	if(sDoNo==null) sDoNo = "";
        
	ASObjectModel doTemp = new ASObjectModel("DataObjectCatalogInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow(sDoNo);   
    
    String sButtons[][] = {
        {"true","All","Button","保存","保存所有修改","as_save(0)","","","","btn_icon_save"},
    };
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>