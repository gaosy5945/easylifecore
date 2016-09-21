<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sTaskBatchNo = CurPage.getParameter("TaskBatchNo");
	if(sTaskBatchNo == null) sTaskBatchNo = "";
	String sCTSerialNo = CurPage.getParameter("CTSerialNo");
	if(sCTSerialNo == null) sCTSerialNo = "";
	String sOperateUserID = CurPage.getParameter("OperateUserID");
	if(sOperateUserID == null) sOperateUserID = "";
	String sOperateUserName = CurPage.getParameter("OperateUserName");
	if(sOperateUserName == null) sOperateUserName = "";

	String sTempletNo = "OutCollRegistrateInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setHtmlEvent("CONTACTMETHOD", "onClick", "operateDescription");
	doTemp.setHtmlEvent("ENTRUSTENDDATE", "onChange", "entrustEndDateOperateDescription");
	doTemp.setHtmlEvent("ENTRUSTDATE", "onChange", "entrustDateOperateDescription");
	
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sTaskBatchNo+","+sCTSerialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","save()","","","",""},
		//{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		//返回上个界面
		history.back(-1);
	}
	function save(){
		as_save("myiframe0");
	}
	
	function operateDescription(){
		var ContactMethod=getItemValue(0,getRow(),"CONTACTMETHOD");
		if(ContactMethod=="1" ||ContactMethod=="2"||ContactMethod=="3"||ContactMethod=="4"||ContactMethod=="5"){
			showItem(0,'CONTACTRESULT');
		  $("[name=CONTACTRESULT]").each(function(){
		 	$(this).parent().hide();
		 	if(ContactMethod=="1"){
				if(this.value=="0101" || this.value=="0102"){
					$(this).parent().show();
				}
		 	}else if(ContactMethod=="2"){
		 		if(this.value=="0201" || this.value=="0202"|| this.value=="0203"|| this.value=="0204"|| this.value=="0205"
				  || this.value=="0206"|| this.value=="0207"|| this.value=="0208"|| this.value=="0209"|| this.value=="0210"|| this.value=="0299"){
					$(this).parent().show();
				}
		 	}else if(ContactMethod=="3"){
		 		if(this.value=="0301" || this.value=="0302"|| this.value=="0303"|| this.value=="0304"
					  || this.value=="0305"|| this.value=="0306"|| this.value=="0399"){
					$(this).parent().show();
				}
			}else if(ContactMethod=="4"){
				 if(this.value=="0401" || this.value=="0402"|| this.value=="0403"|| this.value=="0404"|| this.value=="0405"
					  || this.value=="0406"|| this.value=="0407"|| this.value=="0408"|| this.value=="0409"
					  || this.value=="0410"|| this.value=="0411"|| this.value=="0412"|| this.value=="0413"){
					$(this).parent().show();
				}
			}else if(ContactMethod=="5"){
				//if(this.value=="0900"){
				if(this.value=="0900"||  this.value=="0510" ||  this.value=="0520" ||  this.value=="0530" ) {
					$(this).parent().show();
				}
			}    
		  }); 
		}else{
			hideItem(0,'CONTACTRESULT');
		}
	}
	
	function entrustDateOperateDescription(){
		var entrustDate=getItemValue(0,getRow(),"ENTRUSTDATE");
		var entrustEndDate=getItemValue(0,getRow(),"ENTRUSTENDDATE");
		if((entrustDate != "" || entrustDate.length != 0) && (entrustEndDate != "" || entrustEndDate.length != 0)) {
			if(entrustDate >= entrustEndDate) {
				alert("结案日期应晚于委案日期");
				setItemValue(0,getRow(),"ENTRUSTDATE","");
			}
		}
	}
	
	function entrustEndDateOperateDescription(){
		var entrustDate=getItemValue(0,getRow(),"ENTRUSTDATE");
		var entrustEndDate=getItemValue(0,getRow(),"ENTRUSTENDDATE");
		if((entrustDate != "" || entrustDate.length != 0) && (entrustEndDate != "" || entrustEndDate.length != 0)) {
			if(entrustDate >= entrustEndDate) {
				alert("结案日期应晚于委案日期");
				setItemValue(0,getRow(),"ENTRUSTENDDATE","");
			}
		}
	}

	$(document).ready(function(){
		setItemValue(0,0,"PROCESSUSERID","<%=sOperateUserID%>");
		setItemValue(0,0,"PROCESSUSERNAME","<%=sOperateUserName%>");
		setItemValue(0,0,"PROCESSORGID","<%=sOperateUserID%>");
		setItemValue(0,0,"PROCESSORGNAME","<%=sOperateUserName%>");
		setItemValue(0,0,"SERIALNO",getSerialNo("COLL_TASK_PROCESS", "SerialNo", ""));
		setItemValue(0,0,"TASKSERIALNO","<%=sCTSerialNo%>");
		operateDescription();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
