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
	String ProductList = CurPage.getParameter("ProductList");
	if(ProductList == null) ProductList = "";
	
	ASObjectModel doTemp = new ASObjectModel("ScaleCreditLineDownListProduct");
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
			var productBusinessAppAmt = getItemValue(0,i,"BUSINESSAPPAMT");
			var serialNo = getItemValue(0,i,"SERIALNO");
			var replaceData = productBusinessAppAmt.replace(/,/g, "");
			DataGroup += replaceData + "@";
			SerialNoGroup += serialNo + "@";
			var sum = parseFloat(sum)+parseFloat(replaceData);
		}
		var divideType = "10";
		var sReturn = ProjectManage.getBusinessAppAmt(parentSerialNo,divideType);
		if(sReturn == "CLParentEmpty"|| sReturn == "CLEmpty"  || sReturn == "SameNotSave"){
			alert("���ȱ����ģ�����Ϣ���ٽ��ж���зֲ�����");
			return;
		}else{
			if(flag){
				var temp = parseFloat(sum);
				if(temp != businessAppAmt){
					if(confirm('��ע�⣬��Ŀ�зֶ�Ȳ�����ʵ�ʶ���ܹ�ģ���Ƿ�����з�?'))
					var sReturn = ProjectManage.updateBusinessAppAmt(SerialNoGroup,DataGroup,parentSerialNo);
					if(sReturn == "SUCCEED"){
						alert("����зֳɹ���");
					}
				}else{
					var sReturn = ProjectManage.updateBusinessAppAmt(SerialNoGroup,DataGroup,parentSerialNo);
					if(sReturn == "SUCCEED"){
						alert("����зֳɹ���");
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
			var productBusinessAppAmt = getItemValue(0,i,"BUSINESSAPPAMT");
			var businessName = getItemValue(0,i,"BUSINESSTYPENAME");
			var replaceData = productBusinessAppAmt.replace(/,/g, "");
			if(parseFloat(replaceData) > parseFloat(businessAppAmt)){
				alert("��"+businessName+"��"+"���зֶ�ȴ��ڶ���ܽ����������룡");
				flag = false;
				return;
			}
		}
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
