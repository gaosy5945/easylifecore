<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%
	//���ղ���
	String tempNo = DataConvert.toString(CurPage.getParameter("TempNo"));//ģ���
	ASObjectModel doTemp = new ASObjectModel(tempNo);
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setParameter("orgid", CurUser.getOrgID());
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","view()","","","","",""},
			{"true","","Button","����","����Excel","exportRecord()","","","",""},
		};
%> 

<script type="text/javascript">

function exportRecord(){
	if(confirm("�Ƿ񵼳������ͻ����Ӵ���Ϣ��")){
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
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
	 }
	 var ApplySerialNo = getItemValue(0,getRow(0),'ApplySerialNo');
	 AsCredit.openFunction("LoanCheckInfoTab","SerialNo="+serialNo+"&ApplySerialNo="+ApplySerialNo,"");
}

</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@include file="/Frame/resources/include/include_end.jspf"%>
