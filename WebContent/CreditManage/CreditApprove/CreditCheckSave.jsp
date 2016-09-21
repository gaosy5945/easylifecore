<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.config.impl.*"%>
<%@page import="com.amarsoft.app.base.businessobject.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   jywen 2016-1-7 10:42
		Tester:
		Content: 信息核查保存数据
		Input Param:
		Output param:			
		History Log: 
	 */
	%>
<%/*~END~*/%>
<html>
<head> 
<title>信息核查数据保存页面</title>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量 
	String sSql = "";
	String sReturn = "";
	String validateFlag = "true";
	ASResultSet rs = null;
	//获得页面参数
	String phaseNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String flowSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowSerialNo"));
	String flowNo = Sqlca.getString(new SqlObject("select FlowNo from flow_instance where serialno = :SerialNo").setParameter("SerialNo", flowSerialNo));
	String taskSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TaskSerialNo"));
	String objectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String objectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String checkListName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CheckListName"));
	String checkTypes = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CheckTypes"));
	
	try
	{
		BusinessObject checkList = CreditCheckConfig.getCheckList(flowNo, phaseNo,checkListName);
		List<BusinessObject> checkGroupList = CreditCheckConfig.getCheckGroups(checkList);
		if(checkGroupList == null || checkGroupList.size()==0 || phaseNo.equals("") || flowNo.equals("")){
			out.println("该任务阶段未配置信息核查清单数据！");
			return;
		}
		//保存数据
		for (BusinessObject checkGroup:checkGroupList) {
			//若为电话核查，则需要根据当前页面选中的核查组进行数据保存
			if("TelCheck".equals(checkListName) && !checkTypes.contains(checkGroup.getString("ID"))) continue;
			List<BusinessObject> checkItemList = CreditCheckConfig.getCheckItems(checkGroup.getString("ID"));
			//清除已经存在该核查组的数据 
			String sSqlDel = "Delete from Flow_checkList where ObjectNo=:ObjectNo and ObjectType = :ObjectType and CheckItemNo = :CheckGroup";
			Sqlca.executeSQL(new SqlObject(sSqlDel).setParameter("ObjectNo",objectNo).setParameter("ObjectType",objectType).setParameter("CheckGroup",checkGroup.getString("ID")));
			for (BusinessObject checkItem:checkItemList) {
				String opinionGropuItem = "Opinion_"+checkGroup.getString("ID")+"_"+checkItem.getString("ID");
				String remarkGroupItem =  "Remark_"+checkGroup.getString("ID")+"_"+checkItem.getString("ID");
				String opinionGropuItemValue = request.getParameter(opinionGropuItem);
				String remarkGropuItemValue = request.getParameter(remarkGroupItem);
				String sSqlInsert = "insert into Flow_checkList(SERIALNO,TASKSERIALNO,OBJECTTYPE,OBJECTNO,CHECKITEM,CHECKITEMNAME,REMARK,STATUS,INPUTORGID,INPUTUSERID,INPUTTIME,UPDATETIME,CHECKITEMNO) values(:SERIALNO,:TASKSERIALNO,:OBJECTTYPE,:OBJECTNO,:CHECKITEM,:CHECKITEMNAME,:REMARK,:STATUS,:INPUTORGID,:INPUTUSERID,:INPUTTIME,:UPDATETIME,:CHECKITEMNO)";
				Sqlca.executeSQL(new SqlObject(sSqlInsert).setParameter("TASKSERIALNO", taskSerialNo).setParameter("OBJECTTYPE", objectType)
						.setParameter("OBJECTNO", objectNo).setParameter("CHECKITEM", checkItem.getString("ID")).setParameter("CHECKITEMNAME", checkItem.getString("label"))
						.setParameter("REMARK", remarkGropuItemValue)
						.setParameter("INPUTORGID", CurUser.getOrgID()).setParameter("INPUTUSERID", CurUser.getUserID()).setParameter("INPUTTIME",DateX.format(new java.util.Date(),"yyyy/MM/dd") )
						.setParameter("STATUS", opinionGropuItemValue).setParameter("UPDATETIME", DateX.format(new java.util.Date(),"yyyy/MM/dd"))
						.setParameter("CHECKITEMNO", checkGroup.getString("ID")).setParameter("SERIALNO", DBKeyHelp.getSerialNo("FLOW_CHECKLIST","SerialNo")));
			}
		}
		%>
		<script language=javascript>
			alert("保存成功！");
			parent.saveInfo();
		</script>
		<%
	}
	catch(Exception ex)
	{
		ex.printStackTrace();
		Sqlca.rollback();
		%>
		<script language=javascript>
			alert("数据保存失败！");
		</script>
		<%
	}
%>
<%/*~END~*/%>

</head>
<body bgcolor="#DCDCDC">
<%

%>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>
