<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectType = DataConvert.toString(CurPage.getParameter("ObjectType"));
	String objectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));
	String buttonShowFlag = DataConvert.toString(CurPage.getParameter("ButtonShowFlag"));
	if(buttonShowFlag==null||buttonShowFlag.length()==0)buttonShowFlag="";
	
	ASObjectModel doTemp = new ASObjectModel("InspectRecordList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.genHTMLObjectWindow(objectType+","+objectNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{(!"0".equals(buttonShowFlag))?"true":"false","","Button","检查详情","详情","edit()","","","","",""},
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
