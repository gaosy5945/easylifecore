<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_Info.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/ow/as_map.js"></script>
<%
	String PG_TITLE = "ҵ�����������¼"; // ��������ڱ��� <title> PG_TITLE </title>
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	
	//����ֵת���ɿ��ַ���
	if(objectType == null) objectType = "";
	if(objectNo == null) objectNo = "";	
	if(taskSerialNo == null) taskSerialNo = "";	

	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("FlowCheckList", SystemHelper.getPageComponentParameters(CurPage), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setParameter("ObjectType",objectType);
	dwTemp.setParameter("ObjectNo", objectNo);
	//dwTemp.setParameter("TaskSerialNo", taskSerialNo);
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow(objectType+","+objectNo+","+CurUser.getUserID());
	
	String sButtons[][] = {
		{"true","All","Button","����","����","ALSObjectWindowFunctions.addRow(0,'','add()')","","","",""},
		{"true","","Button","����","����","save()","","","",""},	
		{"true","All","Button","ɾ��","ɾ��","del()","","","",""},
		{"true","ReadOnly","Button","����","����","edit()","","","",""},	
	};
	
%><%@include file="/Frame/resources/include/ui/include_list.jspf" %>
<script type="text/javascript">
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function add(){
		//as_add(0);
		var serialNo = getSerialNo("FLOW_CHECKLIST","SERIALNO");
		setItemValue(0,getRow(0),"SerialNo",serialNo);
		setItemValue(0,getRow(0),"TaskSerialNo","<%=taskSerialNo%>");
		setItemValue(0,getRow(0),"ObjectType","<%=objectType%>");
		setItemValue(0,getRow(0),"ObjectNo","<%=objectNo%>");
		setItemValue(0,getRow(0),"Status","01");
		setItemValue(0,getRow(0),"CheckItem","0010");
		setItemValue(0,getRow(0),"InputOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(0),"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(0),"InputTime","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
	}
	function edit(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		var returnValue = AsControl.PopPage("/Common/WorkFlow/FlowCheckInfo.jsp", "SerialNo="+serialNo+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>", "dialogWidth:500px;dialogHeight:280px;resizable:yes;scrollbars:no;status:no;help:no");
		
		/*if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != null)
		{
			setItemValue(0,getRow(0),"CheckItemName",returnValue);
		}*/
		window.checkOpenUrlModified = false;
		AsControl.OpenComp("/Common/WorkFlow/FlowCheckList.jsp","TaskSerialNo=<%=taskSerialNo%>&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>","_self","");
	}
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function save(){
		 for(var i = 0 ; i < getRowCount(0) ; i ++){	
			//setItemValue(0,i,"UpdateTime","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
			setItemValue(0,i,"CheckItem","0010");
			var checkItemName =getItemValue(0, i, "CheckItemName");
			/* var userID = "<%=CurUser.getUserID()%>";
			var inputUserID = getItemValue(0,i,"InputUserID");
			if(userID!=inputUserID){//���ַǵ�ǰ�û�¼��������������� add by ����ǿ  2015/03/18
				var OldSerialNo = getItemValue(0,i,"SerialNo");
			    if(checkItemName!=map.get(OldSerialNo)) setItemValue(0,i,"CheckItemName",map.get(OldSerialNo));
			}  */
			if(checkItemName != null && checkItemName != ""){
				if (checkItemName.indexOf("\\")>-1){
					alert("¼����Ϣ����'\\'�����飡");
					return;
				}
			}
		} 
		as_save("reloadSelf()");
	}
	function reloadSelf(){
		AsControl.OpenComp("/Common/WorkFlow/FlowCheckList.jsp","TaskSerialNo=<%=taskSerialNo%>&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>","_self","");
	}
	
	/*~[Describe=ɾ��;InputParam=�����¼�;OutPutParam=��;]~*/
	function del(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		var userID = "<%=CurUser.getUserID()%>";
		var inputUserID = getItemValue(0,getRow(),"InputUserID");
		if(userID == inputUserID){
			if(confirm('ȷʵҪɾ����?')){
				ALSObjectWindowFunctions.deleteSelectRow(0);
			}
		}else{
			alert("��û��Ȩ��ɾ�������⣡");
		}
	}
	
	//��ȡ�ǵ�ǰ�û�¼�����������������map��   add by ����ǿ  2015/03/18
	//var map = new Map();
	$(function(){
		for(var i = 0 ; i < getRowCount(0) ; i ++){	
			var userID = "<%=CurUser.getUserID()%>";
			var inputUserID = getItemValue(0,i,"InputUserID");
			if(userID!=inputUserID){//���ǵ�ǰ�û������������ֶ���Ϊ���ɱ༭
				ALSObjectWindowFunctions.setItemDisabled(0,i,"CheckItemName",true);
			}
		}
	})

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>