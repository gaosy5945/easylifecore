<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    ����ģ����Ϣ����
		Input Param:
                    FlowNo��    ���̱��
                    PhaseNo��   �׶α��
	 */
	String PG_TITLE = "����ģ����Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������	
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sFlowVersion =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowVersion"));
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sFlowVersion == null) sFlowVersion = "";

	String sTempletNo = "FlowModelInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo+","+sPhaseNo+","+sFlowVersion);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndReturn()","","","",""},
	//	{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()","","","",""}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	function saveRecordAndReturn(){
		as_save("myiframe0","doReturn('Y');");
	}
    
	function saveRecordAndAdd(){	
       as_save("myiframe0","newRecord()");
	}

    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"FlowNo");
       parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
		reloadSelf();
	}
    
	function newRecord(){
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sFlowVersion = getItemValue(0,getRow(),"FlowVersion");
		OpenComp("FlowModelInfo","/Common/Configurator/FlowManage/FlowModelInfo.jsp","FlowNo="+sFlowNo+"&FlowVersion="+sFlowVersion,"_self","");

	}
	
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputDate","<%=com.amarsoft.app.base.util.DateHelper.getToday()%>");
			if ("<%=sFlowNo%>" !=""){
				setItemValue(0,0,"FlowNo","<%=sFlowNo%>");
				setItemValue(0,0,"FlowVersion","<%=sFlowVersion%>");
			}
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>