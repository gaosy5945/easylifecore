<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
 	/* 
 		--ҳ��˵���� ͨ�����鶨������strip���ҳ��ʾ��--
 	*/
 	String SerialNo = CurPage.getAttribute("SerialNo");
    String sTemplateNo = CurPage.getAttribute("TempletNo");
    if(SerialNo==null)SerialNo = "";
    if(sTemplateNo==null)sTemplateNo="";
    
    ASObjectModel doTemp = new ASObjectModel(sTemplateNo);
    ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
    dwTemp.Style="2";
    
    dwTemp.genHTMLObjectWindow(SerialNo);
    
    dwTemp.replaceColumn("PROJECTINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/ProjectManage/ProjectNewApply/SignOpinionProjectInfo.jsp?SerialNo="+SerialNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
    dwTemp.replaceColumn("OPINION", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/ProjectManage/ProjectNewApply/SignOpinionInfo.jsp?SerialNo="+SerialNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());

 	String sButtons[][] = {
 			{"true","","Button","����","����","save()","",""},
 			{"true","","Button","�ύ","�ύ","submit()","",""},
 	};
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	AsCredit.openFunction("SignOpinionProjectApply", "SerialNo=<%=SerialNo%>", "", "");
	function save(){
		alert(1);
	}
	
	function submit(){
		alert(2);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
