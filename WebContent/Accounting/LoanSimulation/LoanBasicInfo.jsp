<%@page import="com.amarsoft.app.accounting.config.impl.CashFlowConfig"%>
<%@page import="com.amarsoft.app.base.config.impl.BusinessComponentConfig"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObjectHelper"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	
	String sTempletNo = "LoanSimulationBasicInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	
	//字段显示子页面
	for (int i = 0; i < dwTemp.getDataObject().Columns.size(); ++i){
    	ASColumn column = (ASColumn) dwTemp.getDataObject().Columns.get(i);
    	String htmlStyle = column.getAttribute("ColHTMLStyle");
    	if(!StringX.isEmpty(htmlStyle) && htmlStyle.indexOf("iframe") > -1)
    	{
    		String name = column.getAttribute("ColName");
    		dwTemp.replaceColumn(name, htmlStyle, CurPage.getObjectWindowOutput());
    	}
  	}
	
	String businessDate = DateHelper.getBusinessDate();
	String sButtons[][] = {
		{"true","All","Button","重置","重置","reloadSelf()","","","",""},
		{"true","All","Button","贷款咨询","贷款咨询","run()","","","",""},
	};
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
function run()
{
	var rpt=RPTFrame.getValues();
	if(!rpt) return;
	var rat=RATFrame.getValues();
	if(!rat) return;
	var loan = getValues();
	if(!loan) return;
	RPTFrame.CHANGED=false;
	RATFrame.CHANGED=false;
	CHANGED=false;
	document.all("A_Group_PSPart").style.display="";
	
	 var form = document.createElement("form");    
     form.id="runform";    
     form.method="post";    
     form.action="<%=sWebRootPath%>/Accounting/LoanSimulation/PaymentScheduleList.jsp";    
     form.target="PSFrame";    
     var hideInput = document.createElement("input");    
     hideInput.type="hidden";    
     hideInput.name= "loan"  
     hideInput.value= loan;  
     form.appendChild(hideInput);     
  
     hideInput = document.createElement("input");    
     hideInput.type="hidden";    
     hideInput.name= "rpt"  
     hideInput.value= rpt;  
     form.appendChild(hideInput);
     
     hideInput = document.createElement("input");    
     hideInput.type="hidden";    
     hideInput.name= "rat"  
     hideInput.value= rat;  
     form.appendChild(hideInput);
     
     hideInput = document.createElement("input");    
     hideInput.type="hidden";    
     hideInput.name= "CompClientID"  
     hideInput.value= "<%=sCompClientID%>";
     form.appendChild(hideInput);
     
     document.body.appendChild(form);    
     form.submit();  
     document.body.removeChild(form); 
}

/*~[Describe=打开还款方式信息;InputParam=无;OutPutParam=无;]~*/
function openRPT(iframe,param){
	var putoutDate = getItemValue(0,getRow(),"PutOutDate");
	if(!putoutDate){
		AsControl.OpenView("/Blank.jsp","TextToShow=请先输入发放日期",iframe,"");
		return;
	}
	var maturityDate = getItemValue(0,getRow(),"MaturityDate");
	if(!maturityDate){
		AsControl.OpenView("/Blank.jsp","TextToShow=请先输入到期日期",iframe,"");
		return;
	}
	document.all("A_Group_RPTPart").style.display="";
	var obj = document.getElementById(iframe);
	if(typeof(obj) == "undefined" || obj == null) return;
	obj.CHANGED=false;
	AsControl.OpenView("/Accounting/LoanSimulation/LoanTerm/BusinessRPTInfo.jsp","ObjectType=&ObjectNo=&"+param,iframe,"");
}

/*~[Describe=打开利率信息;InputParam=无;OutPutParam=无;]~*/
function openRAT(iframe,param){
	var currency = getItemValue(0,getRow(),"Currency");
	if(!currency){
		AsControl.OpenView("/Blank.jsp","TextToShow=请先输入币种",iframe,"");
		return;
	}
	var putoutDate = getItemValue(0,getRow(),"PutOutDate");
	if(!putoutDate){
		AsControl.OpenView("/Blank.jsp","TextToShow=请先输入发放日期",iframe,"");
		return;
	}
	var maturityDate = getItemValue(0,getRow(),"MaturityDate");
	if(!maturityDate){
		AsControl.OpenView("/Blank.jsp","TextToShow=请先输入到期日期",iframe,"");
		return;
	}
	document.all("A_Group_RatePart").style.display="";
	var obj = document.getElementById(iframe);
	if(typeof(obj) == "undefined" || obj == null) return; 
	obj.CHANGED=false;
	AsControl.OpenView("/Accounting/LoanSimulation/LoanTerm/BusinessRATInfo.jsp","ObjectType=&ObjectNo=&"+param,iframe,"");
}

//根据起始日期和贷款月数得到贷款结束日期
function getMaturityDate(){
	var putoutDate  = getItemValue(0,getRow(),"PutoutDate");
	var term = getItemValue(0,getRow(),"LoanTerm");
	if(typeof(putoutDate) == "undefined" ||putoutDate==null||putoutDate=="")  return;
	if(typeof(term) == "undefined" ||term==null||term=="")  return;
	var maturityDate =  AsControl.RunJavaMethod("com.amarsoft.acct.accounting.web.DateCal","getRelativeDate","date="+putoutDate+",termUnit=M"+",term="+term);
	setItemValue(0,getRow(),"MaturityDate",maturityDate);
	openRPT("RPTFrame","Status=0,1");
	openRAT("RATFrame","Status=0,1");
}

function getValues(){
	var values = {};
	for(var i=0;i<DisplayFields[0].length;i++){
		values[DisplayFields[0][i]] = getItemValue(0,getRow(),DisplayFields[0][i]);
	}
	return JSON.stringify(values);
}

document.all("A_Group_RPTPart").style.display="none";
document.all("A_Group_RatePart").style.display="none";
document.all("A_Group_PSPart").style.display="none";
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>