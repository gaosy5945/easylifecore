<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%><%	
	/*
        Author: undefined 2016-01-07
        Content: 
        History Log: 
    */
    String templetNo = CurPage.getParameter("TempletNo");
	String direction = CurPage.getParameter("Direction");
	String invoiceobject = CurPage.getParameter("InvoiceObject");
	if(templetNo == null) templetNo = "";
	if(direction == null) direction = "";
	if(invoiceobject == null) invoiceobject = "";
	ASObjectModel doTemp = new ASObjectModel(templetNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	//dwTemp.MultiSelect = true;	 //��ѡ
	//dwTemp.ShowSummary="1";	 	 //����
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	//String drection = CurPage.getAttribute("drection");
	dwTemp.setParameter("direction", direction);
	dwTemp.setParameter("invoiceobject", invoiceobject);
	dwTemp.genHTMLObjectWindow("");

	//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
	String sButtons[][] = {
		{"true","All","Button","����","����","newRecord()","","","","btn_icon_add",""},
		{"true","","Button","����","����","viewAndEdit()","","","","btn_icon_detail",""},
		{"true","","Button","ɾ��","ɾ��","deleteRecord()","","","","btn_icon_delete",""},
		{"false","","Button","�ʼ�","�ʼ�","post()","","","","",""},
		{"false","","Button","ǩ��","ǩ��","sign()","","","","",""},
		{"false","","Button","Ʊ�ݳ���","Ʊ�ݳ���","revoke()","","","","",""},
	};
	if(direction.equals("P")){
		sButtons[3][0] = "true";
		sButtons[4][0] = "true";
		sButtons[5][0] = "true";
	}
	if("03".equals(invoiceobject)) sButtons[0][0] = "false";
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		 var sUrl = "/InvoiceManage/InvoiceRegisterAddInfo.jsp";
		 var templetNo = "R_InvoiceRegisterAddInfo";
		 if("<%=direction%>"=="P")
			 templetNo = "P_InvoiceRegisterAddInfo";
		 AsControl.OpenView(sUrl,'TempletNo='+templetNo+'&ListTempletNo='+"<%=templetNo%>"+'&Direction='+"<%=direction%>"+'&InvoiceObject='+"<%=invoiceobject%>",'_self','');
	}
	function viewAndEdit(){
		 var sUrl = "/InvoiceManage/InvoiceRegisterInfo.jsp";
		 var sPara = getItemValue(0,getRow(0),'serialno');
		 var purpose = getItemValue(0,getRow(0),'purpose');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��ѡ��һ����¼��");
			return ;
		 }
		 var templetNo = "R_InvoiceRegisterInfo";
		 if("<%=direction%>"=="P"){
			 if("<%=invoiceobject%>" == "03"){
				 templetNo = "P_InvoiceRegisterIndInfo";
			 }else{
				 templetNo = "P_InvoiceRegisterInfo";
			 }
		 }
			
		 AsControl.OpenView(sUrl,'SerialNo='+sPara+'&TempletNo='+templetNo+'&ListTempletNo='+"<%=templetNo%>"+'&Direction='+"<%=direction%>"+'&InvoiceObject='+"<%=invoiceobject%>"+"&Purpose="+purpose,'_self','');
	}
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"serialno");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		if(confirm('ȷʵҪɾ����?')){
			AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.invoice.InvoiceDelete","InvoiceDelete","SerialNo="+serialNo);
			as_delete(0);
		}
	}
	function post(){
		var serialno = getItemValue(0,getRow(0),'serialno');
		if(typeof(serialno)=="undefined" || serialno.length==0 ){
			alert("��ѡ��һ����¼��");
			return ;
		}
		var status = getItemValue(0,getRow(0),'status');
		if(status == "00" || status == "04"){
			alert("����ȷ��Ʊ�ݣ�");
			return
		}
		if(status == "02"){
			alert("��Ʊ�����ʼģ�");
			return
		}
		if(status == "03"){
			setItemValue(0,getRow(),"status","01");
			var result = AsControl.PopPage("/InvoiceManage/InvoicePostInfo.jsp","SerialNo="+serialno,"resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
			reloadSelf();
		} 
		if(status == "01"){
			var result = AsControl.PopPage("/InvoiceManage/InvoicePostInfo.jsp","SerialNo="+serialno,"resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
			reloadSelf();
		}
	}
	function sign(){
		var serialno = getItemValue(0,getRow(0),'serialno');
		if(typeof(serialno)=="undefined" || serialno.length==0 ){
			alert("��ѡ��һ����¼��");
			return ;
		}
		var status = getItemValue(0,getRow(0),'status');
		if(status == "00" || status == "01" || status == "04"){
			alert("��Ʊ�ݲ����ʼ�״̬��");
			return;
		}
		if(status == "03"){
			alert("��Ʊ����ǩ�գ�ǩ����Ϣ�����ݱ�ע��");
			return;
		}
		if(status == "02"){
			/* var result = AsControl.PopPage("/InvoiceManage/InvoiceSignInfo.jsp","serialNo="+serialno,"resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
			reloadSelf(); */
			if(confirm("�Ƿ�ȷ����ǩ�գ�")){
				var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.afterloan.invoice.InvoiceChange","InvoiceStatusChange","serialNo="+serialno+",status=03");
				if(sReturn == "success"){
					alert("�ѳɹ�ǩ�գ�");
					reloadSelf();
				}
			}
		}
	}
	function revoke(){
		var serialno = getItemValue(0,getRow(0),'serialno');
		if(typeof(serialno)=="undefined" || serialno.length==0 ){
			alert("��ѡ��һ����¼��");
			return ;
		}
		var status = getItemValue(0,getRow(0),'status');
		if(status != "04"){
			var result = AsControl.PopPage("/InvoiceManage/InvoiceRevokeInfo.jsp","serialNo="+serialno,"resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
			reloadSelf();
		}
		else
			alert("Ʊ���ѳ�����");
		return
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>