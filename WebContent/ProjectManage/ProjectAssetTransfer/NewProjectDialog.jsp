<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<% 
	String FlowNo = CurPage.getParameter("FlowNo");
	if(FlowNo == null) FlowNo = "";
	String sTempletNo = "PrepareSubmitProjectAddInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	Vector<Parameter>  vlst=CurPage.parameterList;
	for(Parameter par:vlst){
		doTemp.setDefaultValue(par.paraName,par.paraValue);
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow("");
	//dwTemp.setPageSize(50);
	String sButtons[][] = {
		{"true","All","Button","ȷ��","ȷ��","saveRecord()","","","",""}, 
		{"true","All","Button","ȡ��","ȡ��","goBack()","","","",""}, 
	};
	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>

<script type="text/javascript">
	function goBack(){ 
		self.close();
	}

	function saveRecord(){ 
		checkCertInfo();
		top.returnValue = "ok";
		self.close();
	}
	function checkCertInfo(){
		var ProjectType=getItemValue(0,getRow(),"ProjectType");
		initSerialNo();
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(ProjectType)=="undefined" || ProjectType.length==0 ){
			 alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}else{
			var OrgID = '<%=CurOrg.getOrgID()%>';
			var CurDate = '<%=StringFunction.getToday()%>';
			var returnValue = RunMethod("BusinessManage","GenerateAgreementNo",OrgID+","+ProjectType+","+CurDate);
			AsCredit.openFunction("PrepareSubmitProject_new2","ProjectType="+ProjectType+"&ObjectNo="+sSerialNo+"&AgreementNo="+returnValue+"&FlowNo="+'<%=FlowNo%>'+"&isNew=true");
		}
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "prj_basic_info";//����
		var sColumnName = "SERIALNO";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPageAjax("/Frame/page/sys/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 