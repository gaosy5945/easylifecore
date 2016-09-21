<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String functionID = CurPage.getParameter("FunctionID");
	
	ASObjectModel doTemp = new ASObjectModel("BatchManageList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","����","����һ����¼","newRecord()","","","",""},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()","","","",""},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.acct.accounting.web.AddBatchApply","add","UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,BatchType=<%=CurPage.getParameter("BatchType")%>");
		if(typeof(returnValue) == "undefined" || returnValue == null || returnValue.length ==0) return;
		else(returnValue.split("@")[0] =="true")
		{
			var batchSerialNo = returnValue.split("@")[1];
			AsCredit.openFunction("<%=functionID%>","SerialNo="+batchSerialNo);
		}
		reloadSelf();
	}
	
	function viewAndEdit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}else{
			AsCredit.openFunction("<%=functionID%>","SerialNo="+serialNo);
		}
	}
	
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
        if(typeof(serialNo) == "undefined" || serialNo.length == 0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))){ //�������ɾ������Ϣ��
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
