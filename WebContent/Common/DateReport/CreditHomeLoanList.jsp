<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%
	//接收参数
	String tempNo = DataConvert.toString(CurPage.getParameter("TempNo"));//模板号
	ASObjectModel doTemp = new ASObjectModel(tempNo);
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setParameter("orgid", CurUser.getOrgID());
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","详情","详情","view()","","","","",""},
			{"true","","Button","导出","导出Excel","exportRecord()","","","",""},
		};
%> 

<script type="text/javascript">

function exportRecord(){
	if(confirm("是否导出房贷客户安居贷信息！")){
		rootpath='<%=sWebRootPath%>';
		dwname=0;
		fileType='excel';
		argValues="";
		params="";
		if(!isNaN(dwname))dwname = "myiframe" + dwname;
		var tableIndex = dwname.substring(8);
		var rand = Math.random();
		if(params==undefined)
			params = "rand=" + rand;
		else
			params = "&rand=" + rand;
		var url = rootpath + "/EAS/PageExport/HLlist?" + params;
		var form = document.getElementById("@SUBMIT");
		if(TableFactory.ExportArgValues==undefined )
			TableFactory.ExportArgValues =argValues;
		if(TableFactory.ExportDataObject==undefined)
			TableFactory.ExportDataObject= DZ[tableIndex][0][8];
		if(form==undefined){
			var tableSubmit = document.getElementById("TABLE_SUBMIT_" + tableIndex);
			form = document.createElement("form");
			form.setAttribute("name", "@SUBMIT");
			form.setAttribute("id", "@SUBMIT");
			//form.setAttribute("action", url);
			form.setAttribute("method", "post");
			document.body.appendChild(form);
			
			var sb = new StringBuffer();
			sb.append('<input type="hidden" name="SERIALIZED_ASD" value="">');
			sb.append('<input type="hidden" name="ArgValues" value="">');
			sb.append('<input type="hidden" name="FileType" value="">');
			sb.append('<input type="hidden" name="ConvertCode" value="">');
			form.innerHTML = sb.toString();
		}
		form.elements["SERIALIZED_ASD"].value = TableFactory.ExportDataObject;
		form.elements["ArgValues"].value = TableFactory.ExportArgValues;
		form.elements["FileType"].value = fileType;	
		form.setAttribute("action", url);
		if(bDWConvertCode)
			form.elements["ConvertCode"].value = "1";
		else
			form.elements["ConvertCode"].value = "";
		openDWDialog();
		form.submit();
		resetDWDialogForAjax(undefined,sDWResourcePath+"/CheckExportPage.jsp?rand="+rand);			
	}
}

function view(){
	 var serialNo = getItemValue(0,getRow(0),'DuebillNO');
	 if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
	 }
	 var ApplySerialNo = getItemValue(0,getRow(0),'ApplySerialNo');
	 AsCredit.openFunction("LoanCheckInfoTab","SerialNo="+serialNo+"&ApplySerialNo="+ApplySerialNo,"");
}

</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@include file="/Frame/resources/include/include_end.jspf"%>
