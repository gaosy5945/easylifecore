<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Describe: ��ҵӦ��Ӧ���ʿ���Ϣ
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			CustomerID����ǰ�ͻ����
			SerialNo:��ˮ��
			EditRight:--Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
		HistoryLog:
			qfang 2011-06-13 ���Ӵ��ݲ���"��������"��ReportDate
	 */
	String PG_TITLE = "��ҵӦ��Ӧ���ʿ���Ϣ";
	
	//����������	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sRecordNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RecordNo"));
	String sReportDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportDate"));
	if(sCustomerID == null) sCustomerID = "";
	if(sRecordNo == null) sRecordNo = "";
	if(sReportDate == null) sReportDate = "";

	//�����ͷ				
	String sTempletNo="EntFOAList";
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sRecordNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����Ӧ��Ӧ���˿���Ϣ","newRecord()","","","",""},
		{"true","","Button","����","�鿴Ӧ��Ӧ���˿���Ϣ����","viewAndEdit()","","","",""},
		{"true","","Button","ɾ��","ɾ��Ӧ��Ӧ���˿���Ϣ","deleteRecord()","","","",""},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		OpenPage("/CustomerManage/EntManage/EntFOAInfo.jsp?EditRight=02&ReportDate=<%=sReportDate%>","_self","");
	}

	function deleteRecord(){
	  	var sUserID=getItemValue(0,getRow(),"InputUserId");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else if(sUserID=='<%=CurUser.getUserID()%>'){
    		if(confirm(getHtmlMessage('2'))){ //�������ɾ������Ϣ��
    			as_del('myiframe0');
    			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
    		}
		}else alert(getHtmlMessage('3'));	
	}

	function viewAndEdit(){
       var sUserID=getItemValue(0,getRow(),"InputUserId");//--�û�����
		if(sUserID=='<%=CurUser.getUserID()%>')
			sEditRight='02';
		else
			sEditRight='01';
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
        	alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        	return;
       }else{
        	OpenPage("/CustomerManage/EntManage/EntFOAInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight, "_self","");
        }
    }

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>