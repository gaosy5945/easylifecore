<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
 <%
	/*
		Content: ����ģ���б�
	 */
	String PG_TITLE = "����Ԥ����ʾ��Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������
	String sSignalType  = DataConvert.toString(CurPage.getParameter("SignalType"));
	if(sSignalType==null||sSignalType.length()==0)sSignalType="";
	String sTempletNo  = DataConvert.toString(CurPage.getParameter("TempletNo"));
	if(sTempletNo==null||sTempletNo.length()==0)sTempletNo="";
	String sDoFlag  = DataConvert.toString(CurPage.getParameter("DoFlag"));
	if(sDoFlag==null||sDoFlag.length()==0)sDoFlag="";
		
	 
	//String sTempletNo = "RiskWarningManageViewList";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //���÷�� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(100);
	
	Vector vTemp = null;
	if("RiskWarningManageViewList".equals(sTempletNo))
	{
		vTemp = dwTemp.genHTMLDataWindow(sSignalType);	
	}else if("RiskWarningManageDoFlagList".equals(sTempletNo))
	{
		vTemp = dwTemp.genHTMLDataWindow(sSignalType+","+sDoFlag);
	}
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
		{"true","","Button","Ԥ������","�鿴/�޸�Ԥ������","viewAndEdit()","","","",""},
		{"true","","Button","�������","������ʵ����������","editResult()","","","",""},
		{"true","","Button","������ʵ����鿴","�鿴/�޸�Ԥ������","viewResult()","","","",""},
	};
	if("RiskWarningManageDoFlagList".equals(sTempletNo)&&"2".equals(sDoFlag))
	{
		sButtons[1][0]="false";
	}
	
	if("RiskWarningManageViewList".equals(sTempletNo))
	{
		sButtons[1][0]="false";
		sButtons[2][0]="false";
	}
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
    
	 /*~[Describe=�޸ķ������״̬;]~*/
	function editResult(){
    	
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		var num = AsControl.RunASMethod("RiskWarningManage","UpdateSignalDoFlag",sSerialNo+",2");
       	if(num>0){
       		alert("ִ�з����ɹ���");
       	}else
       	{
       		alert("ִ�з���ʧ�ܣ�");
       	}
       	reloadSelf();
	}
	 
	 /*~[Describe=�鿴���޸�����;]~*/
	function viewResult(){
		alert("��δʵ�ִ˲���¼�빦�ܣ���������������ͬ�²��䣡лл��");
	}
	
var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>