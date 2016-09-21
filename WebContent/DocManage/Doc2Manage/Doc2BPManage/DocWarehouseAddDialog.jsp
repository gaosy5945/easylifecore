<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	/**
			 业务资料管理 上架 新增选择页面
		 */
%>

<%
	String sObjectNo = DataConvert.toRealString(iPostChange,(String) CurPage.getParameter("ObjectNo"));
	if(sObjectNo == null ) sObjectNo = "";
	String sObjectType = DataConvert.toRealString(iPostChange,(String) CurComp.getParameter("ObjectType"));
	if(sObjectType == null ) sObjectType = "";
	String sSerialNo = DataConvert.toRealString(iPostChange,(String) CurComp.getParameter("SerialNo"));
	if(sSerialNo == null ) sSerialNo = "";
	String sOperationType = DataConvert.toRealString(iPostChange,(String) CurComp.getParameter("OperationType"));
	if(sOperationType == null ) sOperationType = "";
	String sShelvesType = DataConvert.toRealString(iPostChange,(String) CurComp.getParameter("ShelvesType"));
	if(sShelvesType == null ) sShelvesType = "";
	String sKeepingType = DataConvert.toRealString(iPostChange,(String) CurComp.getParameter("KeepingType"));
	if(sKeepingType == null ) sKeepingType = "";
	
%>
<html>
<head>
<title>档案资料 专夹保管</title>

<style>
.black9pt {
	font-size: 9pt;
	color: #000000;
	text-decoration: none
}
</style>
</head>

<body bgcolor="#FFF0E8" align="center">
	<br>
	<table >
		<tr disabled="disabled">
			<td style="width: 4px;"></td>
			<td class="black9pt" align="right"><font>关联额度编号：</font><font color="#ff0000">&nbsp;&nbsp;</font></td>
			<td colspan="2">
				<input id="ObjectNo" type="text" name="ObjectNo" value="" style="width: 300px"> 
			</td>
		</tr>
		<tr>
			<td style="width: 4px;"></td>
			<td class="black9pt" align="right"><font>架位：</font><font color="#ff0000">&nbsp;*</font></td>
			<td colspan="2">
				<input id="Position" type="text" name="Position" value="" style="width: 300px">
			</td>
		</tr>
		<tr>
			<td style="width: 4px;"></td>
			<td class="black9pt" align="right"><font>备注：</font><font color="#ff0000">&nbsp;&nbsp;</font></td>
			<td colspan="2">
				<input id="Remark" type="text" name="Remark" value="" style="width: 300px">
			</td>
		</tr>
		<tr>
			<td height="25" colspan="4" align="center">
				<input type="button" name="next" value="确认" onClick="javascript:AddOperiation()" > 
				<input type="button" name="Cancel" value="取消" onClick="javascript:CancleRecord()" >
			</td>
		</tr>
	</table>
</body>
</html>
<script language=javascript>

	initRow();
	
	function initRow(){
		var sObjectNo = "<%=sObjectNo%>";
		document.getElementById("ObjectNo").value = sObjectNo;
	}
	
	//校验
	function checkOperiation(){
		var sPosition = trim(document.getElementById("Position").value);
		var sMsg = "";
		var sObjectNo = "";
		if (sPosition == "" || sPosition == null || sPosition.length == 0) {
			alert("请输入架位！");
			return false;
		}
		return true;
	}
	
	function AddOperiation() {
		var returnValue = "FALSE";
		if(checkOperiation()){
			var sOperationType="0010";//预归档时，操作为0010 status = 01-待预归档 0201-已预归档
			var sDOSerialNo="<%=sSerialNo%>";
			var sObjectType="<%=sObjectType%>";//关联类型：额度、贷款、合作项目
			var sObjectNo="<%=sObjectNo%>";//关联编号：额度编号、贷款编号、合作项目编号
			var sPosition = document.getElementById("Position").value;
			var sRemark = document.getElementById("Remark").value;
			var sUserId = "<%=CurUser.getUserID()%>";
			var sOrgId = "<%=CurUser.getOrgID()%>";
			var sDate = "<%=StringFunction.getToday()%>";
			var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&Position="+sPosition+"&KeepingType=<%=sKeepingType%>";
			//插入一条操作数据
			var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2specialKeepingAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");//
			if(typeof(sReturn)!="undefined" && sReturn=="true"){
				//更新Doc_operation //已处理 专夹保管
				if("" == "<%=sShelvesType%>"){
					var sReturnValue =  "";
					if("0201"=="<%=sKeepingType%>"){
						sReturnValue =  RunMethod("PublicMethod","UpdateDocOperationSql","0201,"+sRemark+","+sUserId+","+sDate+","+sDOSerialNo+"");
					}else{
						sReturnValue =  RunMethod("PublicMethod","UpdateDocOperationSql","02,"+sRemark+","+sUserId+","+sDate+","+sDOSerialNo+"");
					}
					if(sReturnValue >0){
						returnValue = "TRUE@" + sDOSerialNo + "@";
					}else {
						returnValue = "FALSE@" + sDOSerialNo + "@";
					}	
				}else{
					returnValue = "TRUE@" +  "@";
				}
			} else {
				returnValue = "FALSE@" + sDOSerialNo + "@";
			}
			//返回变量：
			self.returnValue = returnValue;
			self.close();
		}
	}
	
	function CancleRecord(){
		self.returnValue='_CANCEL_';
		self.close();
		//OpenPage("/DocManage/Doc2Manage/Doc2BPManage/Doc2BeforPigeonholeManageList.jsp", "_self");		
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>