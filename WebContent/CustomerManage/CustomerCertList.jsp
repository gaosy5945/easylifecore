<%@page import="com.amarsoft.app.als.credit.common.model.CreditConst"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    String sCustomerID =  CurPage.getParameter("CustomerID");
	String sSerialNo = CurPage.getParameter("SerialNo");
	String sCustomerType = CurPage.getParameter("CustomerType");
	String sListType = CurPage.getParameter("ListType");
	if(sListType == null) sListType = "";
	String sRightType = CurPage.getParameter("RightType");

	ASObjectModel doTemp = new ASObjectModel("CustomerCertList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	if(!"".equals(sListType)){
		doTemp.setDDDWJbo("CERTTYPE", "jbo.sys.CODE_LIBRARY,ItemNo,ItemName,CodeNo = 'CustomerCertType' and IsInuse='1' and ItemNo in('2010', '2020', '2999') order by SortNo");
	}else if("".equals(sListType)&&(sCustomerType.substring(0,2)).equals("01")){
		doTemp.setDDDWJbo("CERTTYPE", "jbo.sys.CODE_LIBRARY,ItemNo,ItemName,CodeNo = 'CustomerCertType' and IsInuse='1' and ItemNo like '2%' order by SortNo");
	}else if("".equals(sListType)&&(sCustomerType.substring(0,2)).equals("03")){
		doTemp.setDDDWJbo("CERTTYPE", "jbo.sys.CODE_LIBRARY,ItemNo,ItemName,CodeNo = 'CustomerCertType' and IsInuse='1' and ItemNo like '1%' order by SortNo");
	} 
	
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "0";	 //�༭ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sCustomerID);
	
	String sButtons[][] = {
		{"true","All","Button","����֤��","����֤��","newCert()","","","","",""},
		{"true","All","Button","ɾ��֤��","ɾ��֤��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","",""},
		{"true","All","Button","��Ч","֤����Ч","setStatus(1)","","","","",""},
		{"true","All","Button","ʧЧ","֤��ʧЧ","setStatus(2)","","","","",""},
		{"true","All","Button","����Ϊ��֤��","����Ϊ��֤��","setMainFlag()","","","","",""},
		{"true","All","Button","����","�����޸�","save()","","","","",""},
	};

%> 
<script type="text/javascript">	
	var needSave = false;

	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newCert(){
 		if(needSave){
			alert("��ǰ��δ�������Ϣ��������������");
			return;
		} else{
			needSave = true;
		}
		var sCustomerID = "<%=sCustomerID%>";
		as_add("myiframe0");
		setItemValue(0,getRow(),"CUSTOMERID",sCustomerID); 
		
		var sReturnValue = PopPage("/CustomerManage/CustomerCertDialog.jsp?CustomerType=<%=sCustomerType%>"+"&ListType=<%=sListType%>","","resizable=yes;dialogWidth=420px;dialogHeight=300px;center:yes;status:no;statusbar:no");
		//�ж��Ƿ񷵻���Ч��Ϣ
		if(typeof(sReturnValue) != "undefined" && sReturnValue.length != 0 && sReturnValue != '_CANCEL_'){
			sReturnValue = sReturnValue.split("@");
			sCertType = sReturnValue[0];
			sCertID = sReturnValue[1];
			sIssueCountry = sReturnValue[2];
			sIDExpiry = sReturnValue[3];
			sCNIDRegCity = sReturnValue[4];
			sStatus = sReturnValue[5];
		    var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerCertAction","addCustomerCert","customerID=<%=sCustomerID%>"+
		    		",certType="+sCertType+",certID="+sCertID+",IssueCountry="+sIssueCountry+",status="+sStatus+",idExpiry="+sIDExpiry+",cnidRegCity="+sCNIDRegCity+",userID=<%=CurUser.getUserID()%>"+",orgID=<%=CurUser.getOrgID()%>");
	
	 		if(sReturn == "true")
			{
				alert("�����ɹ���");
				reloadSelf();
			}else{
				alert("����ʧ��");
			}
		}
	}
	
	/*~[Describe=����֤��״̬;InputParam=��;OutPutParam=��;]~*/
	function setStatus(status){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sCertType = getItemValue(0,getRow(),"CertType");
		var sCertID = getItemValue(0,getRow(),"CertID");
		var sStatus = getItemValue(0,getRow(),"Status");//֤��״̬
		var sCustomerCertFlag = getItemValue(0,getRow(),"CustomerCertFlag");

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			if(status==2 && sStatus=="2"){
				alert("��֤���Ѿ���ʧЧ״̬��");
				return;
			}
			if(status==1 && sStatus=="1"){
				alert("��֤���Ѿ�����Ч״̬��");
				return;
			}
			var effectCertCount = 0;
			if(status=="2"){
				for(var i=0;i<getRowCount(0);i++){
					if(getItemValue(0,i,"Status")=="1")
						effectCertCount+=1;
				}
			if(effectCertCount==1){
				alert("���û�Ŀǰ���ҽ���һ����Ч֤������������ʧЧ������");
				return;
			}else{
				if(sCustomerCertFlag == "1"){
					alert("���������֤������ʧЧ������");
					return;
				}
				var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerCertAction","setCertStatus","SerialNo="+sSerialNo);
				if(sReturn == "true"){
					alert("�����ɹ���");
					reloadSelf();
				}else{
					alert("����ʧ�ܣ�");
				}
				}
			}
			
			if(status == "1")//��Ч
			{
		    	//���Ҫ��Ч��֤���Ƿ��Ѵ���һ����Ч�ĸ�����֤����ϵͳ�в���ͬʱ����2��֤������һ������Ч֤��
				var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerCertAction","existCertStatus","CustomerID=<%=sCustomerID%>"+",CertType="+sCertType+",Status="+sStatus);
		  		if(sReturn == "true_1"){
	 		    	if(confirm("�Ѵ��ڸ�������Ч��֤������Ϊ��֤�����Ƿ�ȷ�Ͻ���ǰѡ��֤������Ϊ��Ч����֤����")){
	 					var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerCertAction","updateCertStatus","SerialNo="+sSerialNo+",CustomerID=<%=sCustomerID%>"+",MainFlag=1"+",CertType="+sCertType+",CertID="+sCertID);
	 					if(sReturn == "true"){
	 						alert("�����ɹ���");
	 						reloadSelf();
	 					}else{
	 						alert("����ʧ�ܣ�");
	 					}
	 		    	} 
		    	}else if(sReturn == "true_2"){
	 		    	if(confirm("�Ѵ��ڸ�������Ч��֤�����Ƿ�ȷ�Ͻ���ǰѡ��֤������Ϊ��Ч֤����")){
	 					var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerCertAction","updateCertStatus","SerialNo="+sSerialNo+",CustomerID=<%=sCustomerID%>"+",CustomerCertFlag=2"+",CertType="+sCertType+",CertID="+sCertID);
	 					if(sReturn == "true"){
	 						alert("�����ɹ���");
	 						reloadSelf();
	 					}else{
	 						alert("����ʧ�ܣ�");
	 					}
			    	} 
		    	}else if(sReturn == "false"){
 					var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerCertAction","updateCertStatus","SerialNo="+sSerialNo+",CustomerID=<%=sCustomerID%>"+",CustomerCertFlag=2"+",CertType="+sCertType+",CertID="+sCertID);
 					if(sReturn == "true"){
 						alert("�����ɹ���");
 						reloadSelf();
 					}else{
 						alert("����ʧ�ܣ�");
 					}
		    	} 
			}


		}
	}
	
	/*~[Describe=��ѡ��֤������Ϊ��֤��;InputParam=��;OutPutParam=��;]~*/
	function setMainFlag(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var certType = getItemValue(0,getRow(),"CertType");
		var certID = getItemValue(0,getRow(),"CertID");
		var status = getItemValue(0,getRow(),"Status");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			if(status=="2"){
				alert("��Ч״̬��֤����������Ϊ��֤����");
				return;
			}
			var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerCertAction","setMainCert","SerialNo="+sSerialNo+",CustomerID=<%=sCustomerID%>"+",CertType="+certType+",CertID="+certID);
	 		if(sReturn == "true")
			{
				alert("�����ɹ���");
				reloadSelf();
			}else{
				alert("����ʧ��");
			}
		}
	}
	
	/*~[Describe=���ù���;InputParam=��;OutPutParam=��;]~*/
	function selectCountry()
	{	
		sParaString = "CodeNo"+",CountryCode";		
		setObjectValue("SelectCode",sParaString,"@ISSUECOUNTRY@0@ISSUECOUNTRYNAME@1",0,getRow(),"");
	}
	
	/*~[Describe=����֤��ǩ������;InputParam=��;OutPutParam=��;]~*/
	function selectArea()
	{
		sParaString = "CodeNo"+",AreaCode";	
		setObjectValue("SelectCode",sParaString,"@CNIDREGCITY@0@CNIDREGCITYNAME@1",0,getRow(),"");

	}
	
	/*~[Describe=����ѡ��;InputParam=��;OutPutParam=��;]~*/
	function selectIDExpiry()
	{
		var sIDExpiry = PopPage("/FixStat/SelectDate.jsp?rand="+randomNumber(),"","dialogWidth=300px;dialogHeight=250px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sIDExpiry)!="undefined")
		{
			setItemValue(0,getRow(),"IDEXPIRY",sIDExpiry);
		}
	}
	
	/*~[Describe=����Ķ�����;InputParam=��;OutPutParam=��;]~*/
	function save()
	{
		var ISSUECOUNTRY = getItemValue(0,getRow(),"ISSUECOUNTRY");
		var CNIDREGCITY = getItemValue(0,getRow(),"CNIDREGCITY");
		if(ISSUECOUNTRY!='CHN' &&  CNIDREGCITY.length > 0){
			alert("��֤���Ҳ�Ϊ���л����񹲺͹���ʱ��֤��ǩ����������ѡ��");
			setItemValue(0,getRow(),"CNIDREGCITY","");
			setItemValue(0,getRow(),"CNIDREGCITYNAME","");
			return;
		}
		as_save("myiframe0");
		needSave=false;
		reloadSelf();
	}
	
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
