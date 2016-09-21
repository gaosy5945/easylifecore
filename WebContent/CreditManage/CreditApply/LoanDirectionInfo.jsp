<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	//获得页面参数	
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	//将空值转化成空字符串
	if(objectType == null) objectType = "";
	if(objectNo == null) objectNo = "";
	
	String direction="",relaDirection="",directionName="";
	
	CreditObjectAction co = new CreditObjectAction(objectNo,objectType);
	BizObject bo = co.creditObject;
	
	direction = bo.getAttribute("direction").getString();
	if(!StringX.isEmpty(direction)){
		directionName=CodeManager.getItemName("IndustryType", direction);
		relaDirection=direction.substring(0, 4);
	}else{
		direction = "";
	}
	//通过显示模版产生ASDataObject对象doTemp
	ASObjectModel doTemp = new ASObjectModel("LoanDirectionInfo");
	//生成DataWindow对象	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";   //设置DW风格 1:Grid 2:Freeform
    //dwTemp.ReadOnly="1"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(objectNo+","+objectType);
	
    String sButtons[][] = {
   		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	function saveRecord(){
		as_save("myiframe0");
	}

	/*~[Describe=选择行业投向（国标行业类型）;InputParam=无;OutPutParam=无;]~*/
	function getIndustryType(){
		var industryType = getItemValue(0,getRow(),"RelaDirection");
		if(typeof(industryType) == "undfined" || industryType.length==0){
			alert("请先选择实际投向！");
			return;
		}
		
		var param = "CodeNo"+","+"IndustryType"+","+"ItemNo"+","+industryType;
		var result = setObjectValue("SelectCode2",param,"@Direction@0@DirectionName@1",0,0,"");	
		if(typeof(result)=="undefined" || result.length==0) return;
		if(result == "_CLEAR_"){
			setItemValue(0,getRow(),"Direction","");
			setItemValue(0,getRow(),"DirectionName","");
		}
	}
	
	function initRow(){
		if (getRowCount(0)==0){
			setItemValue(0,getRow(),'ObjectType',"<%=objectType%>");
			setItemValue(0,getRow(),'ObjectNo',"<%=objectNo%>");
			setItemValue(0,getRow(),'RelaDirection',"<%=relaDirection%>");
			setItemValue(0,getRow(),'Direction',"<%=direction%>");
			setItemValue(0,getRow(),'DirectionName',"<%=directionName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
	}
	
	my_load(2,0,'myiframe0'); 
	initRow();	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>