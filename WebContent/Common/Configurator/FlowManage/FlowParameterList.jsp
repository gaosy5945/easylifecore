<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ����ģ�Ͳ����б�
		Input Param:
             FlowNo�����̱��     
             PhaseNo���׶α��
             FlowVersion�����̰汾     
	 */
	String PG_TITLE = "����ģ�Ͳ����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
    //���ҳ�����	
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sFlowVersion = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowVersion"));
	if (sFlowNo == null) sFlowNo = "";
	if (sPhaseNo == null) sPhaseNo = "";
	if (sFlowVersion == null) sFlowVersion = "";
	
	String sTempletNo = "FlowParameterList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
    
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo+","+sFlowVersion+","+sPhaseNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()","","","",""},
		{"true","","Button","����","����","save()","","","",""},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","",""},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		as_add("myiframe0");
		setItemValue(0,getRow(),"FlowNo","<%=sFlowNo%>");
		setItemValue(0,getRow(),"PhaseNo","<%=sPhaseNo%>");
		setItemValue(0,getRow(),"FlowVersion","<%=sFlowVersion%>");
	}
	
	function save(){
		as_save("myiframe0","");
	}

	function deleteRecord(){
		var sPhaseNo = getItemValue(0,getRow(),"FlowNo");
		if(typeof(sPhaseNo)=="undefined" || sPhaseNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>