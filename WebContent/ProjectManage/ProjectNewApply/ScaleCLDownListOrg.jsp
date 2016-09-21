<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String parentSerialNo = CurPage.getParameter("parentSerialNo");
	if(parentSerialNo == null) parentSerialNo = "";
	String divideType = CurPage.getParameter("divideType");
	if(divideType == null) divideType = "";
	String prjSerialNo = CurPage.getParameter("PrjSerialNo");
	if(prjSerialNo == null) prjSerialNo = "";
	String businessAppAmt = CurPage.getParameter("businessAppAmt");
	if(businessAppAmt == null) businessAppAmt = "";
	String ParticipateOrg = CurPage.getParameter("ParticipateOrg");
	if(ParticipateOrg == null) ParticipateOrg = "";
	
	ASObjectModel doTemp = new ASObjectModel("ScaleCreditLineDownListOrg");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "2";	 //ֻ��ģʽ
	dwTemp.setParameter("PARENTSERIALNO", parentSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","saveRecord()","","","","btn_icon_save",""},
			{"true","All","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	var flag = true;
	function saveRecord(){
		if(!iV_all(0)){
			alert("������д������Ϣ��");
			return;
		}
		checkSum();
		var parentSerialNo = "<%=parentSerialNo%>";
		var businessAppAmt = "<%=businessAppAmt%>";
		var Rows = getRowCount(0);
		var DataGroup = '';
		var SerialNoGroup = '';
		var sum = 0.00;
		for(var i = 0;i < Rows;i++){
			var participateBusinessAppAmt = getItemValue(0,i,"BUSINESSAPPAMT");
			var serialNo = getItemValue(0,i,"SERIALNO");
			var replaceData = participateBusinessAppAmt.replace(/,/g, "");
			DataGroup += replaceData + "@";
			SerialNoGroup += serialNo + "@";
			var sum = parseFloat(sum)+parseFloat(replaceData);
		}
		var divideType = "20";
		var sReturn = ProjectManage.getBusinessAppAmt(parentSerialNo,divideType);
		if(sReturn == "CLParentEmpty"|| sReturn == "CLEmpty" || sReturn == "SameNotSave"){
			alert("���ȱ����ģ�����Ϣ���ٽ��ж���зֲ�����");
			return;
		}else{
			if(flag){
				if(sum != businessAppAmt){
					if(confirm('��ע�⣬��Ŀ�зֶ�Ȳ�����ʵ�ʶ���ܹ�ģ���Ƿ�����з�?'))
					var sReturn = ProjectManage.updateBusinessAppAmt(SerialNoGroup,DataGroup,parentSerialNo);
					if(sReturn == "SUCCEED"){
						alert("����зֳɹ���");
						reloadSelf();
					}
				}else{
					var sReturn = ProjectManage.updateBusinessAppAmt(SerialNoGroup,DataGroup,parentSerialNo);
					if(sReturn == "SUCCEED"){
						alert("����зֳɹ���");
						reloadSelf();
					}
				}
			}else{
				flag = true;
			}
		}
	}
	function checkSum(){
		var businessAppAmt = "<%=businessAppAmt%>";
		var Rows = getRowCount(0);
		for(var i = 0;i < Rows;i++){
			var participateBusinessAppAmt = getItemValue(0,i,"BUSINESSAPPAMT");
			var orgName = getItemValue(0,i,"ORGNAME");
			var replaceData = participateBusinessAppAmt.replace(/,/g, "");
			if(parseFloat(replaceData) > parseFloat(businessAppAmt)){
				alert("��"+orgName+"��"+"���зֶ�ȴ��ڶ���ܽ����������룡");
				flag = false;
				return;
			}
		}
	}



	function add(){		
		var parentSerialNo = "<%=parentSerialNo%>";
		var divideType = "<%=divideType%>";
		var prjSerialNo = "<%=prjSerialNo%>";
		AsControl.PopView("/ProjectManage/ProjectNewApply/ScaleCLDownInfoOrg.jsp","ParentSerialNo="+parentSerialNo+"&DivideType="+divideType+"&PrjSerialNo="+prjSerialNo,"resizable=yes;dialogWidth=520px;dialogHeight=240px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}

	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var parentSerialNo = "<%=parentSerialNo%>";
		var divideType = "<%=divideType%>";
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		AsControl.PopComp("/ProjectManage/ProjectNewApply/ScaleCLDownInfoOrg.jsp","SerialNo="+serialNo+"&DivideType="+divideType+"&ParentSerialNo="+parentSerialNo,"resizable=yes;dialogWidth=520px;dialogHeight=240px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function del(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		if(confirm('ȷʵҪɾ����?')){
			as_delete(0);
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>