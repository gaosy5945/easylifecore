<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.als.ui.function.FunctionWebTools"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	String rightType = CurPage.getParameter("RightType");//Ȩ��
	objectType="AfterLoanReport";
	String templeteNo =  CurPage.getParameter("ListTempleteNo");//ģ��
	if(StringX.isEmpty(templeteNo)) templeteNo = "DocBusinessObjectDocumentList";
	BusinessObject inputParameter = SystemHelper.getPageComponentParameters(CurPage);//BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", objectType);
	inputParameter.setAttributeValue("ObjectNo", objectNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(templeteNo, inputParameter, CurPage, request);
	ASDataObject doTemp = dwTemp.getDataObject();
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","","Button","ģ������","ģ������","download()","","","","",""},
			{"true","All","Button","�����ϴ�","�����ϴ�","newRecord()","","","","",""},
			{"true","","Button","��������","��������","viewFiles()","","","","",""},
			{"true","All","Button","ɾ��","ɾ��","deleteRecord()","","","","",""},
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
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}

		if(confirm(getHtmlMessage(2))){ //�������ɾ������Ϣ��
			as_delete('myiframe0');
		}
	}
	
	<%/*~[Describe=�鿴���޸ĸ�������;]~*/%>
	function viewFiles(){
		var docNo = getItemValue(0,getRow(),"DocNo");
		if (typeof(docNo)=="undefined" || docNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		AsControl.OpenPage("/CreditManage/AfterBusiness/AfterLoanDocumentInfo.jsp", "ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&DocNo="+docNo+"&RightType=<%=rightType%>", "_self");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>