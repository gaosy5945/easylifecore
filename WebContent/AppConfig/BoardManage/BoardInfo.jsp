<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		页面说明: 公告详情
	 */
	//获得页面参数
	String sBoardNo = CurPage.getParameter("BoardNo");
	if(sBoardNo==null) sBoardNo="";
	String sDocNo = CurPage.getParameter("DocNo");
	if(sDocNo==null) sDocNo="";

	ASObjectModel doTemp = new ASObjectModel("BoardInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow(sBoardNo);
	
	/* dwTemp.replaceColumn("DOCFILE","<iframe type='iframe' id=\"docFile\" name=\"frame_list\" width=\"100%\" height=\"500\" frameborder=\"0\" src=\""+sWebRootPath+"/AppConfig/Document/AttachmentFrame.jsp?DocNo="+sDocNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	 */
	String orgId = CurUser.getOrgID();
	String userId = CurUser.getUserID();
	String inputTime = DateHelper.getBusinessDate();
	String orgname = CurUser.getOrgName();
	

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
		//{"true","","Button","上传文件","上传文件","fileadd()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	
	initRow();

	function saveRecord(){
		as_save(0,"reloadPage()");
	}
	
	function reloadPage(){
		var docNo = getItemValue(0,0,"DocNo");
		parent.OpenInfo(docNo);
	}
	
	/* function fileadd(){

		var sDocNo = getItemValue(0,getRow(),"DocNo");
		if(typeof(sDocNo)=="undefined" || sDocNo.length==0) {
			alert("先保存信息再上传文件!");
			return ;
		}else{
			AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo, "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    }
	} */
	
	function initSerialNo(){
		
		var sTableName = "BOARD_LIST";//表名
		var sColumnName = "boardno";//字段名
		var sPrefix = "";//前缀
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);		
		return sSerialNo;
	}
	
	function initRow(){
		//if(getRow()==0){
			hideItem("myiframe0","docFile");
		//}
	}

</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>