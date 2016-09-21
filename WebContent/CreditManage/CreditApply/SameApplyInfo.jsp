<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "共同申请人详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数	
	String sObjectType = CurComp.getParameter("ObjectType");
	String sObjectNo = CurComp.getParameter("ObjectNo");
	if(sObjectType == null ) sObjectType = "";
	if(sObjectNo == null ) sObjectNo = "";
	
	//获得页面参数		
	String sSerialNo = CurPage.getParameter("SerialNo");
	if(sSerialNo == null ) sSerialNo = "";

	String certType = "";
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "SameApplyInfo";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	certType = Sqlca.getString( "Select CertType From CUSTOMER_INFO where CustomerID = " + "( Select CustomerID from BUSINESS_APPLY where SerialNo = '" + sObjectNo + "' )" );
	if( certType == null ){
		certType = "";
	}else{
		certType = certType.substring( 0, 3 );
	}

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			//检查要添加的共同申请人是否已经存在及是否与业务申请人相同
			sReturn = checkSameApplyID();
			if(sReturn!="SUCCESS"){
				alert(sReturn);
				return;
			}	
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}	
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		OpenPage("/CreditManage/CreditApply/SameApplyList.jsp","_self","");
	}
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();
		setItemValue(0,0,"ObjectType","<%=sObjectType%>");
		setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "BUSINESS_APPLICANT";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
		
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer(){
		sParaString = "CertType,"+"<%=certType%>";
		setObjectValue("SelectOwner",sParaString,"@ApplicantID@0@ApplicantName@1",0,0,"");
	}
	
	/*~[Describe=检查共同申请人是否已经存在及是否与业务申请人相同;InputParam=无;OutPutParam=无;]~*/
	function checkSameApplyID(){
		//判断申请人和共同申请人是否为同一个人以及共同申请人是否已经登记过		
		sApplicantID = getItemValue(0,getRow(),"ApplicantID");
		sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CheckSameApplicant","run","ObjectType="+"<%=sObjectType%>"+",ObjectNo="+"<%=sObjectNo%>"+",ApplicantID="+sApplicantID);
		return sReturn;
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>