<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<!-- 打分卡列表 -->
<%	

	String sObjectType = "SmallScore";//打分卡
	String sObjectNo = CurPage.getParameter("ObjectNo");
 	String customerID = CurPage.getParameter("CustomerID");
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("SmallScoreList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sObjectType+","+sObjectNo);
	
	String sButtons[][] = {
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	/*~[Describe=新增打分卡;InputParam=无;OutPutParam=无;]~*/
	function add(){
		var iCount = getRowCount(0);
		if(iCount > 0){
			alert("该笔业务已存在打分卡信息，无需重复打分！");
			return;
		}
		var modelNo = "211";//评估模型(默认A卡)
		var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.alike.action.AlikeEvaluateAction","evaluateEnterCheck","customerID=<%=customerID%>");
		if(sReturn == "false"){
			alert("打分卡只适用于总资产小于三千万且年销售小于五千万的客户！");
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
	/*~[Describe=打分卡详情;InputParam=无;OutPutParam=无;]~*/
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
