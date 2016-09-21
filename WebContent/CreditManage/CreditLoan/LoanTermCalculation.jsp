<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
  double MonthPay=0.0D;//月还款额
  int    Term=0;//贷款期限
  double BenRate=0.0D;//基准利率
  double FloatRate=0.0D;//利率浮动比例
  double LoanRate=0.0D;//贷款年利率
  double LoanSum=0.0D;//贷款金额

  
  String sFloatRate = "";
  String sMonthPay ="";
  String sBenRate ="";
  String sLoanSum = "";

%>
<html>
<head>
<title>贷款期限试算</title> 
</head>
<table width=100% >
      <tr>
<td>
</td>
  </tr>
      </table>
<body class="pagebackground" leftmargin="0" topmargin="0" onload="" >
<form name=frm action="LoanTermCalculation.jsp">
<h3 style="text-align:center;">贷款期限试算</h3>

<table width=100%>
	
	<tr>
		<td width=100% align=center>
		   贷款总额(元)：
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanSum" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1>
		</td>  
	</tr>	   
	
	<tr>
		<td width=100% align=center>
		   期望月还款额(元)：
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanMonthPay" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1>
		</td>  
	</tr>	 
	
	<tr>
		<td width=100% align=center>
		   基准利率(%)：
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanBenRate" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1>
		</td>  
	</tr>
	
	<tr>
		<td width=100% align=center>
		   利率浮动比例(%)：
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanFloatRate" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1>
		</td>  
	</tr>
	
	<tr>
		<td width=100% align=center>
		   贷款年利率(%)：
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
		  <td align=right><%=HTMLControls.generateButton("试算","进行贷款计算","javascript:Calculate()","")%></td>
          <td><%=HTMLControls.generateButton("重置","重置","javascript:Cancel()","")%></td>
    </tr>	
</table>   
<p><p><p><p>
<table width=100% align=center> 
    <tr width=100% align=center>
    	  <td width=100% align=center>
    	    贷款期限:
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
	var numberRule = /^-?\d+(\.?\d+)?$/; //匹配小数
    if (document.frm.LoanSum.value=="")
    {
        alert("你的贷款总额不能为空！");
        return;
    }
    if (document.frm.LoanMonthPay.value=="")
    {
        alert("你的期望月还款额不能为空！");
        return;
    }
    if (document.frm.LoanBenRate.value=="")
    {
        alert("你的基准利率不能为空！");
        return;
    }
	if (document.frm.LoanFloatRate.value=="")
	{
	    alert("你的利率浮动比例不能为空！");
	    return;
	}
	if (reg_Num(document.frm.LoanSum.value)!=1)
    {
    	alert("你的贷款总额应该为数字！");
    	return;
    
    }
    if (reg_Num(document.frm.LoanMonthPay.value)!=1)
    {
    	alert("你的期望月还款额应该为数字！");
    	return;
    
    }
    if (reg_Num(document.frm.LoanBenRate.value)!=1)
    {
    	alert("你的基准利率应该为数字！");
    	return;
    
    }
    /* if (reg_Num(document.frm.LoanFloatRate.value)!=1)
    {
    	alert("你的利率浮动比例应该为数字！");
    	return;
    
    } */
    if (!numberRule.test(document.frm.LoanFloatRate.value))
    {
    	alert("你的利率浮动比例应该为数字！");
    	return;
    
    }
    if (parseFloat(document.frm.LoanSum.value)<=0)
    {
        alert("你的贷款总额不能为零！");
        return;
    }
    if (parseFloat(document.frm.LoanMonthPay.value)<=0)
    {
        alert("你的期望月还款额不能为零！");
        return;
    }   
    if (parseFloat(document.frm.LoanBenRate.value)<=0)
    {
        alert("你的基准利率不能为零！");
        return;
    }

    sLoanSum = document.frm.LoanSum.value;
	sMonthPay = document.frm.LoanMonthPay.value;
	sBenRate = document.frm.LoanBenRate.value;
	sFloatRate = document.frm.LoanFloatRate.value;
	
	var rtLoanRate = sBenRate * (1 + sFloatRate/100);//基准利率
	document.frm.LoanRate.value = rtLoanRate.toFixed(2);
	var rtQrate = sBenRate/100 * (1 + sFloatRate/100) / 12;//期利率
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

function reg_Int(str)//是整数,返回true.
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

function reg_Num(str)//是数字,返回true.
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
