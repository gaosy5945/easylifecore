<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "�˻���������"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������:�˺�
	String sAccount =  CurComp.getParameter("Account");
	String readOnly =  CurComp.getParameter("ReadOnly");
	if(sAccount==null) sAccount = "";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "AccountManageInfo"; //ģ����
	String sTempletFilter = "1=1"; //�й�������ע�ⲻҪ�����ݹ�������
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,sTempletFilter);
	
    if(!sAccount.equals("")){
    	doTemp.setReadOnly("Account,IsOwnBank",true);	
    }
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccount);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"y".equalsIgnoreCase(readOnly)?"true":"false","","Button","����","���������޸�","saveRecord()","","","",""},
		{"false","","Button","����","�����б�ҳ��","goBack()","","","",""}
    };
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(){
		if(bIsInsert){
			if (!ValidityCheck()){
				return;
			}else{
				as_save("myiframe0");
			}
		}else{
			alert("�˻����鲻���޸�");
		}
	}

    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function goBack(){
        self.close();
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//������¼			
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>")
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"AccountSource","020");
			bIsInsert = true;
		}
	}

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer(){
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ�����		
		sReturn = setObjectValue("SelectOrgCustomer","","@CustomerID@0@CustomerName@1",0,0,"");
		if(sReturn == "_CLEAR_"){
			setItemDisabled(0,0,"CustomerID",false);
			setItemDisabled(0,0,"CustomerName",false);
		}else{
			//��ֹ�û��㿪��ʲôҲ��ѡ��ֱ��ȡ��������ס�⼸������
			sCustomerID = getItemValue(0,0,"CustomerID");
			if(typeof(sCertID) != "undefined" && sCertID != ""){
				setItemDisabled(0,0,"CustomerID",false);
				setItemDisabled(0,0,"CustomerName",false);
			}else{
				setItemDisabled(0,0,"CustomerID",false);
				setItemDisabled(0,0,"CustomerName",false);
			}
		}
	}

	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
		sAccount = getItemValue(0,getRow(),"Account");//�˺�
		//����˻�����Ч��
		if (sAccount.length > 0){
			var Letters = "#";
			//����ַ������Ƿ����"#"�ַ�
			if (!(sAccount.indexOf(Letters) == -1)){
				alert("������˺����������������˺�");
				return false;
			}
		}		
		//����˻���Ψһ��
		sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CheckAccountChangeCustomer","checkAccountChangeCustomer","account="+sAccount);
		if(typeof(sReturn) != "undefined" && sReturn == "false"){
			alert("�˻��Ѿ��Ǽ�");
			return false;
		}else
			return true;
	}

	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>