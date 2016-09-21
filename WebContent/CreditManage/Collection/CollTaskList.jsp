<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//催收类型：1-总行电话催收，2-分行催收，3-外包催收
	String sCollType = CurPage.getParameter("CollType");
	if(sCollType=="null" || sCollType == null) sCollType = "";
	String sSerialNo = CurPage.getParameter("SerialNo");
	if(sSerialNo=="null" || sSerialNo == null) sSerialNo = "";
	String sOperateOrgId = CurPage.getParameter("OperateOrgId");
	if(sOperateOrgId=="null" || sOperateOrgId == null) sOperateOrgId = "";
	String sTempNo = "";
	String sWhereSql = "";
	if("3".equals(sCollType) || "3" == sCollType){
		sTempNo = "OutsourcingCollectionList";//外包催收任务列表模板
		sWhereSql = " and O.TASKBATCHNO='"+sSerialNo+"'  AND (O.Status <> '2' or O.status is null) ";
	}else{
		sTempNo = "ALCollTaskList";//分行、总行催收任务列表模板
		sWhereSql = " AND O.OBJECTTYPE='jbo.app.BUSINESS_DUEBILL' and  (O.Status <> '5' or O.status is null) AND O.OBJECTNO=BD.SERIALNO and BD.OperateOrgId = '"+sOperateOrgId+"'";// " and O.SERIALNO = '"+sSerialNo+"'   AND (O.Status <> '2' or O.status is null) ";
	}
	String sRoleInfo []={"PLBS0014"};
	String sHaveRoleFlag="";
	if(CurUser.hasRole(sRoleInfo)){
		sHaveRoleFlag="yes";
	}else{
		sHaveRoleFlag="no";
	}
	BusinessObject inputParameter =BusinessObject.createBusinessObject();
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel(sTempNo,inputParameter,CurPage);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	//ASObjectModel doTemp = new ASObjectModel("OutSourcCollMonitorList");
	//ASObjectModel doTemp = new ASObjectModel(sTempNo);
	doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql );
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","催收详情","催收详情","edit()","","","","btn_icon_detail",""},
			{"false","All","Button","任务调整","任务调整","collChangeAll()","","","","btn_icon_detail",""},
			{"false","All","Button","关闭任务","关闭任务","closeColl()","","","","btn_icon_delete",""},
			{"true","All","Button","数据导出","数据导出","dataOut()","","","","btn_icon_detail",""},
			{"false","All","Button","任务催办","任务催办","collDoAgain()","","","","btn_icon_detail",""},
			{"false","","Button","返回","返回","goBack()","","","","btn_icon_detail",""},
		};
	sButtons[0][5] = "edit"+sCollType+"()";
	//sButtons[1][5] = "collChange"+sCollType+"()";
%>
<div>
  <table align="center" id="s1" style="display:none">
	<tr>
		<td class="black9pt" align="left"><font size="2">请选择导出文件类型:</font>
		</td>
	</tr>
	<tr>
		<td>
		<input type="button" style="width: 80px" name="txt" value="导出txt"
			onclick="javascript:setChoose(1)">
		<input type="button" style="width: 80px" name="html" value="导出html"
			onclick="javascript:setChoose(2)">
		<input type="button" style="width: 80px" name="excel" value="导出excel"
			onclick="javascript:setChoose(3)">
		<input type="button" style="width: 80px" name="pdf" value="导出pdf"
			onclick="javascript:setChoose(4)">
		<!-- <input type="button" style="width: 80px" name="word" value="导出word" onclick="javascript:setChoose(5)"> -->
		</td>
	</tr>
</table>
 </div>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function setChoose(ChooseType) {
		var sReturn =  ChooseType;
		if(sReturn=="1"){
			//导出Txt","导出Txt","
			exportPage('<%=sWebRootPath%>',0,'txt','<%=dwTemp.getArgsValue()%>');	
		}else if(sReturn=="2"){
			//导出Html","导出Html","
			exportPage('<%=sWebRootPath%>',0,'html','<%=dwTemp.getArgsValue()%>');	
		}else if(sReturn=="3"){
			//导出Excel","导出Excel","
			exportPage('<%=sWebRootPath%>',0,'excel','<%=dwTemp.getArgsValue()%>');
		}else if(sReturn=="4"){
			//导出Pdf","导出pdf","
			exportPage('<%=sWebRootPath%>',0,'pdf','<%=dwTemp.getArgsValue()%>');	
		//}else if(sReturn=="5"){
			//导出word
		//	ExportToWord();
			//exportPage('<%=sWebRootPath%>',0,'word','<%=dwTemp.getArgsValue()%>');	
		}else{
			alert("还未选择导出类型，请选择……");
		}
	}
	function switchItem(tag){
		var s1 = document.getElementById('s1');
		if(tag==''){
		    s1.style.display = '';
		}else{
		    s1.style.display = 'none';
		}
	}
	
	function deleteRecord(){
		if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))');
	}
	function goBack(){
		self.close();
	}
	function edit3(){
		//外包催收详情
		var sResUrl = "/CreditManage/Collection/OutCollRegistrateInfo.jsp";
		var sPTISerialNo = "";
		var sCTSerialNo = "";
		sPTISerialNo=getItemValue(0,getRow(0),'TASKBATCHNO');
		sCTSerialNo=getItemValue(0,getRow(0),'SERIALNO');
			//判断流水号是否为空
		if (typeof(sPTISerialNo)=="undefined" || sPTISerialNo.length==0 || typeof(sCTSerialNo)=="undefined" || sCTSerialNo.length==0){
			alert('请选择一条记录');
			return;
		}
		AsControl.PopComp(sResUrl,'PTISerialNo=' +sPTISerialNo+'&CTSerialNo=' +sCTSerialNo+'&RightType=ReadOnly','');
	}
	function edit2(){
		edit1();
	}
	function edit1(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
	 	var duebillSerialNo = getItemValue(0,getRow(0),'ObjectNo');
		var contractSerialNo = getItemValue(0,getRow(0),'ContractSerialNo');
	 	var customerID = getItemValue(0, getRow(0), 'CustomerID');
	 	if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("参数不能为空！");
			return ;
	 	}
		var returnValue = AsCredit.openFunction("CollTaskInfo","ObjcetNo="+duebillSerialNo+"&SerialNo="+serialNo+"&CustomerID="+customerID+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo+"&DoFlag=check");
		reloadSelf();
	}
	
	function collChangeAll(){
		//任务分配
		var sUrl = "/CreditManage/Collection/RiskAssign.jsp";
		var sCTSerialNo = getItemValue(0,getRow(),'SERIALNO');
		var sOperateUserId = getItemValue(0,getRow(),'OPERATEUSERID');
		var sHaveRoleFlag="<%=sHaveRoleFlag%>";
		var sBDOperateOrgID="";
		//判断是否选择了催收信息
		if (typeof(sCTSerialNo)=="undefined" || sCTSerialNo.length==0){
			alert('请选择一笔催收信息！');
			return;
		}else{
			if("undefine"==sOperateUserId || "null"==sOperateUserId || null ==sOperateUserId || sOperateUserId.length==0 || sOperateUserId.length == ""){
				sCTSerialNoList = sCTSerialNo ;
				sBDOperateOrgID= getItemValue(0,getRow(),'BDOPERATEORGID');
			}else{
				 if(sHaveRoleFlag=="yes"){
					 sCTSerialNoList = sCTSerialNo;
					 sBDOperateOrgID= getItemValue(0,getRow(),'BDOPERATEORGID');
				 }else{
					 alert("该借据已经分配过了，请重新选择！");	
					 return;	 
				 }
			}
		    AsControl.PopComp(sUrl,"BDOPerateOrgID="+sBDOperateOrgID+"&CTSerialNoList=" +sCTSerialNoList,"");
		 }
	}
	function collChange1(){
		//总行电话催收
		var sCTSerialNoList = getItemValue(0,getRow(0),'SerialNo');
		//判断是否选择了催收信息
		if (typeof(sCTSerialNoList)=="undefined" || sCTSerialNoList.length==0){
		        alert('请选择一笔催收信息！');
		        return;
		}
		var operateuserid=SelectGridValue();//选择器返回的执行人员的userid
		//判断执行人员是否为空
	    if (typeof(operateuserid)=="undefined" || operateuserid.length==0){
	        alert('请选择一位执行人员！');
	        return;
		}
		//调用java方法 
	    var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.urge.CollSelectListAction", "CollChange", "OperateUserId="+operateuserid+",OperateOrgId=,CTSerialNoList="+sCTSerialNoList+",TaskName= "+",UserId=<%=CurUser.getUserID()%>"+",OrgId=<%=CurUser.getOrgID()%>");
		if(sReturn == "true"){
	    	 alert("任务调整成功。");
	    }else{
	    	 alert("任务调整失败，请重新进行任务调整。");
	    }
		reloadSelf();
	}
	function collChange2(){
		//分行催收
		collChange1();
	}
	function collChange3(){
		//外包催收
		var sPTISerialNoList = getItemValue(0,getRow(0),'TASKBATCHNO');
		//判断是否选择了批次信息
		if (typeof(sPTISerialNoList)=="undefined" || sPTISerialNoList.length==0){
		        alert('请选择一笔批次信息！');
		        return;
		}
		if(confirm("确定要更改当前批次的催收执行人吗？")){
			var operateuserid = Customer_Partner();   //选择器返回的合作方编号
		    if (typeof(operateuserid)=="undefined" || operateuserid.length==0){
		        alert('您当前选中需要调整的是外包催收信息，请选择一个外包合作商！');
		        return;
			}
			//调用java方法 
		    var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.urge.CollSelectListAction", "outCollChange", "OperateUserId="+operateuserid+",OperateOrgId=,PTISerialNoList="+sPTISerialNoList+",UserId=<%=CurUser.getUserID()%>"+",OrgId=<%=CurUser.getOrgID()%>");
			if(sReturn == "true"){
		    	alert('任务分配成功！');
		    }else{
		    	alert("任务分配失败，请重新进行任务分配！");
		    }
		}
		reloadSelf();
	}
	//选择执行人员
	function SelectGridValue(){
	    //模板为Excute_USER_INFO的选择器，返回USERID@USERNAME
		var sReturn = AsDialog.SelectGridValue("Excute_USER_INFO", "", "USERID@USERNAME", "", true);
		if(!sReturn) return;
		var sIds = "";//执行人员编号
		var sNames = "";//执行人员名称
		//获得并截取返回值
		if(sReturn != "_CLEAR_"){
			var aReturn = sReturn.split("~");
			for(var i = 0; i < aReturn.length; i++){
				var aIdName = aReturn[i].split("@");
				sIds += ","+aIdName[0];
				sNames += ","+aIdName[1];
			}
			if(sIds != "") sIds = sIds.substring(1);
			if(sNames != "") sNames = sNames.substring(1);
		}
		//在执行人员那个text显示返回的执行人员名称
		return sIds;
	}
	//选择外包合作方
	function Customer_Partner(){
		//模板为Excute_USER_INFO的选择器，返回CUSTOMERID@CUSTOMERNAME
		var sReturn = AsDialog.SelectGridValue("CHOISE_PARTNER", "", "CUSTOMERID@CUSTOMERNAME", "", true);
		if(!sReturn) return;
		var sPIds = "";	   
	    var sPNames = "";//合作方名称
		if(sReturn != "_CLEAR_"){
			var aReturn = sReturn.split("~");
			for(var i = 0; i < aReturn.length; i++){
				var aIdName = aReturn[i].split("@");
				sPIds += ","+aIdName[0];
				sPNames += ","+aIdName[1];
			}
			if(sPIds != "") sPIds = sPIds.substring(1);
			if(sPNames != "") sPNames = sPNames.substring(1);
		}
		//在合作方选择那个text显示返回的合作方名称
		return sPIds;
	}
	
	function collChange (){
		alert("催收类型不明确！");
	}
	
	function closeColl(){
		//外包催收
		var sSerialNoList = getItemValue(0,getRow(0),'SERIALNO');
		//判断是否选择了批次信息
		if (typeof(sSerialNoList)=="undefined" || sSerialNoList.length==0){
		        alert('请选择一笔催收信息！');
		        return;
		}

		var sMessage = "";
	 	var sBusinessSum = getItemValue(0,getRow(0),'OVERDUEBALANCE');
	 	if(parseFloat(sBusinessSum)>0){
	 		sMessage = "该催收账户下存在未执行完毕的任务或还款承诺，确定要关闭该账户停止催收执行吗？";
	 	}
		if((""==sMessage)? true:confirm(sMessage)){
			//调用java方法 
		    var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.urge.CollSelectListAction", "closeColl", "OperateUserId= ,OperateOrgId=,SerialNoList="+sSerialNoList+",CloseType=<%=sCollType%>,UserId=<%=CurUser.getUserID()%>"+",OrgId=<%=CurUser.getOrgID()%>");
			if(sReturn == "true"){
		    	alert('任务关闭成功！');
		    }else{
		    	alert("任务关闭失败，请重新进行任务关闭！");
		    }
		}
		reloadSelf();
		
	}
	
	function dataOut(){
		<%-- var s1 = document.getElementById('s1');
		s1.style.display = ''; --%>
		if(confirm("是否导出当前批次当前催收信息！")){
			//var sReturn = AsControl.PopComp("/CreditManage/Collection/DataExportTypeChoose.jsp","","resizable=yes;dialogWidth=500px;dialogHeight=150px;center:yes;status:no;statusbar:no");
			exportPage('<%=sWebRootPath%>',0,'excel','<%=dwTemp.getArgsValue()%>');
		}
	}

	function ExportToWord(){   
		var oApplication=new ActiveXObject("Word.Application");
		oApplication.Visible=true;   // 如果不想看到Word界面就把这句去掉
		var oDoc = oApplication.Documents.Open("<%=sWebRootPath%>");
			oDoc.SaveAs('<%=sWebRootPath%>', 16);
			oApplication.Quit(false); 
		}
	function collDoAgain(){
		var sOperateUserId =  getItemValue(0,getRow(0),'OPERATEUSERID');
		if (typeof(sOperateUserId)=="undefined" || sOperateUserId.length==0){
	        alert('请选择一笔催收信息！');
	        return;
		}
		var sBDSerialNo = getItemValue(0,getRow(0),'OBJECTNO');
		if (typeof(sBDSerialNo)=="undefined" || sBDSerialNo.length==0){
	        alert('请选择一笔催收信息！');
	        return;
		}
		var sCollType = "<%=sCollType%>";
		//调用java方法  com.amarsoft.app.urge.CollSendMail  collChange  com.amarsoft.app.urge.CollSendMail
	    var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.urge.CollSendMail", "collChange", "OperateUserId="+sOperateUserId+" ,OperateOrgId=,BDSerialNo="+sBDSerialNo+",CollType="+sCollType+",UserId=<%=CurUser.getUserID()%>,OrgId="+"<%=CurUser.getOrgID()%>");
		var sReturnValue = sReturn.split("@");
		sReturn = sReturnValue[0];
		if(sReturn == "true"){
	    	alert('任务催办已成功发送催办邮件！');
	    }else{
	    	alert("任务催办发送催办邮件失败！，请重新进行任务催办！");
	    }
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
