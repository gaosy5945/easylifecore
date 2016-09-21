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
	
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "0";	 //编辑模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sCustomerID);
	
	String sButtons[][] = {
		{"true","All","Button","新增证件","新增证件","newCert()","","","","",""},
		{"true","All","Button","删除证件","删除证件","if(confirm('确实要删除吗?'))as_delete(0)","","","","",""},
		{"true","All","Button","生效","证件生效","setStatus(1)","","","","",""},
		{"true","All","Button","失效","证件失效","setStatus(2)","","","","",""},
		{"true","All","Button","设置为主证件","设置为主证件","setMainFlag()","","","","",""},
		{"true","All","Button","保存","保存修改","save()","","","","",""},
	};

%> 
<script type="text/javascript">	
	var needSave = false;

	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newCert(){
 		if(needSave){
			alert("当前有未保存的信息，不可以新增！");
			return;
		} else{
			needSave = true;
		}
		var sCustomerID = "<%=sCustomerID%>";
		as_add("myiframe0");
		setItemValue(0,getRow(),"CUSTOMERID",sCustomerID); 
		
		var sReturnValue = PopPage("/CustomerManage/CustomerCertDialog.jsp?CustomerType=<%=sCustomerType%>"+"&ListType=<%=sListType%>","","resizable=yes;dialogWidth=420px;dialogHeight=300px;center:yes;status:no;statusbar:no");
		//判断是否返回有效信息
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
				alert("操作成功！");
				reloadSelf();
			}else{
				alert("操作失败");
			}
		}
	}
	
	/*~[Describe=设置证件状态;InputParam=无;OutPutParam=无;]~*/
	function setStatus(status){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sCertType = getItemValue(0,getRow(),"CertType");
		var sCertID = getItemValue(0,getRow(),"CertID");
		var sStatus = getItemValue(0,getRow(),"Status");//证件状态
		var sCustomerCertFlag = getItemValue(0,getRow(),"CustomerCertFlag");

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			if(status==2 && sStatus=="2"){
				alert("该证件已经是失效状态！");
				return;
			}
			if(status==1 && sStatus=="1"){
				alert("该证件已经是生效状态！");
				return;
			}
			var effectCertCount = 0;
			if(status=="2"){
				for(var i=0;i<getRowCount(0);i++){
					if(getItemValue(0,i,"Status")=="1")
						effectCertCount+=1;
				}
			if(effectCertCount==1){
				alert("该用户目前有且仅有一个有效证件，不允许做失效操作。");
				return;
			}else{
				if(sCustomerCertFlag == "1"){
					alert("不允许对主证件进行失效操作！");
					return;
				}
				var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerCertAction","setCertStatus","SerialNo="+sSerialNo);
				if(sReturn == "true"){
					alert("操作成功！");
					reloadSelf();
				}else{
					alert("操作失败！");
				}
				}
			}
			
			if(status == "1")//生效
			{
		    	//检查要生效的证件是否已存在一张有效的该类型证件，系统中不能同时存在2张证件类型一样的有效证件
				var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerCertAction","existCertStatus","CustomerID=<%=sCustomerID%>"+",CertType="+sCertType+",Status="+sStatus);
		  		if(sReturn == "true_1"){
	 		    	if(confirm("已存在该类型有效的证件，且为主证件，是否确认将当前选中证件设置为有效的主证件？")){
	 					var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerCertAction","updateCertStatus","SerialNo="+sSerialNo+",CustomerID=<%=sCustomerID%>"+",MainFlag=1"+",CertType="+sCertType+",CertID="+sCertID);
	 					if(sReturn == "true"){
	 						alert("操作成功！");
	 						reloadSelf();
	 					}else{
	 						alert("操作失败！");
	 					}
	 		    	} 
		    	}else if(sReturn == "true_2"){
	 		    	if(confirm("已存在该类型有效的证件，是否确认将当前选中证件设置为有效证件？")){
	 					var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerCertAction","updateCertStatus","SerialNo="+sSerialNo+",CustomerID=<%=sCustomerID%>"+",CustomerCertFlag=2"+",CertType="+sCertType+",CertID="+sCertID);
	 					if(sReturn == "true"){
	 						alert("操作成功！");
	 						reloadSelf();
	 					}else{
	 						alert("操作失败！");
	 					}
			    	} 
		    	}else if(sReturn == "false"){
 					var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerCertAction","updateCertStatus","SerialNo="+sSerialNo+",CustomerID=<%=sCustomerID%>"+",CustomerCertFlag=2"+",CertType="+sCertType+",CertID="+sCertID);
 					if(sReturn == "true"){
 						alert("操作成功！");
 						reloadSelf();
 					}else{
 						alert("操作失败！");
 					}
		    	} 
			}


		}
	}
	
	/*~[Describe=将选中证件设置为主证件;InputParam=无;OutPutParam=无;]~*/
	function setMainFlag(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var certType = getItemValue(0,getRow(),"CertType");
		var certID = getItemValue(0,getRow(),"CertID");
		var status = getItemValue(0,getRow(),"Status");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			if(status=="2"){
				alert("无效状态的证件不能设置为主证件！");
				return;
			}
			var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerCertAction","setMainCert","SerialNo="+sSerialNo+",CustomerID=<%=sCustomerID%>"+",CertType="+certType+",CertID="+certID);
	 		if(sReturn == "true")
			{
				alert("操作成功！");
				reloadSelf();
			}else{
				alert("操作失败");
			}
		}
	}
	
	/*~[Describe=设置国别;InputParam=无;OutPutParam=无;]~*/
	function selectCountry()
	{	
		sParaString = "CodeNo"+",CountryCode";		
		setObjectValue("SelectCode",sParaString,"@ISSUECOUNTRY@0@ISSUECOUNTRYNAME@1",0,getRow(),"");
	}
	
	/*~[Describe=设置证件签发城市;InputParam=无;OutPutParam=无;]~*/
	function selectArea()
	{
		sParaString = "CodeNo"+",AreaCode";	
		setObjectValue("SelectCode",sParaString,"@CNIDREGCITY@0@CNIDREGCITYNAME@1",0,getRow(),"");

	}
	
	/*~[Describe=日历选择;InputParam=无;OutPutParam=无;]~*/
	function selectIDExpiry()
	{
		var sIDExpiry = PopPage("/FixStat/SelectDate.jsp?rand="+randomNumber(),"","dialogWidth=300px;dialogHeight=250px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sIDExpiry)!="undefined")
		{
			setItemValue(0,getRow(),"IDEXPIRY",sIDExpiry);
		}
	}
	
	/*~[Describe=保存改动内容;InputParam=无;OutPutParam=无;]~*/
	function save()
	{
		var ISSUECOUNTRY = getItemValue(0,getRow(),"ISSUECOUNTRY");
		var CNIDREGCITY = getItemValue(0,getRow(),"CNIDREGCITY");
		if(ISSUECOUNTRY!='CHN' &&  CNIDREGCITY.length > 0){
			alert("发证国家不为“中华人民共和国”时，证件签发城市无需选择。");
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
