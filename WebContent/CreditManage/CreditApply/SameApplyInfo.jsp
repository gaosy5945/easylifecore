<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "��ͬ����������"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������	
	String sObjectType = CurComp.getParameter("ObjectType");
	String sObjectNo = CurComp.getParameter("ObjectNo");
	if(sObjectType == null ) sObjectType = "";
	if(sObjectNo == null ) sObjectNo = "";
	
	//���ҳ�����		
	String sSerialNo = CurPage.getParameter("SerialNo");
	if(sSerialNo == null ) sSerialNo = "";

	String certType = "";
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "SameApplyInfo";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	certType = Sqlca.getString( "Select CertType From CUSTOMER_INFO where CustomerID = " + "( Select CustomerID from BUSINESS_APPLY where SerialNo = '" + sObjectNo + "' )" );
	if( certType == null ){
		certType = "";
	}else{
		certType = certType.substring( 0, 3 );
	}

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			//���Ҫ��ӵĹ�ͬ�������Ƿ��Ѿ����ڼ��Ƿ���ҵ����������ͬ
			sReturn = checkSameApplyID();
			if(sReturn!="SUCCESS"){
				alert(sReturn);
				return;
			}	
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}	
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		OpenPage("/CreditManage/CreditApply/SameApplyList.jsp","_self","");
	}
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();
		setItemValue(0,0,"ObjectType","<%=sObjectType%>");
		setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "BUSINESS_APPLICANT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
		
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer(){
		sParaString = "CertType,"+"<%=certType%>";
		setObjectValue("SelectOwner",sParaString,"@ApplicantID@0@ApplicantName@1",0,0,"");
	}
	
	/*~[Describe=��鹲ͬ�������Ƿ��Ѿ����ڼ��Ƿ���ҵ����������ͬ;InputParam=��;OutPutParam=��;]~*/
	function checkSameApplyID(){
		//�ж������˺͹�ͬ�������Ƿ�Ϊͬһ�����Լ���ͬ�������Ƿ��Ѿ��Ǽǹ�		
		sApplicantID = getItemValue(0,getRow(),"ApplicantID");
		sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CheckSameApplicant","run","ObjectType="+"<%=sObjectType%>"+",ObjectNo="+"<%=sObjectNo%>"+",ApplicantID="+sApplicantID);
		return sReturn;
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>