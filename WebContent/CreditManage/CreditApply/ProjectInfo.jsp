<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

	<%
	String PG_TITLE = "������Ŀ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%	
	String serialNo = CurPage.getParameter("PrjSerialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "ProjectInfo";//ģ�ͱ��
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage ,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
%>
<%/*~END~*/%>

	<%
	String sButtons[][] = {
		{"true","All","Button","����","����","saveRecord()","","","",""},
		};
	%> 
<%/*~END~*/%>


<%@include file="/Frame/resources/include/ui/include_info.jspf"%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	function saveRecord()
	{
	    var projectSerialNo=getItemValue(0,getRow(),"SerialNo");
	    as_save("myiframe0");	
	}
	
	
	</script>
<%/*~END~*/%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>