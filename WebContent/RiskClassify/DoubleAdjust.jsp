<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%   String sSerialno = CurPage.getParameter("SerialNo");
     sSerialno=	sSerialno.replace("@", ",");
     sSerialno=sSerialno.substring(1);
	//String sDocNo = CurPage.getParameter("DocNo");
	String sTempletNo = "DoubleApplyInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("APPLYADJUSTINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/RiskClassify/DoubleAdjustList.jsp?SerialNo="+sSerialno+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("ADDITIONINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/RiskClassify/DocInfoList.jsp?DOCNO="+CurPage.getParameter("DocNo")+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveInfo()","","","","",""},
		{"true","All","Button","提交","提交","saveInfo()","","","","",""},
		{"true","All","Button","取消","取消","returnList()","","","","",""},
		};
%> 
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script>
 function changeClassifyMethod(){
	 if (CLASSIFYMETHOD =='系统分类”'){
		 setItemValue(0,getRow(),"FINALGRADE","111");
	 }else{
		 
	 }
	 //alert(11);
	 //setItemValue(0,getRow(),"FINALGRADE","111");
 }
 
 
	function saveRecord(sPostEvents){
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	
	function returnList(){
		history.back(-1);

	}
	
	</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
