<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%><%
	String PG_TITLE = "��ɫ���û��б�";
	//����������
	String sRoleID = CurPage.getParameter("RoleID");
	if(sRoleID == null) sRoleID = "";
	
	String sTempletNo = "ViewAllUserList"; //ģ����
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sRoleID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","�ر�","�ر�","goBack()","","","",""},
		{"false","","Button","����Excel","����Excel","exportAll()","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function goBack(){
		top.close();
	}
	
	<%/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/%>
	function exportAll(){
		amarExport("myiframe0");
	}
	
 	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	}); 
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>