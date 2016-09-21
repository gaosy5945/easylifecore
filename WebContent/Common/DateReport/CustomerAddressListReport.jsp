<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sCustomerID =  CurComp.getParameter("CustomerID");
	String sCustomerType = CurPage.getParameter("CustomerType");
	String sListType = CurPage.getParameter("ListType");
	String addressType = CurPage.getParameter("AddressType");
	
	ASObjectModel doTemp = new ASObjectModel("CustomerAddressList");
	
	if(addressType != null && !"".equals(addressType))
		doTemp.appendJboWhere(" and O.AddressType in('"+addressType.replaceAll("@", "','")+"')");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sCustomerID);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
			{"false","All","Button","����ΪͨѶ��ַ","����ΪͨѶ��ַ","setMainAdd(1)","","","","",""},
			{"false","All","Button","ȡ��ͨѶ��ַ","ȡ��ͨѶ��ַ","setMainAdd(2)","","","","",""},
			{"true","All","Button","��������","��������","setIsNew(1)","","","","",""},
			{"true","All","Button","ȡ������","ȡ������","setIsNew(0)","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		AsControl.PopPage("/CustomerManage/CustomerAddressInfo.jsp","CustomerID=<%=sCustomerID%>"+"&CustomerType=<%=sCustomerType%>"+"&ListType=<%=sListType%>","resizable=yes;dialogWidth=650px;dialogHeight=400px;center:yes;status:no;statusbar:no");
        reloadSelf();	
	}
	
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		AsControl.PopPage("/CustomerManage/CustomerAddressInfo.jsp","SerialNo="+serialNo+"&CustomerID=<%=sCustomerID%>"+"&CustomerType=<%=sCustomerType%>"+"&ListType=<%=sListType%>","resizable=yes;dialogWidth=650px;dialogHeight=400px;center:yes;status:no;statusbar:no");
        reloadSelf();	
	}
	
	function del(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		if(confirm('ȷʵҪɾ����?')){
			as_delete(0);
		}
	}
	
	function setIsNew(status){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//��õ�ַ����
		var sAddType = getItemValue(0,getRow(),"AddressType");
		var sIsAdd = getItemValue(0,getRow(),"IsNew");
		if(status == "1")
		{
			if(sIsAdd == "1")
			{
				alert("�ü�¼��������״̬�������������£�");
				return;
			}
			
		    var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerAddressAction","checkCustomerAddress","CustomerID=<%=sCustomerID%>"+
		    		",AddType="+sAddType);
		    
		    if(sReturn == "true"){
		    	alert("�õ�ַ�����Ѵ���һ�����µģ�");
		    	return;
		    }
	
		}
		
		if(status == "0"){
			if(sIsAdd == "0")
			{
				alert("�˼�¼����Ҫ��ȡ�����²�����");
				return;
			}
		}
		
   	 	var sFlag = RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerAddressAction","setCustomerAddressIsNew","SerialNo="+sSerialNo+",Status="+status);
		
   	 	if(sFlag=="true"){
			alert("�����ɹ���");
			reloadSelf();
		}else{
			alert("����ʧ�ܣ�");
		} 

	}
	
	function setMainAdd(status){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		//��õ�ַ����
		var sAddType = getItemValue(0,getRow(),"AddType");
		var sIsAdd = getItemValue(0,getRow(),"IsAdd");
		if(status == "1")
		{
			if(sIsAdd == "1")
			{
				alert("�ü�¼����ͨѶ��ַ������������ΪͨѶ��ַ��");
				return;
			}
			
		    var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerAddressAction","checkIsAdd","CustomerID=<%=sCustomerID%>");
		    
		    if(sReturn == "true"){
		    	alert("�Ѵ���һ��ͨѶ��ַ��");
		    	return;
		    }
	
		}
		
		if(status == "2"){
			if(sIsAdd == "2")
			{
				alert("�˼�¼����Ҫ��ȡ��ͨѶ��ַ������");
				return;
			}
		}
		
   	 	var sFlag = RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerAddressAction","setCustomerAddressIsAdd","SerialNo="+sSerialNo+",Status="+status);
		
   	 	if(sFlag=="true"){
			alert("�����ɹ���");
			reloadSelf();
		}else{
			alert("����ʧ�ܣ�");
		} 

		
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
