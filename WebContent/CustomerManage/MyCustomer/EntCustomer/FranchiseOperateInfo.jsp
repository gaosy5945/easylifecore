<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";

	String sTempletNo = "FranchiseOperateInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("CustomerID", customerID);
	doTemp.setDefaultValue("INPUTORGName", CurOrg.getOrgName());
	doTemp.setDefaultValue("INPUTUSERName", CurUser.getUserName());
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		var authDate = getItemValue(0,getRow(0),"AUTHDATE");
		var validDate = getItemValue(0,getRow(0),"VALIDDATE");
		var authYear = authDate.substring(0, 4);
		var authMonth = authDate.substring(5, 7);
		var authDay = authDate.substring(8, 10);
		var authDateSub = authYear+authMonth+authDay;
		
		var validYear = validDate.substring(0, 4);
		var validMonth = validDate.substring(5, 7);
		var validDay = validDate.substring(8, 10);
		var validDateSub = validYear+validMonth+validDay;
		if((authDateSub != "" || authDateSub.length != 0) && (validDateSub != "" || validDateSub.length != 0)){
			if(authDateSub > validDateSub || authDateSub == validDateSub){
				alert("结束日期不能小于或等于起始日期，请重新输入！");
				return;
			}
		}
		as_save(0);
	}
		function initRow(){
			var serialNo = getItemValue(0,getRow(0),"SERIALNO");
			if(typeof(serialNo) == "undefined" || serialNo.length == 0){
				setItemValue(0,0,"CUSTOMERID","<%=customerID%>");
				setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
				setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
				setItemValue(0,0,"INPUTDATE","<%=DateHelper.getBusinessDate()%>");
			}
			setItemValue(0,0,"UPDATEDATE","<%=DateHelper.getBusinessDate()%>");
		}
		initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
