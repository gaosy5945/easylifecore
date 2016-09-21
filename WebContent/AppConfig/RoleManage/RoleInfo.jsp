<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		页面说明：    
	 */
	String PG_TITLE = "角色详情";
	
	//获得页面参数
	String sRoleID = CurPage.getParameter("RoleID");
	if(sRoleID==null) sRoleID="";
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "RoleInfo";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sRoleID);
	
	String sButtons[][] = {
		{(CurUser.hasRole("099")?"true":"false"),"","Button","保存","保存修改","saveRecord()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	function saveRecord(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if(sRoleID!="<%=sRoleID%>"){
			/* sReturn=RunMethod("PublicMethod","GetColValue","RoleID,ROLE_INFO,String@RoleID@"+sRoleID); */
			sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.GetColValue","getColValue","colName=RoleID,tableName=awe_Role_info,whereClause=String@RoleID@"+sRoleID);
			if(typeof(sReturn) != "undefined" && sReturn != ""){
				alert("所输入的角色号已被使用！");
				return;
			}
		}
       setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0","doReturn('Y');");
	}
    
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"RoleID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>