<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author: lyin 2014-04-18
		Tester:
		Describe: 
		Input Param:			
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>
 

<html>
<head> 
<title>������ͻ�֤����Ϣ</title>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	
<%/*~END~*/%>

<%
    //�������������ͻ�����
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	String sCustomerType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";
	String sListType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ListType"));
	if(sListType == null) sListType = "";

	String norm = Sqlca.getString("select ItemName from Code_Library where CodeNo = 'AreaCode'");
%>
<%/*~END~*/%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script language=javascript>

	function newCustomer()
	{
		var sCertType = document.all("CertType").value;
		var sCertID = trim(document.all("CertID").value);
		var sIssueCountry = trim(document.all("IssueCountry").value);
		var sIDExpiry = trim(document.all("IDExpiry").value);
		var sCNIDRegCity = trim(document.all("CNIDRegCity").value);
		var sStatus = trim(document.all("Status").value);
		//У��֤����Ϣ
		var CheckLisince = CustomerManage.validIndivdualIndentityCard(sCertID);
		
		if(sCertType == "")
		{
			alert("֤�����Ͳ���Ϊ�ա�");
			return;
		}
		if(sCertID == "")
		{
			alert("֤�����벻��Ϊ�ա�");
			return;
		}
		
		if (sIssueCountry == "")
		{
			alert("֤�����𲻿�Ϊ�գ�");
			return;
		}
		
		//�ж�֤��ǩ������
		if("<%=norm%>".indexOf(sCertType)>=0)
		{
			if(sCNIDRegCity == "")
			{
				alert("֤��ǩ������Ϊ�����");
				return;
			}
		}

		//�ж���֯��������Ϸ���
/* 		if(sCertType =='2020')
		{			
			if(!CheckORG(sCertID))
			{
				alert(getBusinessMessage('102'));//��֯������������
				return;  
			}			
		}	 */
		
		//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
		if(sCertType == "1010" || sCertType == "1011")
		{
			if (!CheckLisince)
			{
				alert(getBusinessMessage('156'));//���֤��������
				return;
			}
		}		
		
		//�ж�֤���Ƿ��ظ�
	    var sResult =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerCertAction","checkCert","CertType="+sCertType+",CertID="+sCertID+",IssueCountry="+sIssueCountry);
		if(sResult=="false")//֤��δ�ظ�
    	{   
    		self.returnValue=sCertType+"@"+sCertID+"@"+sIssueCountry+"@"+sIDExpiry+"@"+sCNIDRegCity+"@"+sStatus;
    		self.close();
    	}else
    	{
    		alert("֤���ظ�!");
    		return;
    	}
	}

	//����ѡ���֤���������ƹ��ҵ�ѡ��
	function selectCountry()
	{
		var sCertType = document.all("CertType").value;
		var sValue1 = RunMethod("PublicMethod","GetColValue","Attribute7,Code_Library,String@CodeNo@CertType@String@ItemNo@"+sCertType);
		var sValue2 = RunMethod("PublicMethod","GetColValue","Attribute8,Code_Library,String@CodeNo@CertType@String@ItemNo@"+sCertType);
		var v1 = sValue1.split("@")[1];
		var v2 = sValue2.split("@")[1];
		if(typeof(v1)=="undefined"||v1=="null"||v1=="")
			v1 = "noValue";
		if(typeof(v2)=="undefined"||v2=="null"||v2=="")
			v2 = "noValue";
		sParaString = "Value1"+","+v1+","+"Value2"+","+v2;
		var sReturn = setObjectValue("selectCountryByCert",sParaString,"",0,0,"");
		if(sReturn == "_CLEAR_")
		{
			document.all("IssueCountry").value = "";
			document.all("IssueCountryName").value = "";
		}
		else if(typeof(sReturn)!="undefined"&&sReturn!="")
		{
			document.all("IssueCountry").value = sReturn.split("@")[0];
			document.all("IssueCountryName").value = sReturn.split("@")[1];
		}
	}

	//��ȡ֤��ǩ������
	function getCnidregCity()
	{
		var sReturn = setObjectValue("SelectCode","CodeNo,AreaCode","",0,0,"");
		if(sReturn == "_CLEAR_")
		{
			document.all("CnidregCityName").value = "";
			document.all("CNIDRegCity").value = "";
		}
		else if(typeof(sReturn)!="undefined"&&sReturn!="")
		{
			document.all("CnidregCityName").value = sReturn.split("@")[1];
			document.all("CNIDRegCity").value = sReturn.split("@")[0];
		}
	}
	
	//����ѡ����
	function selectIDExpiry()
	{
		var sIDExpiry = PopPage("/FixStat/SelectDate.jsp?rand="+randomNumber(),"","dialogWidth=300px;dialogHeight=250px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sIDExpiry)!="undefined")
		{
			document.frm.IDExpiry.value = sIDExpiry;
		}
	}

	function ClearCountry()
	{
		document.all("IssueCountry").value = "";
		document.all("IssueCountryName").value = "";
	}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DCDCDC">
<br>
  <table align="center" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
	<form name="frm" >
	 <tr> 
      <td align="right"  bgcolor="#DCDCDC" width="100">ѡ��֤������&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC" > 
        <select name="CertType" onChange="ClearCountry()">
	   	<%
	    //ѡ��֤������
	    if(!"".equals(sListType)){
		    %>
				<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CustomerCertType' and IsInuse='1' and ItemNo in('2010', '2020', '2999') order by SortNo ",1,2,"")%> 
		    <%
	    }else if("".equals(sListType)&&sCustomerType.substring(0,2).equals("01"))//ѡ��˾�ͻ���֤������
	    {
	    %>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CustomerCertType' and IsInuse='1' and ItemNo like '2%' order by SortNo ",1,2,"")%> 
	    <%
		}
	    else if("".equals(sListType)&&sCustomerType.substring(0,2).equals("06")){//���ڿͻ�
        %>
    		<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CustomerCertType' and IsInuse='1' and ItemNo like 'Ent%' or ItemNo like 'Fellow%' order by SortNo ",1,2,"")%> 
    	<%	
	    }
		else if("".equals(sListType)&&sCustomerType.substring(0,2).equals("03"))//ѡ����˿ͻ���֤������
		{
	    %>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CustomerCertType' and IsInuse='1' and ItemNo like '1%' order by SortNo ",1,2,"")%> 
	    <%
		}		
	    %>
		</select>
      </td>
    </tr>
   <tr> 
      <td align="right"  bgcolor="#DCDCDC" width="100">֤������&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC"> 
        <input type='text' name="CertID" value="">
      </td>
    </tr>
    
     <tr> 
      <td align="right"  bgcolor="#DCDCDC" width="100">֤������&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td bgcolor="#DCDCDC"> 
        <input type="text" value="" name="IssueCountryName" readonly="readonly"/>
        <input type="button" value="..." onclick="selectCountry()"/>
        <input type="hidden" value="" name="IssueCountry"/>
	  </td>
    </tr>
    
   <tr> 
      <td align="right"  bgcolor="#DCDCDC" width="100">֤��������&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC"> 
        <input type='text' name="IDExpiry" value="" readonly="readonly" onclick="selectIDExpiry();">
        <input type="button" value="..."  onclick="selectIDExpiry();">
      </td>
    </tr>
    <tr> 
      	<td align="right"  bgcolor="#DCDCDC" width="100">֤��ǩ������&nbsp;</td>
      	<td bgcolor="#DCDCDC"> 
       		<input type="text" name="CnidregCityName" value="" readonly="readonly"/>
       		<input type="button" value="..." onClick="getCnidregCity()"/>
       		<input type="hidden" name="CNIDRegCity" value=""/>
     	</td>
    </tr>
    
	<tr style="display: none"> 
      <td align="right"  bgcolor="#DCDCDC" width="100">֤��״̬&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC"> 
         <select name="Status" >
 			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IsInUse' and ItemNo = '1' order by SortNo ",1,2,"")%> 
	     </select>
      </td>
    </tr>
    <tr>
      <td align="right"  bgcolor="#DCDCDC" width="100">&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC" height="25"> 
        <input type="button" name="next" value="ȷ��" onClick="javascript:newCustomer()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
	</form>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>