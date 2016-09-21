<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String serialNo = CurPage.getParameter("SerialNo");
	String transSerialNo = CurPage.getParameter("TransSerialNo");
	String childUrl = CurPage.getParameter("ChildUrl");
	String transCode = CurPage.getParameter("TransCode");
	
	if(serialNo == null) serialNo = "";
	if(transSerialNo == null) transSerialNo = "";
	if(childUrl == null) childUrl = "";
	
	ASObjectModel doTemp = new ASObjectModel("SelectChangeDuebill");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo);

	String sButtons[][] = {
		//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
		{"true","All","Button","�������","�������","addChange()","","","","",""},
		{"true","All","Button","ɾ�����","ɾ�����","deleteChange()","","","","",""},
		{"true","","Button","�������","�������","viewDuebill()","","","","",""},
		{"0010".equals(transCode)?"true":"false","","Button","��ӡ��ǰ����֪ͨ��","��ӡ��ǰ����֪ͨ��","print()","","","","",""},
		{"0020".equals(transCode)?"true":"false","","Button","��ӡ����������֪ͨ��","��ӡ����������֪ͨ��","print()","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function addChange(){
		var objectNo = getItemValue(0,getRow(),"SerialNo");//ȡ�����ˮ��
		var objectType = "jbo.app.BUSINESS_DUEBILL";
		var parentTransSerialNo = "<%=transSerialNo%>";
		var childUrl = "<%=childUrl%>";
		
		if(typeof(objectNo) == "undefined" || objectNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=<%=transCode%>,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,Flag=Y";	
		var transSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CreateTransaction","create",para);
		if(typeof(transSerialNo) == "undefined" || transSerialNo.length == 0 )  return;
		AsControl.OpenPage(childUrl, "DBSerialNo="+objectNo+"&TransSerialNo="+transSerialNo, "rightdown", "");
		reloadSelf();
	}
	
	function deleteChange(){
		if(!confirm('ȷʵҪɾ����?')) return;
		var objectNo = getItemValue(0,getRow(),"SerialNo");//ȡ�����ˮ��
		var objectType = "jbo.app.BUSINESS_DUEBILL";
		var parentTransSerialNo = "<%=transSerialNo%>";
		if(typeof(objectNo) == "undefined" || objectNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=<%=transCode%>,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.DeleteTransaction","delete",para);
		alert(result);
		AsControl.OpenPage("/Blank.jsp", "TextToShow=û�б����Ϣ", "rightdown", "");
		reloadSelf();
	}
	
	
	function viewDuebill(){
		var duebillSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(duebillSerialNo) == "undefined" || duebillSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		AsControl.OpenView("/CreditManage/AfterBusiness/DuebillInfo.jsp","DuebillSerialNo="+duebillSerialNo,"_blank");
	}

	var oldSerialNo = "";
	function mySelectRow(){
		var objectNo = getItemValue(0,getRow(),"SerialNo");//ȡ�����ˮ��
		var objectType = "jbo.app.BUSINESS_DUEBILL";
		var parentTransSerialNo = "<%=transSerialNo%>";
		var childUrl = "<%=childUrl%>";
		if(typeof(objectNo)=="undefined" || objectNo.length==0) return;
		
		
		var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=<%=transCode%>,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,Flag=N";
		if(oldSerialNo != objectNo)
		{
			oldSerialNo = objectNo;
			var transSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CreateTransaction","create",para);
			if(typeof(transSerialNo) == "undefined" || transSerialNo.length == 0 )
				AsControl.OpenPage("/Blank.jsp", "TextToShow=û�б����Ϣ", "rightdown", "");
			else
				AsControl.OpenPage(childUrl, "DBSerialNo="+objectNo+"&TransSerialNo="+transSerialNo, "rightdown", "");
		}
	}
	
	function print(){
		var parentTransSerialNo = "<%=transSerialNo%>";
		var serialNo = getItemValue(0,getRow(),"SerialNo");//ȡ�����ˮ��
		if('<%=transCode%>' == '0010'){
			AsControl.OpenView("/BillPrint/AdvRepay.jsp","SerialNo="+serialNo+"&ParentTransSerialNo="+parentTransSerialNo,"_blank");//���˴�����ǰ����֪ͨ��
		}else {
			AsControl.OpenView("/BillPrint/ThirdPartyAdvRepay.jsp","SerialNo="+serialNo+"&ParentTransSerialNo="+parentTransSerialNo,"_blank");//���˴���������˻���ǰ����֪ͨ��
		}
	}
	mySelectRow();

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
