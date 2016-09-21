<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	//获取前端传入的参数
    String sStatus = DataConvert.toString(CurPage.getParameter("Status"));//模板号
    
	//ASObjectModel doTemp = new ASObjectModel("CollSelectList1");    
    
   
    
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
/* 	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("CollSelectList1",inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject(); */
	
	
	BusinessObject inputParameter =BusinessObject.createBusinessObject();
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("CollSelectList1",inputParameter,CurPage);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	String sRoleInfo []={"PLBS0014"};
	String sWhereSql = "";
	String sHaveRoleFlag="";
	if(CurUser.hasRole(sRoleInfo)){
		sHaveRoleFlag="yes";
		sWhereSql=" and exists (select 1 from v.org_belong where v.belongorgid=BD.OperateOrgID and v.OrgID='"+CurUser.getOrgID()+"') ";
	}else{
		sHaveRoleFlag="no";
		sWhereSql=" and BD.OperateUserID='"+CurUser.getUserID()+"' ";
	}
	String sUserRole[] = {"PLBS0001","PLBS0002"};//客户经理
	if("1".equals(sStatus)){
		sWhereSql+=" and BD.OverDueDays>=1 and BD.OverDueDays<=10 ";
	}else{
		sWhereSql=sWhereSql;
	}
	
	
	sWhereSql+=" and (v.nvl(BD.OVERDUEBALANCE,0)+v.nvl(BD.INTERESTBALANCE1,0)+v.nvl(BD.INTERESTBALANCE2,0)+v.nvl(BD.FINEBALANCE1,0)+v.nvl(BD.FINEBALANCE2,0))>0 ";
	    
    doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql); 
    //生成HTMLDataWindow
	
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	dwTemp.MultiSelect = true;
	dwTemp.genHTMLObjectWindow("");
 
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"1".equals(sStatus)?"false":"true","","Button","任务调整","任务调整","Assignments()","","","","",""},
			{"true","","Button","催收详情","催收详情","CollectionInfo()","","","","",""},
			{"1".equals(sStatus)?"true":"false","","Button","任务导出","任务导出","ExportTask()","","","","",""},
			{"1".equals(sStatus)?"true":"false","","Button","催收结果导入","催收结果导入","ImportTask()","","","","",""},
			//{"true","","Button","催收登记","催收登记","CollectionReport()","","","","",""}
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>


<script type="text/javascript">
function Assignments(){
	 //任务分配
	 var sUrl = "/CreditManage/Collection/RiskAssign.jsp";
	 //获取流水号
	 var sCTSerialNoList = "";//
	 var sHaveRoleFlag="<%=sHaveRoleFlag%>";
	 var arr = new Array();
	 arr = getCheckedRows(0);
	 var sBDOperateOrgID="";
	 if(arr.length < 1){
		 alert("请选择至少一条信息！");
		 return;
	 }else{
		 var sFlag = true;
		 for(var i=0;i<arr.length;i++){
			 var sCTSerialNo = getItemValue(0,arr[i],'SERIALNO');
			 var sOperateUserId = getItemValue(0,arr[i],'OPERATEUSERID');
			 if(i==0){
				 sBDOperateOrgID= getItemValue(0,arr[i],'BDOPERATEORGID');
			 }else{
				 if(sBDOperateOrgID!=getItemValue(0,arr[i],'BDOPERATEORGID')){
					 alert("请对同一经办机构下的任务进行分配");
					 return;
				 }
			 }
			 if("undefine"==sOperateUserId || "null"==sOperateUserId || null ==sOperateUserId || sOperateUserId.length==0 || sOperateUserId.length == ""){
				 sCTSerialNoList += sCTSerialNo + "@";
			 }else{
				 if(sHaveRoleFlag=="yes"){
					 sCTSerialNoList += sCTSerialNo + "@";
				 }else{
					 alert("该借据（借据号："+getItemValue(0,arr[i],'OBJECTNO')+")已经分配过了，请重新选择！");
					 sFlag = false;
					 return;	 
				 }
			 }
		 }   
		 if(sFlag){
			 AsControl.PopView(sUrl,"BDOPerateOrgID="+sBDOperateOrgID+"&CTSerialNoList=" +sCTSerialNoList,'dialogWidth:460px;dialogHeight:350px;resizable:yes;scrollbars:no;status:no;help:no');
			 reloadSelf();
		 }else{
			 alert("您的选择中有已分配的任务，请重新选择！");
			 return;
		 }
	 }

}

function CollectionInfo(){
	 //var sUrl = "/CreditManage/Collection/CollectionReport.jsp";
	// var varia=getItemValue(0,getRow(0),'SerialNo');
	 //AsControl.PopComp(sUrl,'','');
	var serialNo = getItemValue(0,getRow(0),'SerialNo');
 	var duebillSerialNo = getItemValue(0,getRow(0),'ObjectNo');
	var contractSerialNo = getItemValue(0,getRow(0),'ContractSerialNo');
 	var customerID = getItemValue(0, getRow(0), 'CUSTOMERID');
 	if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
		alert("参数不能为空！");
		return ;
 	}
 	var sRightType="ReadOnly";
 	var DoFlag="check";
	var returnValue = AsCredit.openFunction("CollTaskInfo","DoFlag="+DoFlag+"&ObjcetNo="+duebillSerialNo+"&SerialNo="+serialNo+"&CustomerID="+customerID+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo);
	if(returnValue == "true"){
		reloadSelf();
		edit();
	}else reloadSelf();

}
	
function ExportTask(){
	if(confirm("是否导出当前批次当前催收信息！")){
		exportPage('<%=sWebRootPath%>',0,'excel','<%=dwTemp.getArgsValue()%>'); 
	}
}
function ImportTask(){
	//总行集中电话催收结果导入
	var pageURL = "/CreditManage/Collection/CollExcelImport.jsp";
    var parameter = "clazz=jbo.import.excel.TEL_COLL_IMPORT&InputUserId=<%=CurUser.getUserID()%>";
    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
    reloadSelf();
}
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
