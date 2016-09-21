<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.config.impl.*"%>
<%@page import="com.amarsoft.app.base.businessobject.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jywen 2016-1-7 10:42
		Tester:
		Content: ��Ϣ�˲鱣������
		Input Param:
		Output param:			
		History Log: 
	 */
	%>
<%/*~END~*/%>
<html>
<head> 
<title>��Ϣ�˲����ݱ���ҳ��</title>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//������� 
	String sSql = "";
	String sReturn = "";
	String validateFlag = "true";
	ASResultSet rs = null;
	//���ҳ�����
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
			out.println("������׶�δ������Ϣ�˲��嵥���ݣ�");
			return;
		}
		//��������
		for (BusinessObject checkGroup:checkGroupList) {
			//��Ϊ�绰�˲飬����Ҫ���ݵ�ǰҳ��ѡ�еĺ˲���������ݱ���
			if("TelCheck".equals(checkListName) && !checkTypes.contains(checkGroup.getString("ID"))) continue;
			List<BusinessObject> checkItemList = CreditCheckConfig.getCheckItems(checkGroup.getString("ID"));
			//����Ѿ����ڸú˲�������� 
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
			alert("����ɹ���");
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
			alert("���ݱ���ʧ�ܣ�");
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
