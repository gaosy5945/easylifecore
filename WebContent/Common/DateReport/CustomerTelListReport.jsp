<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sCustomerID =  CurComp.getParameter("CustomerID");

	ASObjectModel doTemp = new ASObjectModel("CustomerTelList");
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
			{"true","All","Button","��������","��������","setIsNew(1)","","","","",""},
			{"true","All","Button","ȡ������","ȡ������","setIsNew(0)","","","","",""},

		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		AsControl.PopPage("/CustomerManage/CustomerTelInfo.jsp","CustomerID=<%=sCustomerID%>","resizable=yes;dialogWidth=500px;dialogHeight=300px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		AsControl.PopPage("/CustomerManage/CustomerTelInfo.jsp","SerialNo="+serialNo,"resizable=yes;dialogWidth=500px;dialogHeight=300px;center:yes;status:no;statusbar:no");
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
		var sTelType = getItemValue(0,getRow(),"TelType");
		var sIsNew = getItemValue(0,getRow(),"IsNew");
		if(status == "1")
		{
			if(sIsNew == "1")
			{
				alert("�ü�¼��������״̬�������������£�");
				return;
			}
			
		    var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerTelAction","checkCustomerTel","CustomerID=<%=sCustomerID%>"+
		    		",TelType="+sTelType);
		    
		    if(sReturn == "true"){
		    	alert("�õ绰�����Ѵ���һ�����µģ�");
		    	return;
		    }
	
		}
		
		if(status == "2"){
			if(sIsNew == "2")
			{
				alert("�˼�¼����Ҫ��ȡ�����²�����");
				return;
			}
		}
		
   	 	var sFlag = RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerTelAction","setCustomerTelIsNew","SerialNo="+sSerialNo+",Status="+status);
		
   	 	if(sFlag=="true"){
			alert("�����ɹ���");
			reloadSelf();
		}else{
			alert("����ʧ�ܣ�");
		} 

	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
