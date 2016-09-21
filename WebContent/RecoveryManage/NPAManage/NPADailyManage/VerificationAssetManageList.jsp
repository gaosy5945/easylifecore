<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sBDType = CurPage.getParameter("Status");// 010-有追索权核销资产,020-无追索权核销资产,030-已清偿核销资产
	if(sBDType == null) sBDType = "";
	String sWhereClause = ""; //Where条件
	
	ASObjectModel doTemp = new ASObjectModel("VerificationAssetList");
	
	
	if("010".equals(sBDType)){
		sWhereClause = " and O.BUSINESSSTATUS = 'L52' and O.WRITEOFFPRINCIPALAMOUNT <> (select v.nvl(v.sum(LB.APPLYPRINCIPAL),'0.00')  from jbo.preservation.LAWCASE_BOOK LB where LB.BOOKTYPE='210' AND LB.LAWCASESERIALNO=O.serialno) ";	
	} else if("020".equals(sBDType)){
		sWhereClause = " and O.BUSINESSSTATUS = 'L51' and O.WRITEOFFPRINCIPALAMOUNT <> (select v.nvl(v.sum(LB.APPLYPRINCIPAL),'0.00')  from jbo.preservation.LAWCASE_BOOK LB where LB.BOOKTYPE='210' AND LB.LAWCASESERIALNO=O.serialno) ";	
		//sRitghtType = "&RightType=ReadOnly";
	} else	{
		sWhereClause = " and O.BUSINESSSTATUS in ('L51','L52') and O.WRITEOFFPRINCIPALAMOUNT = (select v.nvl(v.sum(LB.APPLYPRINCIPAL),'0.00')  from jbo.preservation.LAWCASE_BOOK LB where LB.BOOKTYPE='210' AND LB.LAWCASESERIALNO=O.serialno) ";
	}
	doTemp.setJboWhere(doTemp.getJboWhere() + sWhereClause);	
	
	String role = "PLBS0020";String role1 = "PLBS0052";
	if(CurUser.hasRole(role)&&!CurUser.hasRole(role1)){
		doTemp.appendJboWhere(" and ACCT_TRANSACTION.InputUserID='"+CurUser.getUserID()+"' ");
	}
	
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("OrgId", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、快捷键	7、	8、	9、图标，CSS层叠样式 10、风格
			{String.valueOf(!sBDType.equals("030")),"All","Button","新增核销","选择合同核销","verification()","","","",""},//
			{"true","","Button","核销详情","选择合同核销","viewfication()","","","",""},//
			{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()","","","",""},
			{"true","","Button","债权变动记录","查看回收记录","my_Record()","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		var sContractNo = getItemValue(0,getRow(),"CONTRACTSERIALNO");  //合同流水号或对象编号
		if (typeof(sContractNo) == "undefined" || sContractNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		AsCredit.openFunction("ContractInfo","ObjectType=jbo.app.BUSINESS_CONTRACT&ObjectNo="+sContractNo+"&RightType=ReadOnly");
		reloadSelf();
	}
	
	
	//回收记录
	function my_Record()
	{
		var sUrl = "/RecoveryManage/NPAManage/NPADailyManage/PDARecoverRecordList.jsp";
	    var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
	    var sContractArtificialNo = getItemValue(0,getRow(),"CONTRACTARTIFICIALNO");
	    //sFinishDate = getItemValue(0,getRow(),"FinishDate");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		} else {   
			var sBDType = "<%=sBDType%>";
			if (sBDType=="030") {
				AsControl.PopComp(sUrl, "BDSerialNo="+sSerialNo+"&ContractArtificialNo="+sContractArtificialNo+"&BDType="+sBDType, "", "");
			} else {
				AsControl.PopComp(sUrl, "BDSerialNo="+sSerialNo+"&ContractArtificialNo="+sContractArtificialNo, "", "");
			}
		}
		reloadSelf();
	}
	
	function verification(){
		var sBDSerialNo = "";
		var sBusinessStatus = "";
		//VerificationSelectList
		var sStyle = "dialogWidth:800px;dialogHeight:680px;resizable:yes;scrollbars:no;status:no;help:no";
	    var returnValue = AsDialog.SelectGridValue("VerificationSelectList","<%=CurUser.getOrgID()%>","SERIALNO",'','',sStyle,'','1');
	    if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
	    else sBDSerialNo = returnValue;
	    var status = "<%=sBDType%>";
	    if(status=="010"){
	    	sBusinessStatus = "L52";	
		} else if(status=="020"){
			sBusinessStatus = "L51";
		}
		AsControl.PopComp("/RecoveryManage/NPAManage/NPADailyManage/VerificationAddInfo.jsp", "SerialNo="+sBDSerialNo+"&BusinessStatus="+sBusinessStatus, "", "");
		reloadSelf();
	}
	
	function viewfication(){
		var sBDSerialNo =  getItemValue(0,getRow(),"SERIALNO");
		if(typeof(sBDSerialNo)=="undefined" || sBDSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sBusinessStatus = getItemValue(0,getRow(0),"BUSINESSSTATUS");
		var inputUserID = getItemValue(0,getRow(),"InputUserID");
		var rightType = "<%=CurPage.getParameter("RightType")%>";
		if(inputUserID!="<%=CurUser.getUserID()%>"){
			rightType = "ReadOnly";
		}
		var status = "<%=sBDType%>";
		if (status=="030") {
			AsControl.PopComp("/RecoveryManage/NPAManage/NPADailyManage/VerificationAddInfo.jsp", "SerialNo="+sBDSerialNo+"&BusinessStatus="+sBusinessStatus+"&RightType=ReadOnly", "", "");
		} else {
			AsControl.PopComp("/RecoveryManage/NPAManage/NPADailyManage/VerificationAddInfo.jsp", "SerialNo="+sBDSerialNo+"&BusinessStatus="+sBusinessStatus+"&RightType="+rightType, "", "");
		}
		reloadSelf();
	}
	
	$(document).ready(function(){
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
