<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.dict.als.object.Item"%>
<%@page import="com.amarsoft.app.als.credit.common.model.CreditConst"%>
<%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String phaseNo=CurPage.getParameter("PhaseNo");
	if(phaseNo==null) phaseNo="0010";
	ASObjectModel doTemp = new ASObjectModel("QuickApplyList");
	doTemp.appendJboWhere(" and BusinessSource='"+CreditConst.BUSINESS_SOURCE_0101+"' "+
							"and (not exists  (select * from "+FlowConst.JBO_FLOWOBJECT+" FO1 where FO1.ObjectType='CreditApply' and FO1.ObjectNo=O.SerialNO)"+
									" or exists (select * from "+FlowConst.JBO_FLOWOBJECT+" FO2 where FO2.ObjectType='CreditApply' and FO2.PhaseNo='0003'  and FO2.ObjectNo=O.SerialNO))");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(CurUser.getUserID());
	
	String sButtons[][] = {
			{"true","","Button","新增","新增","add()","","","","",""},
			{"true","","Button","详情","详情","viewAndEdit()","","","","",""},
			{"true","","Button","删除","删除","delRecord()","","","","",""},
			{"true","","Button","提交","提交","doSubmit()","","","","",""},
		};
%> 

<%@page import="com.amarsoft.app.als.sys.tools.SystemConst"%>
<%@page import="com.amarsoft.app.als.workflow.model.FlowConst"%><script type="text/javascript">
	function add(){
		var sCompID = "QuickApplyInfo";
		var sCompURL = "/CreditManage/QuickApply/QuickApplyInfo.jsp";
		var sReturn = popComp(sCompID,sCompURL,"","dialogWidth=550px;dialogHeight=480px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();		
	}

	function viewAndEdit(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sParamString = "ObjectType=CreditApply&ObjectNo="+sObjectNo;
		AsControl.OpenObjectTab(sParamString);
		reloadSelf();		
	}

	function doSubmit(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		sReturn=AsCredit.doAction("0020","objectType=CreditApply");
		AsTask.doSubmit(sObjectNo,"CreditApply","<%=CurUser.getUserID()%>");
		reloadSelf();
	}
	 
	function delRecord(){
		if(!confirm('确实要删除吗?')) return;
		var returnValue = AsTask.delRecord("2014051400000007","CreditApply");
		if(returnValue == "SUCCESS"){
			alert("删除成功！");
		}else{
			alert("删除失败！");
		}
		reloadSelf();
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
