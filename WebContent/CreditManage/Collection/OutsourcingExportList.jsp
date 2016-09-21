<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//参数
	String sBatchNoList = CurPage.getParameter("BatchNoList");
	if(StringX.isEmpty(sBatchNoList) || null == sBatchNoList || "null" == sBatchNoList) sBatchNoList = "";
	String sBDSerialNoList = CurPage.getParameter("BDSerialNoList");
	if(StringX.isEmpty(sBDSerialNoList) || null == sBDSerialNoList || "null" == sBDSerialNoList) sBDSerialNoList = "";
	String sWhereSql = "";
	
	ASObjectModel doTemp = new ASObjectModel("OutsourcingExportList");

	if(!StringX.isEmpty(sBatchNoList)){
		sBatchNoList = sBatchNoList.replace(",","','");
		sWhereSql += " and  TASKBATCHNO in('"+sBatchNoList+"') ";
	}
	if(!StringX.isEmpty(sBDSerialNoList)){
		sBDSerialNoList = sBDSerialNoList.replace(",","','");
		sWhereSql += "  and O.serialno in('"+sBDSerialNoList+"') ";
	}
	if(!StringX.isEmpty(sBatchNoList) || !StringX.isEmpty(sBDSerialNoList)){
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	}else{
		doTemp.setJboWhereWhenNoFilter(" and 1=2 ");
	}
	if(StringX.isEmpty(sBatchNoList) && StringX.isEmpty(sBDSerialNoList)){
		out.println("<font size='3' color='red'>您可以通过输入任务批次查询，然后导出相应的批次的催收信息！</font>");
	}

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","导出","导出(功能键F2)","exportRecord()","","","","btn_icon_add",""},
			{"true","","Button","取消","取消","cancle()","","","","btn_icon_detail",""},
		};
	//sButtonPosition = "south"; 
%>
<div>
<table>
	<tr>
		<td style="width: 4px;"></td>
		<td class="black9pt" align="right"><font>任务批次：</font><fontcolor="#ff0000">&nbsp;&nbsp;</font></td>
		<td colspan="2">
		<input id="batchNo" type="text" name="batchNo" value="" style="width: 270px">
		<input id="PTISerialNo" type="button" name="PTISerialNo" value="查询" style="width: 50px" onClick="javascript:setPTISerialNo()" >
		</td>
	</tr>
</table>
</div>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function setPTISerialNo(){
		var sPTISerialNo = document.getElementById("batchNo").value;
		if(sPTISerialNo=="" || sPTISerialNo == "undefine" || sPTISerialNo == null || sPTISerialNo=="null"){
		}else{
			var sExportUrl = "/CreditManage/Collection/OutsourcingExportList.jsp";
			//AsControl.PopComp(sExportUrl,'BatchNoList=' +sPTISerialNo,'_self');
			AsControl.OpenView(sExportUrl,"BatchNoList="+sPTISerialNo,"_self");

		}
	}
	
	function exportRecord(){
		if(confirm("是否导出当前批次当前催收信息！")){
			exportPage('<%=sWebRootPath%>',0,'excel','<%=dwTemp.getArgsValue()%>'); 
			 //export2Excel("myiframe0");
			 //amarExport("myiframe0");
		}
	}
	function cancle(){
		//返回上个界面
		history.back(-1);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
