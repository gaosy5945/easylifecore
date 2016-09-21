<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectType = DataConvert.toString(CurPage.getParameter("ObjectType"));
	String objectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));
	String buttonShowFlag = DataConvert.toString(CurPage.getParameter("ButtonShowFlag"));
	if(buttonShowFlag==null||buttonShowFlag.length()==0)buttonShowFlag="";
	
	ASObjectModel doTemp = new ASObjectModel("InspectRecordList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.genHTMLObjectWindow(objectType+","+objectNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{(!"0".equals(buttonShowFlag))?"true":"false","","Button","�������","����","edit()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	function edit(){
		var serialNo = getItemValue(0,getRow(0),'SERIALNO');
		var creditInspectType = getItemValue(0,getRow(0),'INSPECTTYPE');;
		
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert(getHtmlMessage('1'));
			return ;
		}
		var functionID = "";
		if(creditInspectType == "01"){
			functionID = "FundDirectionInfo_View";
		}else if(creditInspectType == "02"){
			functionID = "FundPurposeInfo_View";
		}else if(creditInspectType == "03"){
			functionID = "RunDirectionInfo_View";
		}else if(creditInspectType == "05"){
			functionID = "HandDirectionInfo_View";
		}else if(creditInspectType == "06"){
			functionID = "PrjCusCheckList_View";
		}else {
			functionID = "ConsumeDirectionInfo_View";
		}
		
		AsCredit.openFunction(functionID,"SerialNo="+serialNo+"&CreditInspectType="+creditInspectType+"&RightType=ReadOnly");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
