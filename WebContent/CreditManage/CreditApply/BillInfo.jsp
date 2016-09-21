<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		Describe: Ʊ����Ϣ��������ʱ��Ʊ����Ϣ
		Input Param:
			ObjectType: ��������
			ObjectNo:   ������
	 */
	String PG_TITLE = "���Ʊ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	ASResultSet rs =null ;
	String contractSerialNo="";
	
	//����������
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	contractSerialNo = CurPage.getParameter("ContractSerialNo");
	String sBusinessType = CurPage.getParameter("BusinessType");
	String sSerialNo    = CurPage.getParameter("SerialNo");

	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
	if(contractSerialNo==null) contractSerialNo="";
	if(sBusinessType==null) sBusinessType="";
	if(sSerialNo == null ) sSerialNo = "";
	
	if(sObjectType.equals("AfterLoan")) sObjectType = "BusinessContract";

	//ͨ����ʾģ�����ASDataObject����doTemp
	ASObjectModel doTemp = new ASObjectModel("BillInfo1X","");	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);   
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sObjectType+","+sObjectNo+","+sSerialNo);

	String sButtons[][] = {
		//{"true","","Button","����","���������޸�","saveRecord()","","","",""},
		//{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}
		{"true","","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
	    //���ҵ��Ʒ��
		sBusinessType = "<%=sBusinessType%>";
        if (bIsInsert) {
	        //�������Ʊ�ݺŽ���Ψһ�Լ�顣
			if (!validateCheck()) {
			    return;
			} 
        }
		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		OpenPage("/CreditManage/CreditApply/BillList.jsp","_self","");
	}

	/*~[Describe=�����������Ʊ�ݺ��Ƿ��Ѿ�����;InputParam=��;OutPutParam=��;]~*/
    function validateCheck() {
        var sBillNo = getItemValue(0,getRow(),"BillNo");
        var sContractSerialNo = "<%=sObjectNo%>";
        var sObjectType = getItemValue(0,getRow(),"ObjectType");
        if (typeof(sBillNo) != "undefined" && sBillNo.length != 0) {
            var sParaString = sObjectType + "," + sContractSerialNo + "," + sBillNo;
            sReturn = RunMethod("BusinessManage","CheckApplyDupilicateBill",sParaString);
            //��������Ʊ�ݺ��Ѿ����ڣ��������������������
            if (sReturn != 0) {
                 alert("Ʊ�ݺ�:" + sBillNo + "�Ѵ��ڣ������¼�������Ʊ�ݺ��Ƿ���ȷ��");
                 return false;
            } else {
                return true;
            }
        }else{
        	alert("������Ʊ�ݱ�ţ�")
        	return false;
        }
    }
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			//as_add("myiframe0");//������¼
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "BILL_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>