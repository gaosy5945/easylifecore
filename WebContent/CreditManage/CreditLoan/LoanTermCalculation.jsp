<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
  double MonthPay=0.0D;//�»����
  int    Term=0;//��������
  double BenRate=0.0D;//��׼����
  double FloatRate=0.0D;//���ʸ�������
  double LoanRate=0.0D;//����������
  double LoanSum=0.0D;//������

  
  String sFloatRate = "";
  String sMonthPay ="";
  String sBenRate ="";
  String sLoanSum = "";

%>
<html>
<head>
<title>������������</title> 
</head>
<table width=100% >
      <tr>
<td>
</td>
  </tr>
      </table>
<body class="pagebackground" leftmargin="0" topmargin="0" onload="" >
<form name=frm action="LoanTermCalculation.jsp">
<h3 style="text-align:center;">������������</h3>

<table width=100%>
	
	<tr>
		<td width=100% align=center>
		   �����ܶ�(Ԫ)��
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanSum" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1>
		</td>  
	</tr>	   
	
	<tr>
		<td width=100% align=center>
		   �����»����(Ԫ)��
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanMonthPay" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1>
		</td>  
	</tr>	 
	
	<tr>
		<td width=100% align=center>
		   ��׼����(%)��
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanBenRate" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1>
		</td>  
	</tr>
	
	<tr>
		<td width=100% align=center>
		   ���ʸ�������(%)��
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanFloatRate" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1>
		</td>  
	</tr>
	
	<tr>
		<td width=100% align=center>
		   ����������(%)��
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" readonly=true type=text name="LoanRate" style='background:grey;FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1>
		</td>  
	</tr>
</table>
<p><p><p><p>
<table width=100% align=center>	
	<tr>
		  <td align=right><%=HTMLControls.generateButton("����","���д������","javascript:Calculate()","")%></td>
          <td><%=HTMLControls.generateButton("����","����","javascript:Cancel()","")%></td>
    </tr>	
</table>   
<p><p><p><p>
<table width=100% align=center> 
    <tr width=100% align=center>
    	  <td width=100% align=center>
    	    ��������:
    	  </td>
    </tr>
	<tr width=100% align=center>		  
    	  <td width=100% align=center>
		  <input  value="" readonly=true type=text name="LoanTerm" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt' size=1 >
		 </td> 
    </tr> 
</table>
</form>
</body>

</html>


<script>

function Calculate()
{   
	var numberRule = /^-?\d+(\.?\d+)?$/; //ƥ��С��
    if (document.frm.LoanSum.value=="")
    {
        alert("��Ĵ����ܶ��Ϊ�գ�");
        return;
    }
    if (document.frm.LoanMonthPay.value=="")
    {
        alert("��������»�����Ϊ�գ�");
        return;
    }
    if (document.frm.LoanBenRate.value=="")
    {
        alert("��Ļ�׼���ʲ���Ϊ�գ�");
        return;
    }
	if (document.frm.LoanFloatRate.value=="")
	{
	    alert("������ʸ�����������Ϊ�գ�");
	    return;
	}
	if (reg_Num(document.frm.LoanSum.value)!=1)
    {
    	alert("��Ĵ����ܶ�Ӧ��Ϊ���֣�");
    	return;
    
    }
    if (reg_Num(document.frm.LoanMonthPay.value)!=1)
    {
    	alert("��������»����Ӧ��Ϊ���֣�");
    	return;
    
    }
    if (reg_Num(document.frm.LoanBenRate.value)!=1)
    {
    	alert("��Ļ�׼����Ӧ��Ϊ���֣�");
    	return;
    
    }
    /* if (reg_Num(document.frm.LoanFloatRate.value)!=1)
    {
    	alert("������ʸ�������Ӧ��Ϊ���֣�");
    	return;
    
    } */
    if (!numberRule.test(document.frm.LoanFloatRate.value))
    {
    	alert("������ʸ�������Ӧ��Ϊ���֣�");
    	return;
    
    }
    if (parseFloat(document.frm.LoanSum.value)<=0)
    {
        alert("��Ĵ����ܶ��Ϊ�㣡");
        return;
    }
    if (parseFloat(document.frm.LoanMonthPay.value)<=0)
    {
        alert("��������»�����Ϊ�㣡");
        return;
    }   
    if (parseFloat(document.frm.LoanBenRate.value)<=0)
    {
        alert("��Ļ�׼���ʲ���Ϊ�㣡");
        return;
    }

    sLoanSum = document.frm.LoanSum.value;
	sMonthPay = document.frm.LoanMonthPay.value;
	sBenRate = document.frm.LoanBenRate.value;
	sFloatRate = document.frm.LoanFloatRate.value;
	
	var rtLoanRate = sBenRate * (1 + sFloatRate/100);//��׼����
	document.frm.LoanRate.value = rtLoanRate.toFixed(2);
	var rtQrate = sBenRate/100 * (1 + sFloatRate/100) / 12;//������
	var rtValue =  Math.log(1+1/(sMonthPay/(sLoanSum*rtQrate)-1))/Math.log(1+rtQrate);
	document.frm.LoanTerm.value = rtValue.toFixed(1);
}

function Cancel()
{
	   document.frm.LoanMonthPay.value="";
	   document.frm.LoanTerm.value=""; 
	   document.frm.LoanBenRate.value=""; 
	   document.frm.LoanFloatRate.value=""; 
	   document.frm.LoanRate.value=""; 
	   document.frm.LoanSum.value="";
}

function reg_Int(str)//������,����true.
{
	var Letters = "1234567890";
	for (i=0;i<str.length;i++)
	{
		var CheckChar = str.charAt(i);
		if (Letters.indexOf(CheckChar) == -1)
		{
			return false;
		}
	}
	return 1;
}

function reg_Num(str)//������,����true.
{
	var Letters = "1234567890.";
	for (i=0;i<str.length;i++)
	{
	var CheckChar = str.charAt(i);
	if (Letters.indexOf(CheckChar) == -1){return false;}
	}
	return 1;
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
