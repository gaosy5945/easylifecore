<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//����
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
		out.println("<font size='3' color='red'>������ͨ�������������β�ѯ��Ȼ�󵼳���Ӧ�����εĴ�����Ϣ��</font>");
	}

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����(���ܼ�F2)","exportRecord()","","","","btn_icon_add",""},
			{"true","","Button","ȡ��","ȡ��","cancle()","","","","btn_icon_detail",""},
		};
	//sButtonPosition = "south"; 
%>
<div>
<table>
	<tr>
		<td style="width: 4px;"></td>
		<td class="black9pt" align="right"><font>�������Σ�</font><fontcolor="#ff0000">&nbsp;&nbsp;</font></td>
		<td colspan="2">
		<input id="batchNo" type="text" name="batchNo" value="" style="width: 270px">
		<input id="PTISerialNo" type="button" name="PTISerialNo" value="��ѯ" style="width: 50px" onClick="javascript:setPTISerialNo()" >
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
		if(confirm("�Ƿ񵼳���ǰ���ε�ǰ������Ϣ��")){
			exportPage('<%=sWebRootPath%>',0,'excel','<%=dwTemp.getArgsValue()%>'); 
			 //export2Excel("myiframe0");
			 //amarExport("myiframe0");
		}
	}
	function cancle(){
		//�����ϸ�����
		history.back(-1);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
