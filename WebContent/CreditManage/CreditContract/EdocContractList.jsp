<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	/*
	Author:   qzhang  2004/12/04
	Tester:
	Content: 电子合同列表
	Input Param:	 
	Output param:
	History Log: 
	*/
	
	//获得组件参数
	String sObjectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));//电子合同对应合同号
	String sObjectType = DataConvert.toString(CurPage.getParameter("ObjectType"));//合同类型
	String edocs = "All";
	if("jbo.app.BUSINESS_CONTRACT".equals(sObjectType))
	{
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject bc = bom.loadBusinessObject(sObjectType, sObjectNo);
		edocs = ProductAnalysisFunctions.getComponentOptionalValue(bc, "PRD04-03", "BusinessEDocs", "", "02");
		if(edocs == null) edocs = "All";
	}
	//<!---------->模板编号，之后动态获取！！！！
	String docno = "0101";

	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	
	ASObjectModel doTemp = new ASObjectModel("EdocContrctList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ObjectNo", sObjectNo);
	dwTemp.setParameter("ObjectType", sObjectType);
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","生成电子合同","生成电子合同","getEDoc()","","","","",""},
			{"true","","Button","查看电子合同","查看电子合同","showDoc()","","","","",""},
			{"true","All","Button","打印","打印","printDoc()","","","","",""},
			{"true","All","Button","删除","删除","deletere()","","","","",""}
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function deletere(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		as_delete(0);
	}
	function PrintEDocView()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "EDocViewNew";
		sCompURL = "/Common/EDOC/EDocViewNew.jsp";
		sParamString = "SerialNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}
	
	function getEDoc(){
		
		var returnValue = "";
		if("<%=sObjectType%>" == "jbo.guaranty.GUARANTY_CONTRACT"){
			returnValue = AsCredit.selectMultipleTree("SelectEDocConfig1", "", ",", "");
		}else{
			returnValue = AsCredit.selectMultipleTree("SelectEDocConfig", "EDocs,<%=edocs%>", ",", "");
		}
		if(returnValue["ID"].length == 0) return;
		var eDocID = returnValue["ID"];
		eDocID = eDocID.split(",");
		for(var i in eDocID){
			if(typeof eDocID[i] == "string" && eDocID.length > 0 ){
				var ID = eDocID[i];
				var sReturn =  RunJavaMethodTrans("com.amarsoft.app.edoc.EDocPrint","docHandle","objectno=<%=sObjectNo%>,objecttype=<%=sObjectType%>,docNo="+ID);
				if(sReturn == "true"){
					alert("生成成功");
					reloadSelf(); 
				}
				else{
					alert("生成失败");
				}
			}
		}
		return;
	}
	
	function printDoc(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		RunJavaMethodTrans("com.amarsoft.app.edoc.UploadBaseRate","uploadBaseRate","serialNo=<%=sObjectNo%>");
		if (typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		var printNum = getItemValue(0,getRow(),"PrintNum");
		if (typeof(printNum)=="undefined" || printNum.length==0){
			printNum = "0";
		}
		/* sCompID = "EDocViewNew";
		sCompURL = "CreditManage/CreditContract/EDocViewNew.jsp";
		sParamString = "SerialNo="+docNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle); */
	    showDoc();
	    RunJavaMethodTrans("com.amarsoft.app.edoc.EDocPrint", "upPrintNum", "SerialNo="+serialNo+",PrintNum="+printNum);
	    reloadSelf();
	}
	
	function showDoc(){
		
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else{
			AsControl.PopView("CreditManage/CreditContract/ShowEDoc.jsp","serialNo="+sSerialNo);
		}		
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
