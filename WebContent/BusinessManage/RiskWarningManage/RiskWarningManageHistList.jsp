<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
 <%
	/*
		Content: ����ģ���б�
	 */
	String PG_TITLE = "����Ԥ����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������
	String sSerialNo  = DataConvert.toString(CurPage.getParameter("SerialNo"));
	if(sSerialNo==null||sSerialNo.length()==0)sSerialNo="";
	/* String sTempletNo = DataConvert.toString(CurPage.getParameter("TempletNo"));
	if(sTempletNo==null||sTempletNo.length()==0)sTempletNo=""; */
		
	 
	String sTempletNo = "RiskWarningManageHistList";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //���÷�� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(100);
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
		//{"true","","Button","Ԥ������","�鿴/�޸�Ԥ������","viewAndEdit()","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
    /*~[Describe=�鿴���޸�����;]~*/
	function viewAndEdit(){
    	
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		AsCredit.openFunction("RiskWarningManageInfo","SerialNo="+sSerialNo+"&RightType=ReadOnly");
	}
    
	
	
var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>