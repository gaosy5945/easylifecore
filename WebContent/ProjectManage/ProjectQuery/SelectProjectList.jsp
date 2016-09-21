<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("SelectProject");
	//doTemp.setJboWhereWhenNoFilter(" and 1=2 ");
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	dwTemp.setParameter("InputOrgID", CurOrg.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"false","All","Button","�½������ڷ���Ŀ","�½������ڷ���Ŀ","newProject()","","","","",""},
			{"true","All","Button","������Ŀ����","������Ŀ����","viewProject()","","","","",""},
			{"true","All","Button","����ҵ����ϸ","����ҵ����ϸ","projectBusinessDetail()","","","","",""},
			{"true","All","Button","��Ŀ�����ʷ","��Ŀ�����ʷ","projectAlterHistory()","","","","",""},
			{"true","All","Button","��Ŀ������Ϣ���","��Ŀ������Ϣ���","projectOthersAlter()","","","","",""},
			{"true","All","Button","��Ŀ�ϲ�","��Ŀ�ϲ�","projectMerge()","","","","",""},
			{"true","All","Button","��Ŀ��ֹ","��Ŀ��ֹ","projectStop()","","","","",""},
			{"true","","Button","��֤�������ϸ","��֤�������ϸ","MrgDetail()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function newProject(){
		AsControl.PopPage("/ProjectManage/ProjectNewApply/NewZeroStarhouse.jsp","","resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
	}
	
	function viewProject(){
		var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
		var customerID =  getItemValue(0,getRow(0),"CUSTOMERID");
		var status =  getItemValue(0,getRow(0),"STATUS");
		var projectType =  getItemValue(0,getRow(0),"PROJECTTYPE");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		var RightType = "ReadOnly";
		if(status == "11" && projectType == "0110"){
			RightType = "All";
		}
	    AsCredit.openFunction("ProjectInfoTab", "SerialNo="+serialNo+"&RightType="+RightType+"&CustomerID="+customerID);
	    reloadSelf();
	}
	function projectBusinessDetail(){
		var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
		var projectType =  getItemValue(0,getRow(0),"PROJECTTYPE");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		AsControl.PopPage("/ProjectManage/ProjectQuery/ProjectBusinessDetail.jsp","SerialNo="+serialNo+"&ProjectType="+projectType,"resizable=yes;dialogWidth=880px;dialogHeight=450px;center:yes;status:no;statusbar:no");
	}
	function projectAlterHistory(){
		var serialNo =  getItemValue(0,getRow(0),"AGREEMENTNO");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		AsControl.PopPage("/ProjectManage/ProjectAlterNewApply/PrjAlterHistory.jsp","SerialNo="+serialNo,"resizable=yes;dialogWidth=680px;dialogHeight=450px;center:yes;status:no;statusbar:no");
	}

	function projectOthersAlter(){
		var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
		var projectType =  getItemValue(0,getRow(0),"PROJECTTYPE");
		var status =  getItemValue(0,getRow(0),"STATUS");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		if(projectType == "0110" || projectType == "0108"){
			alert("����Ŀ��������������Ϣ��");
			return;
		}else{
			if(status == "13"){
				AsCredit.openFunction("ProjectOthersAlterInfo","ProjectSerialNo="+serialNo);
				reloadSelf();
			}else if(status == "14"){
				alert("����Ŀ�Ѹ��˷������������и�����Ϣ�����");
				return;
			}else if(status == "16"){
				alert("����Ŀ��ʧЧ����������и�����Ϣ�����");
				return;			
			}else{
				alert("����Ŀ�������У���������и�����Ϣ�����");
				return;
			}
		}
	}
	function projectMerge(){
		var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		var status =  getItemValue(0,getRow(0),"STATUS");
		if(status == "13"){
			AsCredit.openFunction("ProjectMergeAlterInfo","ProjectSerialNo="+serialNo);
			reloadSelf();
		}else if(status == "14"){
			alert("����Ŀ�Ѹ��˷���������������Ŀ�ϲ���");
			return;
		}else if(status == "16"){
			alert("����Ŀ��ʧЧ�������������Ŀ�ϲ���");
			return;			
		}else{
			alert("����Ŀ�������У������������Ŀ�ϲ���");
			return;
		}
	}
	function projectStop(){
		var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		var projectStatus = getItemValue(0,getRow(0),"STATUS");
			if(projectStatus == "13"){
				var agreementNo = getItemValue(0,getRow(0),"AGREEMENTNO");
				var flag = ProjectManage.judgeIsAlterApply(agreementNo);
					if(flag == "1"){
						alert("����Ŀ�ڱ������׶Σ���������ֹ��Ŀ��");
						return;
					}else{
						AsCredit.openFunction("ProjectStopAlterInfo","ProjectSerialNo="+serialNo);
						reloadSelf();
					}
			}else if(projectStatus == "14"){
				alert("����Ŀ�Ѹ��˷������������ֹ��Ŀ��");
				return;
			}else if(projectStatus == "16"){
				alert("����Ŀ��ʧЧ�������ٴβ�����");
				return;
			}else{
				alert("����Ŀ��������׶Σ���������ֹ��Ŀ��");
				return;
			}
		}
	function MrgDetail(){
		var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
		var projectType =  getItemValue(0,getRow(0),"PROJECTTYPE");
		var customerID =  getItemValue(0,getRow(0),"CUSTOMERID");
		var status =  getItemValue(0,getRow(0),"STATUS");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		if(status == "13"){
			var result = ProjectManage.getAccountNo(serialNo);
			result = result.split("@");
			if(result[0] == "0"){
				alert("����Ŀ�ޱ�֤����Ϣ���޷����ɱ�֤��");
				return;
			}else if(result[0] == "1"){
				alert("����Ŀ�ޱ�֤���˻��˺ţ��޷����ɱ�֤��!");
				return;
			}else{
				var AccountNo = result[1];
				AsControl.PopComp("/ProjectManage/ProjectNewApply/ProjectMarginDetailList.jsp","SerialNo="+serialNo+"&ProjectType="+projectType+"&AccountNo="+AccountNo+"&CustomerID="+customerID,"resizable=yes;dialogWidth=600px;dialogHeight=400px;center:yes;status:no;statusbar:no");
			}
		}else if(status == "14"){
			alert("����Ŀ�Ѹ��˷������������б�֤����ɣ�");
			return;
		}else if(status == "16"){
			alert("����Ŀ��ʧЧ����������б�֤����ɣ�");
			return;			
		}else{
			alert("����Ŀ�������У���������б�֤����ɣ�");
			return;
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
