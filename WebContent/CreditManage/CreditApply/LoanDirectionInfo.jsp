<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	//���ҳ�����	
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	//����ֵת���ɿ��ַ���
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
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASObjectModel doTemp = new ASObjectModel("LoanDirectionInfo");
	//����DataWindow����	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";   //����DW��� 1:Grid 2:Freeform
    //dwTemp.ReadOnly="1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow(objectNo+","+objectType);
	
    String sButtons[][] = {
   		{"true","All","Button","����","���������޸�","saveRecord()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	function saveRecord(){
		as_save("myiframe0");
	}

	/*~[Describe=ѡ����ҵͶ�򣨹�����ҵ���ͣ�;InputParam=��;OutPutParam=��;]~*/
	function getIndustryType(){
		var industryType = getItemValue(0,getRow(),"RelaDirection");
		if(typeof(industryType) == "undfined" || industryType.length==0){
			alert("����ѡ��ʵ��Ͷ��");
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