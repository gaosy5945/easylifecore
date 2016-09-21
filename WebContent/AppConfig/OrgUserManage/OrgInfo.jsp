<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		页面说明: 机构信息详情
	 */
	String PG_TITLE = "机构信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得页面参数	
	String sOrgID =  CurPage.getParameter("CurOrgID");
	if(sOrgID == null) sOrgID = "";

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ORG_INFO";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	if(sOrgID.equals("")) doTemp.setReadOnly("OrgID,OrgLevel", false);
    //设置上级机构选择方式
    doTemp.setUnit("BelongOrgName","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.getOrgName();\"> ");
	doTemp.setHTMLStyle("BelongOrgName","  style={cursor:pointer;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getOrgName()\" ");
	doTemp.appendHTMLStyle("OrgID,SortNo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");
			
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow(sOrgID);
	//定义后续事件
	//dwTemp.setEvent("AfterInsert","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//dwTemp.setEvent("AfterUpdate","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//生成HTMLDataWindow

	String sButtons[][] = {
		//{(CurUser.hasRole("099")?"true":"false"),"","Button","保存","保存修改","saveRecord()","","","",""},
		{"true","","Button","保存","保存修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回到列表界面","doReturn()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	var bIsInsert = false;
	function saveRecord(){
		if(bIsInsert && checkPrimaryKey("ORG_INFO","OrgID")){
			alert("该机构号已存在，请检查输入！");
			return;
		}
		
// 	    var sOrgLevel = getItemValue(0,getRow(),"OrgLevel");
// 	    if (typeof(sOrgLevel) == 'undefined' || sOrgLevel.length == 0){
//         	alert(getBusinessMessage("901"));//请选择级别！
//         	return;
//         }else{
//         	if(sOrgLevel != '0'){
//         		var sBelongOrgName = getItemValue(0,getRow(),"BelongOrgName");
// 			    if (typeof(sBelongOrgName) == 'undefined' || sBelongOrgName.length == 0){
// 		        	alert("请选择上级机构！");
// 		        	return;
// 		        }
//         	}
//         }
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
       setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
       as_save("myiframe0","");
	}
    
	function doReturn(){
		OpenPage("/AppConfig/OrgUserManage/OrgList.jsp","_self","");
	}

	<%/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;]~*/%>
	function getOrgName(){
		var sOrgID = getItemValue(0,getRow(),"OrgID");
// 		var sOrgLevel = getItemValue(0,getRow(),"OrgLevel");
		if (typeof(sOrgID) == 'undefined' || sOrgID.length == 0){
        	alert(getBusinessMessage("900"));//请输入机构编号！
        	return;
        }
// 		if (typeof(sOrgLevel) == 'undefined' || sOrgLevel.length == 0){
//         	alert(getBusinessMessage("901"));//请选择级别！
//         	return;
//         }
		
		
		
		//sParaString = "OrgID"+sOrgID;
		//	
		if(sOrgID.indexOf("10") == 0){ //以10开头的编号
			sParaString = "OrgID,"+"<%=CurOrg.getOrgID()%>";	
			setObjectValue("SelectBelongOrg",sParaString,"@BelongOrg@0@BelongOrgName@1",0,0,"");	;//针对总行职能部门			
	    }else{
	    	sParaString = "OrgID"+","+sOrgID+","+"OrgLevel"+","+sOrgLevel;
	    	//setObjectValue("SelectOrg",sParaString,"@BelongOrgID@0@BelongOrgName@1",0,0,"");//针对一般机构 	
	    	setObjectValue("SelectUpperOrgInfo",sParaString,"@BelongOrg@0@BelongOrgName@1",0,0,"");//针对一般机构
	    	//setObjectValue("SelectBelongOrg",sParaString,"@BelongOrg@0@BelongOrgName@1",0,0,"");	    	
	    	//setObjectValue("SelectUpperOrgInfo",sParaString,"@BelongOrg@0@BelongOrgName@1",0,0,"");
		}
	}
	
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getNow()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	initRow();
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>