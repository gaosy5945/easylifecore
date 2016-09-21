<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%
  double MonthPay=0.0D;//月还款额
  int    Term=0;//贷款期限
  double BenRate=0.0D;//基准利率
  double FloatRate=0.0D;//利率浮动比例
  double LoanRate=0.0D;//贷款年利率
  double LoanSum=0.0D;//贷款金额
 
  
  String sMonthPay="";
  String sTerm="";
  String sBenRate="";
  String sFloatRate="";
%>
<html>
<head>
<title>贷款金额试算</title> 
</head>
<table width=100% >
      <tr>
<td>
</td>
  </tr>
      </table>
<body class="pagebackground" leftmargin="0" topmargin="0" onload="" >
<form name=frm action="LoanAmountCalculation.jsp">
<h3  style="text-align:center;">贷款金额试算</h3>

<p><p><p><p><p><p><p><p><p><p><p>
<table width=100% >	
	<tr>
		<td width=100% align=center>
		   月还款额(元)：
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanMonthPay" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1 onblur="CalRate();">
		</td>  
	</tr>	
	<tr>
		<td width=100% align=center>
		   贷款期限(月)：
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanTerm" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1 onblur="get_rate();");">
		</td>  
	</tr>
	<tr>
		<td width=100% align=center>
		   基准利率(%)：
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanBenRate" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1 onChange2="CalRate();">
		</td>  
	</tr>
	<tr>
		<td width=100% align=center>
		   利率浮动比例(%)：
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanFloatRate" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1 onChange2="CalRate();">
		</td>  
	</tr>
	<tr>
		<td width=100% align=center>
		   贷款年利率(%)：
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanRate" style='background:grey;FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1 onChange2="CalRate();">
		</td>  
	</tr>
</table>
<p><p><p><p>
<table width=100% align=center>	
	<tr>
		  <td align=right><%=HTMLControls.generateButton("试算","进行贷款试算","javascript:Calculate()","")%></td>
          <td><%=HTMLControls.generateButton("重置","重置","javascript:Cancel()","")%></td>
    </tr>	
</table>   
<p><p><p><p>
<table width=100% align=center> 
    <tr width=100% align=center>
    	  <td width=100% align=center>
    	    贷款总金额(元):
    	  </td>
    </tr>
	<tr width=100% align=center>		  
    	  <td width=100% align=center>
		  <input  value="" readonly=true type=text name="LoanSum" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1 >
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
	
	if (document.frm.LoanMonthPay.value=="")
	{
	    alert("你的月还款额不能为空！");
	    return;
	}	
    if (document.frm.LoanTerm.value=="")
    {
        alert("你的贷款期限不能为空！");
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
    if (reg_Num(document.frm.LoanMonthPay.value)!=1)
    {
    	alert("你的月还款额应该为数字！");
    	return;
    
    }
    if (reg_Int(document.frm.LoanTerm.value)!=1)
    {
    	alert("你的贷款期限应该为整数！");
    	return;
    
    }
    if (reg_Num(document.frm.LoanBenRate.value)!=1)
    {
    	alert("你的基准利率应该为数字！");
    	return;
    
    }
    if (!numberRule.test(document.frm.LoanFloatRate.value))
    {
    	alert("你的利率浮动比例应该为数字！");
    	return;
    
    }
    if (parseFloat(document.frm.LoanMonthPay.value)<=0)
    {
        alert("你的月还款额不能为零！");
        return;
    }
    if (parseFloat(document.frm.LoanTerm.value)<=0)
    {
        alert("你的贷款期限不能为零！");
        return;
    }   
    if (parseFloat(document.frm.LoanBenRate.value)<=0)
    {
        alert("你的基准利率不能为零！");
        return;
    }
  
 
	sMonthPay = parseFloat(document.frm.LoanMonthPay.value);
	sTerm = parseFloat(document.frm.LoanTerm.value);
	sBenRate = parseFloat(document.frm.LoanBenRate.value);
	sFloatRate = parseFloat(document.frm.LoanFloatRate.value);
	var rtLoanRate =  sBenRate*(1+sFloatRate/100.0);//基准利率
	document.frm.LoanRate.value = rtLoanRate.toFixed(2);
	var rtQrate = sBenRate/100.0*(1+sFloatRate/100.0)/12;//期利率
    var rtValue = sMonthPay/(rtQrate*(1+1/(Math.pow((1+rtQrate),sTerm)-1)));
	document.frm.LoanSum.value = rtValue.toFixed(2);
}

function CalRate()
{

    if (reg_Int(document.frm.LoanTerm.value)!=1)
    {
    	alert("你的贷款期限应该为整数！");
    	return;
    }
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
		if (Letters.indexOf(CheckChar) == -1)
		{
		return false;
		}
	}
	return 1;
}

function get_rate()
{
	var loanterm = document.frm.LoanTerm.value;
	
	if (loanterm=="")
    {
        alert("你的贷款期限不能为空！");
        return;
    }
	
	if (reg_Int(loanterm)!=1)
    {
    	alert("你的贷款期限应该为整数！");
    	return;
    }
	
	
	var baserate = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.sys.tools.GetBaseRate", "getBaseRate", "LoanTerm="+loanterm);
	
	document.frm.LoanBenRate.value=baserate;
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
