<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sObjectType = DataConvert.toString(CurPage.getParameter("ObjectType"));

	String sTempletNo = "";
	if("01".equals(sObjectType)){
	    sTempletNo = "RiskWarningConfigList01";
	}else if("02".equals(sObjectType)){
		sTempletNo = "RiskWarningConfigList02";
	}
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
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
		
		var sTableName = "RISK_WARNING_CONFIG";//����
		var sColumnName = "SIGNALID";//�ֶ���
		var sPrefix = "";//ǰ׺
		//��ȡ��ˮ��
		var serialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		
		AsControl.OpenView("/BusinessManage/RiskWarningManage/RiskWarningConfigInfo.jsp","SerialNo="+serialNo+"&ObjectType=<%=sObjectType%>","_self","");
	}
	
	function viewAndEdit(){
		var sSIGNALID = getItemValue(0,getRow(),"SIGNALID");
		if(typeof(sSIGNALID)=="undefined" || sSIGNALID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		AsControl.OpenView("/BusinessManage/RiskWarningManage/RiskWarningConfigInfo.jsp","SIGNALID="+sSIGNALID+"&ObjectType=<%=sObjectType%>","_self","");
	}
	
	function deleteRecord(){
		var signalID = getItemValue(0,getRow(),"SIGNALID");
		if(typeof(signalID)=="undefined" || signalID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('2'))){
			AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningConfig","setConfigStatus","SignalID="+signalID);
			
			reloadSelf();
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
