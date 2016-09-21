<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	/*
	Author:   qzhang  2004/12/04
	Tester:
	Content: ���Ӻ�ͬ�б�
	Input Param:	 
	Output param:
	History Log: 
	*/
	
	//����������
	String sObjectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));//���Ӻ�ͬ��Ӧ��ͬ��
	String sObjectType = DataConvert.toString(CurPage.getParameter("ObjectType"));//��ͬ����
	String edocs = "All";
	if("jbo.app.BUSINESS_CONTRACT".equals(sObjectType))
	{
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject bc = bom.loadBusinessObject(sObjectType, sObjectNo);
		edocs = ProductAnalysisFunctions.getComponentOptionalValue(bc, "PRD04-03", "BusinessEDocs", "", "02");
		if(edocs == null) edocs = "All";
	}
	//<!---------->ģ���ţ�֮��̬��ȡ��������
	String docno = "0101";

	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	
	ASObjectModel doTemp = new ASObjectModel("EdocContrctList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ObjectNo", sObjectNo);
	dwTemp.setParameter("ObjectType", sObjectType);
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","���ɵ��Ӻ�ͬ","���ɵ��Ӻ�ͬ","getEDoc()","","","","",""},
			{"true","","Button","�鿴���Ӻ�ͬ","�鿴���Ӻ�ͬ","showDoc()","","","","",""},
			{"true","All","Button","��ӡ","��ӡ","printDoc()","","","","",""},
			{"true","All","Button","ɾ��","ɾ��","deletere()","","","","",""}
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function deletere(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		as_delete(0);
	}
	function PrintEDocView()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "EDocViewNew";
		sCompURL = "/Common/EDOC/EDocViewNew.jsp";
		sParamString = "SerialNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}
	
	function getEDoc(){
		
		var returnValue = "";
		if("<%=sObjectType%>" == "jbo.guaranty.GUARANTY_CONTRACT"){
			returnValue = AsCredit.selectMultipleTree("SelectEDocConfig1", "", ",", "");
		}else{
			returnValue = AsCredit.selectMultipleTree("SelectEDocConfig", "EDocs,<%=edocs%>", ",", "");
		}
		if(returnValue["ID"].length == 0) return;
		var eDocID = returnValue["ID"];
		eDocID = eDocID.split(",");
		for(var i in eDocID){
			if(typeof eDocID[i] == "string" && eDocID.length > 0 ){
				var ID = eDocID[i];
				var sReturn =  RunJavaMethodTrans("com.amarsoft.app.edoc.EDocPrint","docHandle","objectno=<%=sObjectNo%>,objecttype=<%=sObjectType%>,docNo="+ID);
				if(sReturn == "true"){
					alert("���ɳɹ�");
					reloadSelf(); 
				}
				else{
					alert("����ʧ��");
				}
			}
		}
		return;
	}
	
	function printDoc(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		RunJavaMethodTrans("com.amarsoft.app.edoc.UploadBaseRate","uploadBaseRate","serialNo=<%=sObjectNo%>");
		if (typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		var printNum = getItemValue(0,getRow(),"PrintNum");
		if (typeof(printNum)=="undefined" || printNum.length==0){
			printNum = "0";
		}
		/* sCompID = "EDocViewNew";
		sCompURL = "CreditManage/CreditContract/EDocViewNew.jsp";
		sParamString = "SerialNo="+docNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle); */
	    showDoc();
	    RunJavaMethodTrans("com.amarsoft.app.edoc.EDocPrint", "upPrintNum", "SerialNo="+serialNo+",PrintNum="+printNum);
	    reloadSelf();
	}
	
	function showDoc(){
		
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else{
			AsControl.PopView("CreditManage/CreditContract/ShowEDoc.jsp","serialNo="+sSerialNo);
		}		
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
