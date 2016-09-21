<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
  
<%
	String CustomerBaseID = CurComp.getParameter("CustomerBaseID");
	if(CustomerBaseID == null) CustomerBaseID = "";
	
	String sTempletNo = "CustomerBaseInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("CustomerBaseID", CustomerBaseID);
	dwTemp.genHTMLObjectWindow("");
	
	//dwTemp.replaceColumn("CREDITMODEL", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/ActiveCreditManage/CustomerBaseManage/CustomerBaseDoc.jsp?ObjectType="+"jbo.customer.CUSTOMER_INFO"+"&ObjectNo="+CustomerBaseID+"&DocNo="+docNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
		{"true","All","Button","保存","保存","saveRecord()","","","",""}, 
		{"true","All","Button","附件下载","附件下载","download()","","","",""}, 
		{"false","All","Button","取消","取消","Cancel()","","","",""}, 
	};
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>

<script type="text/javascript">
function saveRecord(){
	var CustomerBaseID = "<%=CustomerBaseID%>";
	var CustomerBaseNameTemp = getItemValue(0,getRow(),"CustomerBaseName");
	var CustomerBaseName = CustomerBaseNameTemp.trim();
	if(typeof(CustomerBaseID)=="undefined" || CustomerBaseID.length==0){
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.activeCredit.customerBase.SelectCustomerBase", "selectCustomerBaseName","CustomerBaseName="+CustomerBaseName);
		if(result == "Exists"){
			alert("您输入的客户名称已存在，请调整!\n建议使用：客群小类名称－渠道名称简写");
			return;
		}else{
			setItemValue(0,getRow(),"CustomerBaseName",CustomerBaseName);
			as_save(0);
		}
	}else{
		setItemValue(0,getRow(),"CustomerBaseName",CustomerBaseName);
		as_save(0);
	}

}

function download(){
	var CustomerBaseID = "<%=CustomerBaseID%>";
	var sDocNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.activeCredit.customerBase.SelectCustomerBase", "selectCustomerBaseDocNo", "CustomerBaseID="+CustomerBaseID);
	AsControl.OpenView("/AppConfig/Document/AttachmentFiles.jsp", "DocNo="+sDocNo, "AttachmentList");
}

function init(){
	var CustomerBaseID = getItemValue(0,getRow(),"CustomerBaseID");
	if(typeof(CustomerBaseID) == "undefined" || CustomerBaseID.length == 0){
		setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,getRow(),"InputOrgName","<%=com.amarsoft.dict.als.manage.NameManager.getOrgName(CurOrg.getOrgID())%>");
		setItemValue(0,getRow(),"InputDate","<%=DateHelper.getBusinessDate()%>");
		setItemValue(0,getRow(),"UpdateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"UpdateOrgID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,getRow(),"UpdateDate","<%=DateHelper.getBusinessDate()%>")
	}else{
		setItemValue(0,getRow(),"UpdateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"UpdateOrgID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,getRow(),"UpdateDate","<%=DateHelper.getBusinessDate()%>")
	}
}
init();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 