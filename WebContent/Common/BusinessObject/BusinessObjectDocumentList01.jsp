<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.als.ui.function.FunctionWebTools"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	String rightType = CurPage.getParameter("RightType");//Ȩ��
	String flag = CurPage.getParameter("Flag");
	String buttonFlag = CurPage.getParameter("ButtoFlag");
	boolean orgFlag = "9900".equals(CurUser.getOrgID());
	
	String templeteNo =  CurPage.getParameter("ListTempleteNo");//ģ��
	if(StringX.isEmpty(templeteNo)) templeteNo = "DocBusinessObjectDocumentList01";
	BusinessObject inputParameter = SystemHelper.getPageComponentParameters(CurPage);//BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("orgid", CurUser.getOrgID()); 
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(templeteNo, inputParameter, CurPage, request);
	ASDataObject doTemp = dwTemp.getDataObject();
	if("0".equals(flag)){
		doTemp.appendJboWhere(" and O.SortNo is null");
	}else if("0".equals(buttonFlag)){
		doTemp.appendJboWhere(" and O.SortNo = '0'");
	}else{
		doTemp.appendJboWhere(" and (O.SortNo = '1' or O.SortNo = '2')");
	}
	
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{("0".equals(flag) && !orgFlag)?"true":"false","","Button","����","����","newRecord()","","","","",""},
			{(!"0".equals(buttonFlag))?"true":"false","","Button","����","����","viewFiles()","","","","",""},
			{("0".equals(flag) && !orgFlag)?"true":"false","","Button","ɾ��","ɾ��","deleteRecord()","","","","",""},
			{"0".equals(flag)?"true":"false","","Button","��������","��������","DocumentDownLoad()","","","","",""},
			{"0".equals(buttonFlag)?"true":"false","","Button","����","����","deal()","","","","",""},
	};
	if(!StringX.isEmpty(rightType)&&rightType.equals("ReadOnly")){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
	}
%> 

<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/Common/BusinessObject/BusinessObjectDocumentInfo01.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","_blank","");
		reloadSelf();
	}

	function deleteRecord(){
		var docNo = getItemValue(0,getRow(),"DocNo");
		var userID = "<%=CurUser.getUserID()%>";
		if (typeof(docNo)=="undefined" || docNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}

		if(confirm(getHtmlMessage(2))){ //�������ɾ������Ϣ��
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.risk.RiskReportUpload", "getReportStatus", "UserID="+userID+",DocNo="+docNo);
			if(result == "true"){
				as_delete('myiframe0');
			}else{
				alert("������ɾ���Ǳ����ϴ��ı����״̬Ϊ����ɵı��棡");
			}
		}
	}
	
	<%/*~[Describe=�鿴���޸ĸ�������;]~*/%>
	function viewFiles(){
		var rightType = "";
		var docNo = getItemValue(0,getRow(),"DocNo");
		var sortNo = getItemValue(0,getRow(),"SortNo");
		if(typeof(sortNo) == "undefined" || sortNo.length == 0 || sortNo == "Null") sortNo="";
		if (typeof(docNo)=="undefined" || docNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		if(sortNo == "1"||sortNo == "2"){
			rightType = "ReadOnly";
		}else{
			rightType = "<%=rightType%>";
		}
		AsControl.OpenView("/Common/BusinessObject/BusinessObjectDocumentInfo01.jsp", "ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&DocNo="+docNo+"&RightType="+rightType, "_blank");
	}
	
	function deal(){
		var docNo = getItemValue(0,getRow(),"DocNo");
		AsCredit.openFunction("RiskWarningReport01","DocNo="+docNo+"&RightType=<%=rightType%>&Flag=<%=flag%>&ButtonFlag=<%=buttonFlag%>","");
	}
	
	<%/*~[Describe=��������;]~*/%>
	function DocumentDownLoad(){
		
		var docNo = getItemValue(0,getRow(),"DOCNO");
		if (typeof(docNo)=="undefined" || docNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		AsControl.OpenPage("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+docNo+"&RightType=ReadOnly", "frame_list_attechment");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>