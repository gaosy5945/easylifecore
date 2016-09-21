<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ����ģ���б�
		Input Param:
             sFlowNo�����̱��     
	 */
	String PG_TITLE = "����ģ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
    //���ҳ�����	
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sFlowVersion = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowVersion"));
	if (sFlowNo == null) sFlowNo = "";
	if (sPhaseNo == null) sPhaseNo = "";
	if (sFlowVersion == null) sFlowVersion = "";
	
	String sTempletNo = "FlowModelList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);
    
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo+","+sFlowVersion);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()","","","",""},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()","","","",""},
		{"true","","Button","�����б�","�鿴/�޸Ĳ����б�","viewAndEdit2()","","","",""},
		//{"true","","Button","����","����","save()","","","",""},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","",""},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("FlowModelInfo","/Common/Configurator/FlowManage/FlowModelInfo.jsp","FlowNo=<%=sFlowNo%>&FlowVersion=<%=sFlowVersion%>&PhaseNo=<%=sPhaseNo%>","");
        //�޸����ݺ�ˢ���б�
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/FlowManage/FlowModelList.jsp?FlowNo="+sReturnValues[0],"_self","");           
            }
        }
	}
	
	function viewAndEdit(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sFlowVersion = getItemValue(0,getRow(),"FlowVersion");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		sReturn=popComp("FlowModelInfo","/Common/Configurator/FlowManage/FlowModelInfo.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&FlowVersion="+sFlowVersion,"");
        //�޸����ݺ�ˢ���б�
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/FlowManage/FlowModelList.jsp?FlowNo="+sReturnValues[0],"_self","");           
            }
        }
	}
	
	/*~[Describe=�鿴/�޸����̲����б�;]~*/
	function viewAndEdit2(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sFlowVersion = getItemValue(0,getRow(),"FlowVersion");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
       popComp("�鿴/�޸����̲����б�","/Common/Configurator/FlowManage/FlowParameterList.jsp","FlowNo="+sFlowNo+"&FlowVersion="+sFlowVersion+"&PhaseNo="+sPhaseNo,"");  
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
	
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"FlowNo");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>