<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.als.ui.function.FunctionWebTools"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	ASObjectModel doTemp = new ASObjectModel("DocumentListReportDZ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	String userID = CurUser.getUserID();
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setPageSize(15);
	dwTemp.setParameter("INPUTUSER", userID);
	dwTemp.genHTMLObjectWindow(userID);
	
	String sButtons[][] = {
			{"true","","Button","����","����","DocumentDownLoad()","","","","",""},
	};
%> 

<script type="text/javascript">
	function DocumentDownLoad(){
		var docNo = getItemValue(0,getRow(),"DOCNO");
		var contentStatus = getItemValue(0,getRow(),"CONTENTSTATUS");
		if (typeof(docNo)=="undefined" || docNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(contentStatus != "1")
		{
			alert("�ö��ƻ�δ�����������ء�");
			return;
		}
		AsControl.OpenPage("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+docNo+"&RightType=ReadOnly");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>