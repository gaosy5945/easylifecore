<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	String sDocID = CurPage.getParameter("DocID");
 	String sDirID = CurPage.getParameter("DirID");
	if(sDocID == null) sDocID = "";
	if(sDirID == null) sDirID = "";
	ASObjectModel doTemp = new ASObjectModel("FDNameMapList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "0";//�༭ģʽ
	dwTemp.genHTMLObjectWindow(sDocID+","+sDirID);
	
	String sButtons[][] = {
		{"true","","Button","����","����","addRecord()","","","",""},
		{"true","","Button","����","����","saveRecord()","","","",""},
		{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	setDialogTitle("�ֶ�����ӳ��");
	function addRecord(){
	 	as_add("myiframe0");
	 	//����Ĭ��ֵ
	 	setItemValue(0,getRow(),'DOCID','<%=sDocID%>');
	 	setItemValue(0,getRow(),'DIRID','<%=sDirID%>');
	}
	function saveRecord(){
		as_save("myiframe0");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>