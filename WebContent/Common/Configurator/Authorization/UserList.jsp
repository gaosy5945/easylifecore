<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String orgID = CurPage.getParameter("OrgID");
	if(orgID == null || orgID == "undefined") orgID = "";
	ASObjectModel doTemp = new ASObjectModel("UserList");
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter","and O.BELONGORG=:ORGID ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	//doTemp.setJboWhereWhenNoFilter("O.BELONGORG=:ORGID and O.USERID in (select UserID from jbo.sys.USER_ROLE UR where UR.ROLEID IN ('PLBS0007','PLBS0008','PLBS0009','PLBS0011'))");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setParameter("OrgID", orgID);
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(orgID);

	String sButtons[][] = {
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function mySelectRow(){
		var userID = getItemValue(0,getRow(),"UserID");
		if(typeof(userID)=="undefined" || userID.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","rightdown","");
		}else{
			AsControl.OpenView("/Common/Configurator/Authorization/RuleList.jsp","UserID="+userID,"rightdown","");
		}
	}
	
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
