<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<!-- ��ֿ��б� -->
<%	

	String sObjectType = "SmallScore";//��ֿ�
	String sObjectNo = CurPage.getParameter("ObjectNo");
 	String customerID = CurPage.getParameter("CustomerID");
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("SmallScoreList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sObjectType+","+sObjectNo);
	
	String sButtons[][] = {
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	/*~[Describe=������ֿ�;InputParam=��;OutPutParam=��;]~*/
	function add(){
		var iCount = getRowCount(0);
		if(iCount > 0){
			alert("�ñ�ҵ���Ѵ��ڴ�ֿ���Ϣ�������ظ���֣�");
			return;
		}
		var modelNo = "211";//����ģ��(Ĭ��A��)
		var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.alike.action.AlikeEvaluateAction","evaluateEnterCheck","customerID=<%=customerID%>");
		if(sReturn == "false"){
			alert("��ֿ�ֻ���������ʲ�С����ǧ����������С����ǧ��Ŀͻ���");
			return;
		}else if("A" == sReturn) modelNo = "211";
		 else if("B" == sReturn)modelNo = "212";
		
		sReturn = RunJavaMethodSqlca("com.amarsoft.app.als.customer.alike.action.AlikeEvaluateAction","createEvaluateSimple","modelNo="+modelNo+",objectType=<%=sObjectType%>,objectNo=<%=sObjectNo%>,userID=<%=CurUser.getUserID()%>,orgID=<%=CurUser.getOrgID()%>");
		if(typeof(sReturn) != "undefined" && sReturn.length>=0 && sReturn != "failed"){
			var sEditable="true";
			AsControl.PopComp("/Common/Evaluate/EvaluateDetail.jsp","CustomerID=<%=customerID%>&Action=display&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sReturn+"&Editable="+sEditable,"");
			reloadSelf();
		}
	}
	/*~[Describe=��ֿ�����;InputParam=��;OutPutParam=��;]~*/
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		AsControl.PopComp("/Common/Evaluate/EvaluateDetail.jsp","CustomerID=<%=customerID%>&Action=display&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+serialNo+"&Editable=true","");
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
