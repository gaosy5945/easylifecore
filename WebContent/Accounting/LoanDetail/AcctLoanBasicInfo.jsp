<%@page import="com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

	<%
		String PG_TITLE = "��ݻ�����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>

		String templetFilter="1=1";
		String templetNo;
		//����������
		
		//���ҳ�����
		String SerialNo =  CurPage.getParameter("ObjectNo");//��ݱ��
		if(SerialNo == null)SerialNo = "";
		  //ͨ����ʾģ�����ASObjectModel����doTemp---------------------------------
		String sTemplete = "ACCT_LOAN";
		templetNo=sTemplete;
	  		ASObjectModel doTemp = new ASObjectModel(sTemplete);
	  		ASObjectWindow dwTemp = new ASObjectWindow(CurPage ,doTemp,request); 
	  		dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	  		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	  	//����HTMLObjectWindow
	  	dwTemp.genHTMLObjectWindow(SerialNo);	
	    
		String sButtons[][] = {
		};
	%> 


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<%/*~END~*/%>

<script language=javascript>
// 	function afterLoad()
// 	{
// 		calcLoanRateTermID();
// 		calcRPTTermID();
// 	}
	/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;]~*/
// 	function calcLoanRateTermID(){
// 		var sLoanRateTermID = getItemValue(0,getRow(),"LoanRateTermID");
// 		if(typeof(sLoanRateTermID) == "undefined" || sLoanRateTermID.length == 0) return;
// 		var currency = getItemValue(0,getRow(),"CurrencyCode");
// 		var sPutoutDate = getItemValue(0,getRow(),"PutOutDate");
// 		var sMaturityDate = getItemValue(0,getRow(),"MaturityDate");
// 		var termMonth = RunMethod("BusinessManage","GetUpMonths",sPutoutDate+","+sMaturityDate);

<%-- 		OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/BusinessTermView.jsp","Currency="+currency+"&ToInheritObj=y&termMonth="+termMonth+"&Status=1&ObjectNo="+"<%=SerialNo%>"+"&ObjectType="+"<%=BUSINESSOBJECT_CONSTANTS.loan%>"+"&TempletNo=RateSegmentView&TermObjectType="+"<%=BUSINESSOBJECT_CONSTANTS.loan_rate_segment%>"+"&TermID="+sLoanRateTermID,"RatePart",""); --%>
// 	}
// 	/*~[Describe=���ʽ��Ϣ;InputParam=��;OutPutParam=��;]~*/
// 	function calcRPTTermID(){
// 		var sRPTTermID = getItemValue(0,getRow(),"RPTTermID");
// 		if(typeof(sRPTTermID) == "undefined" || sRPTTermID.length == 0) return;
<%-- 		OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/BusinessTermView.jsp","ToInheritObj=y&Status=1&ObjectNo=<%=SerialNo%>&ObjectType=<%=BUSINESSOBJECT_CONSTANTS.loan%>&TempletNo=RPTSegmentView&TermObjectType=<%=BUSINESSOBJECT_CONSTANTS.loan_rpt_segment%>&TermID="+sRPTTermID,"RPTPart",""); --%>
// 	}
	
	
// 	AsOne.AsInit();
// 	init();
// 	my_load(2,0,'myiframe0');
// 	afterLoad();
</script>	


<%@ include file="/Frame/resources/include/include_end.jspf"%>
