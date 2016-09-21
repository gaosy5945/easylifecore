<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String ProjectSerialNo=CurPage.getAttribute("ProjectSerialNo");
	if(ProjectSerialNo == null) ProjectSerialNo = "";
	
    ASObjectModel doTemp = new ASObjectModel("ProjectMarginInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      	     //设置为Grid风格式
    dwTemp.genHTMLObjectWindow(ProjectSerialNo);

	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		as_save(0,"marginDetail()");
	}
	
    function marginDetail(){
    	var SerialNo = getItemValue(0,getRow(0),"SerialNo");
    	var ObjectType = "jbo.guaranty.CLR_MARGIN_INFO";
		var obj = parent.document.getElementById("FirstFrame"); //判断是否上下结构
		if(obj != null && typeof(obj) != "undefined")
		{
    		AsControl.OpenView("/ProjectManage/ProjectNewApply/ProjectMarginIFrame.jsp","ObjectNo="+SerialNo+"&ObjectType="+ObjectType+"&ProjectSerialNo="+"<%=ProjectSerialNo%>","rightdown","");
		}
    }
    function buttonEvent(){
    	var marginPaymentWay = getItemValue(0,0,"MARGINPAYMENTWAY");
    	if(marginPaymentWay == "02"){
    		setItemRequired(0,"PREPAYAMOUNT",true);
    	}else if(marginPaymentWay == "03"){
    		setItemRequired(0,"PREPAYCALMETHOD",true);
    	}
    	if(marginPaymentWay == "01" || marginPaymentWay == "03"){
    		setItemRequired(0,"PREPAYPERCENT",true);
    	}
    }
	function calculatePrepaySum(){
		var prepayAmount = getItemValue(0,getRow(),"PREPAYAMOUNT").replace(/,/g,"");
		var prepayPercent = getItemValue(0,getRow(),"PREPAYPERCENT").replace(/,/g,"");
		if(prepayAmount < 0 || prepayPercent < 0) {
			alert("参数不可为负数！请重新输入！");
			return;
		}else if(prepayAmount == 0 || prepayPercent == 0){
			setItemValue(0,getRow(),"PREPAYSUM","0");
		}else{
			var prepaySum = FormatKNumber(parseFloat(prepayAmount)*parseFloat(prepayPercent)/100.00,2);
			setItemValue(0,getRow(),"PREPAYSUM",prepaySum); 
		};	
	}
	function initRow(){
		var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			SerialNo = getSerialNo("CLR_MARGIN_INFO","SerialNo","");
			setItemValue(0,0,"SerialNo",SerialNo);
			setItemValue(0,0,"ObjectType","jbo.prj.PRJ_BASIC_INFO");
			setItemValue(0,0,"ObjectNo","<%=ProjectSerialNo%>");
		}else{
			marginDetail();
		}
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
