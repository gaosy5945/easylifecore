 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
 
<%
	//����̨��ʾ ���ù���ҳ��
	ASObjectModel doTemp = new ASObjectModel("WorkTipsList");
	String codeNo=CurPage.getParameter("CodeNo");
	doTemp.setHTMLStyle("RELATIVECODE","onClick='selctRole()'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "0";	 //�༭ģʽ
	dwTemp.setPageSize(50);
	dwTemp.genHTMLObjectWindow(codeNo);
	
	String sButtons[][] = {
			{"true","","Button","����","����","add()","","","","",""},
			{"true","","Button","����","����","saveRecord()","","","","",""},
			{"true","","Button","���ý�ɫ","������ʾ��Ϣ�ɲ鿴��ɫ","selctRole()","","","","",""},
			{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","",""},
		};
%> 
<script type="text/javascript">
	function add(){
		  as_add(0);  
		  setItemValue(0,getRow(),"CodeNo","<%=codeNo%>");
	}
	function saveRecord(){
		as_save("myiframe0","");		
	}
	function selctRole(){
		roles=getItemValue(0,getRow(),"RELATIVECODE");
		sReturn=AsDialog.OpenSelector("SelectAllRoles","","");
		if(typeof(sReturn)=="undefined" || sReturn=="_CANCEL_") return ;
		setItemValue(0,getRow(),"RELATIVECODE",sReturn);
		
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
 