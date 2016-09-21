<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String listType = CurPage.getParameter("ListType");
	if(listType == null) listType = "";
	String importTemplet = CurPage.getParameter("ImportTemplet");
	if(importTemplet == null) importTemplet = "";

	ASObjectModel doTemp = new ASObjectModel("SpecialCustList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.MultiSelect = true; //�����ѡ
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(listType);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","All","Button","����","����","viewAndEdit()","","","","",""},
			{"true","All","Button","ȡ������ͻ���¼","ȡ������ͻ���¼","cancelRecord()","","","","",""},
			{"true","All","Button","��������","��������","importData()","","","","",""},
			{"true","All","Button","����ͻ�����","����ͻ�����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'')","","","","btn_icon_delete",""},
			{"true","All","Button","����","����","exportPage('"+sWebRootPath+"',0,'excel','')","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script><script type="text/javascript">
	function add(){
		var listType = "<%=listType%>";
    	OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustomerInfo.jsp?listType="+listType,"_self","");
		reloadSelf();
	}
	function viewAndEdit(){
		var serialNo = getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustomerInfo.jsp?SerialNo="+serialNo,"_self","");
		reloadSelf();
	}
	function cancelRecord(){
		var relaSerialNos = '';
		var relaStatus = '';
		var recordArray = getCheckedRows(0);//��ȡ��ѡ����
		if (typeof(recordArray)=="undefined" || recordArray.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}

		for(var i = 1;i <= recordArray.length;i++){
			var serialNo = getItemValue(0,recordArray[i-1],"SERIALNO");
			relaSerialNos += serialNo+"@";
		}
		
		for(var i = 1;i <= recordArray.length;i++){
			var status = getItemValue(0,recordArray[i-1],"STATUS");
			relaStatus += status+"@";
		}
		relaStatus = relaStatus.split("@");
		for(var i=0;i < relaStatus.length-1;i++){
			if(relaStatus[i] == "0"){
				alert("����δ���˻򸴺˽���Ϊ����ͬ�⡿�Ŀͻ�����ȷ�ϣ�");
				return;
			}else if(relaStatus[i] == "2"){
				alert("������ȡ����¼������ͻ�����ȷ�ϣ�");
				return;
			}
		}
		AsControl.PopView("/CustomerManage/SpecialCustomerManage/CancelSpecialCustomer.jsp","relaSerialNos="+relaSerialNos,"resizable=yes;dialogWidth=800px;dialogHeight=320px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function edit(){
		var customerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var serialNo = getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		var result = CustomerManage.selectCustomer(customerID);
		if(result == "SUCCEED"){
			var customerType = CustomerManage.selectCustomerType(customerID);
			CustomerManage.editCustomer(customerID,customerType);
		}else{
			alert("�����޸ÿͻ���Ϣ��");
		}
	}
	function importData(){
		var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
		var parameter = "LISTTYPE=<%=listType%>&clazz=jbo.import.excel.SPECIAL_IMPORT"; 
		var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
		var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
	    reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
