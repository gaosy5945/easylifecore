<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.als.ui.function.FunctionWebTools"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	//���ղ���
	String fileType = DataConvert.toString(CurPage.getAttribute("FileType"));
	
	//String tempNo = CurPage.getParameter("TempNo");//ģ���
	//String tempNo = "DocumentListReportDown01";
	//ASObjectModel doTemp = null;
	//doTemp = new ASObjectModel(tempNo);
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	//dwTemp.setParameter(name, value)
	
	ASObjectModel doTemp = new ASObjectModel("DocumentListReportDown01");
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setPageSize(15);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.setParameter("FileType", fileType);
	
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","","Button","����","����","DocumentDownLoad()","","","","",""},
	};
%> 

<script type="text/javascript">
	function DocumentDownLoad(){
		var docNo = getItemValue(0,getRow(),"DOCNO");
		if (typeof(docNo)=="undefined" || docNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		AsControl.OpenPage("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+docNo+"&RightType=ReadOnly");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>