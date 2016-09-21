<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.als.ui.function.FunctionWebTools"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	String rightType = CurPage.getParameter("RightType");//权限
	objectType="AfterLoanReport";
	String templeteNo =  CurPage.getParameter("ListTempleteNo");//模板
	if(StringX.isEmpty(templeteNo)) templeteNo = "DocBusinessObjectDocumentList";
	BusinessObject inputParameter = SystemHelper.getPageComponentParameters(CurPage);//BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", objectType);
	inputParameter.setAttributeValue("ObjectNo", objectNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(templeteNo, inputParameter, CurPage, request);
	ASDataObject doTemp = dwTemp.getDataObject();
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","","Button","模板下载","模板下载","download()","","","","",""},
			{"true","All","Button","附件上传","附件上传","newRecord()","","","","",""},
			{"true","","Button","附件详情","附件详情","viewFiles()","","","","",""},
			{"true","All","Button","删除","删除","deleteRecord()","","","","",""},
	};
	if(!StringX.isEmpty(rightType)&&rightType.equals("ReadOnly")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
	}
%> 

<script type="text/javascript">
	
	function download(){
		
		var returnValue = PopPage("/CreditManage/AfterBusiness/AfterLoanModelSelect.jsp?ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","","dialogWidth:450px;dialogHeight:150px;resizable:yes;scrollbars:no;status:no;help:no");
	}
	function newRecord(){
		AsControl.OpenPage("/CreditManage/AfterBusiness/AfterLoanDocumentInfo.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","_self","");
	}

	function deleteRecord(){
		var docNo = getItemValue(0,getRow(),"DocNo");
		if (typeof(docNo)=="undefined" || docNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}

		if(confirm(getHtmlMessage(2))){ //您真的想删除该信息吗？
			as_delete('myiframe0');
		}
	}
	
	<%/*~[Describe=查看及修改附件详情;]~*/%>
	function viewFiles(){
		var docNo = getItemValue(0,getRow(),"DocNo");
		if (typeof(docNo)=="undefined" || docNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		AsControl.OpenPage("/CreditManage/AfterBusiness/AfterLoanDocumentInfo.jsp", "ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&DocNo="+docNo+"&RightType=<%=rightType%>", "_self");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>