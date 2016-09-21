<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%
 String sCTSerialNoList = CurPage.getParameter("CTSerialNoList");
 if(StringX.isEmpty(sCTSerialNoList) || null==sCTSerialNoList ) sCTSerialNoList = "";
 String BDOPerateOrgID = CurPage.getParameter("BDOPerateOrgID");
 if(BDOPerateOrgID==null) BDOPerateOrgID="";
 %>
<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>任务分配</title>
</head>

<body>
<table border="1" cellspacing="0" cellpadding="0" width="420" align="center">
  <tr>
    <td width="120" valign="top"><p align="left"> <input  type="radio" name="typeRadioGroup" onClick="buttionChange()"  value="first" checked/></strong>催收作业 </p></td>
    <td width="300" valign="top"><p align="left">&nbsp;执行人员：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="id" name="" type="text"  readonly="true" />
         <input id="choose1" name="choose1" value=".." type="button" onClick="SelectGridValue()" />
    </p></td>
	
  </tr>
  <tr>
    <td width="120" valign="top"><p align="left"><strong>   <input  type="radio" name="typeRadioGroup" onClick="buttionChange()"  value="last" /></strong>外包催收 </p></td>
    <td width="300" valign="top"><p align="left">&nbsp;合作方选择：&nbsp;&nbsp;&nbsp;&nbsp;<input id="id2" name="" type="text" readonly="true" disabled/> 
    	<input id="hid1" type="hidden"> 
		<input id="choose2" name="choose2" value=".." type="button" onClick="Customer_Partner()" disabled/>
 <br />
      &nbsp;自定义任务批次：<input  id="id3" name="" type="text" disabled/>
      <input id="hid2" type="hidden"> 
      <input id="choose3" name="choose3" value=".." type="button" onClick="Customer_Task()" disabled/></p></td>
  </tr>
</table>
	<div align="center">
 &nbsp; &nbsp; &nbsp; &nbsp;<%=new Button("确认","确认","change()","","btn_icon_submit").getHtmlText()%>
 &nbsp; &nbsp; &nbsp; &nbsp;<%=new Button("取消","取消","cancle()","","btn_icon_close").getHtmlText()%>

	</div>
</body>
<!-- </html> -->
<script type="text/javascript">
<%/* DataWindow选择器选择 */%>
//单选按钮单击事件,将执行人员选择和合作方选择按钮设置为互斥，如果单选按钮选择执行人员，则合作方选择按钮不可用，如果单选按钮选择 合作方 ，则执行人员按钮不可用
function buttionChange(){
	var group=document.getElementsByName("typeRadioGroup");
	for(var i=0;i<group.length;i++){
		if(group[i].checked==true){
			if(group[i].value=="first"){
				document.getElementById("choose1").disabled=false;
				document.getElementById("choose2").disabled=true;
				document.getElementById("choose3").disabled=true;
				document.getElementById("id").disabled=false;
				document.getElementById("id2").disabled=true;
				document.getElementById("id2").value="";
				document.getElementById("id3").disabled=true;
				document.getElementById("id3").value="";
				
			}else if(group[i].value=="last"){
				document.getElementById("choose3").disabled=false;
				document.getElementById("choose2").disabled=false;
				document.getElementById("choose1").disabled=true;
				document.getElementById("id2").disabled=false;
				document.getElementById("id3").disabled=false;
				document.getElementById("id").disabled=true;
				document.getElementById("id").value="";
				
			}
		}
	}
}
var sIds = "";//执行人员的userid，全局变量,确定按钮会用到该变量
var sOrgId = "";//执行人员的所属机构编号，全局变量,确定按钮会用到该变量
//选择执行人员
function SelectGridValue(){
    //模板为Excute_USER_INFO的选择器，返回USERID@USERNAME
    //取得当前的经办机构
	var sReturn = AsDialog.SelectGridValue("Excute_USER_INFO", "<%=CurUser.getOrgID()%>", "USERID@USERNAME@BELONGORG@ORGNAME", "", false);
	if(!sReturn) return;
	var sNames = "";//执行人员名称
	//获得并截取返回值
	if(sReturn != "_CLEAR_"){
		var aIdName = sReturn.split("@");
		sIds = aIdName[0];
		sNames = aIdName[1];
		sOrgId = aIdName[2];
	}
	//在执行人员那个text显示返回的执行人员名称
	document.getElementById("id").value=sNames;
}
var sPIds = "";//合作方编号，全局变量,确定按钮会用到该变量
//选择外包合作方
function Customer_Partner(){
	//模板为Excute_USER_INFO的选择器，返回CUSTOMERID@CUSTOMERNAME
	var sReturn = AsDialog.SelectGridValue("CHOISE_PARTNER", "", "CUSTOMERID@CUSTOMERNAME", "", false);
	if(!sReturn) return;
   
    var sPNames = "";//合作方名称
	if(sReturn != "_CLEAR_"){
		var aIdName = sReturn.split("@");
		sPIds =aIdName[0];
		sPNames = aIdName[1];
	}
	//在合作方选择那个text显示返回的合作方名称
	document.getElementById("id2").value=sPNames;
	document.getElementById("hid1").value=sPIds;
}
//选择批次任务信息
function Customer_Task(){
	//模板为CHOISE_PARTNER的选择器，返回CUSTOMERID@CUSTOMERNAME
	var CustomerID=document.getElementById("hid1").value;
	if(typeof(CustomerID)=="undefined"||CustomerID.length==0||CustomerID==''){
		alert("请先选择一个合作商");
		return;
	}
	var sReturn = AsDialog.SelectGridValue("CHOISE_TASK", CustomerID, "SERIALNO@TASKNAME", "", false);
	if(!sReturn) return;
   
    var sPNames = "";
    var sPIds="";
	if(sReturn != "_CLEAR_"){
		var aIdName = sReturn.split("@");
		sPIds =aIdName[0];
		sPNames=aIdName[1];
		document.getElementById("id3").value=sPNames;
		document.getElementById("hid2").value=sPIds;
	}
}

function change(){
	//根据哪个单选按钮被选中判断是催收作业还是外包催收
	var group=document.getElementsByName("typeRadioGroup");
	for(var i=0;i<group.length;i++){
		if(group[i].checked==true){
			//如果是催收作业(分行催收)
			if(group[i].value=="first"){
				var sCTSerialNoList = "<%=sCTSerialNoList%>";
				var operateuserid=sIds;//选择器返回的执行人员的userid
				var sOperateOrgId = sOrgId;
				//判断执行人员是否为空
			    if (typeof(operateuserid)=="undefined" || operateuserid.length==0){
			        alert('请选择一位执行人员');
			        return;
				}
				//调用java方法 
			   // var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.urge.ChangeExcutePerson","execute","CTSerialNoList="+sCTSerialNoList+",operateuserid="+operateuserid);
			    var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.urge.CollSelectListAction", "collSelectAllot", "OperateUserId="+operateuserid+",OperateOrgId="+sOperateOrgId+",CTSerialNoList="+sCTSerialNoList+",TaskName= "+",UserId=<%=CurUser.getUserID()%>"+",OrgId=<%=CurUser.getOrgID()%>");
				if(sReturn == "true"){
			    	 alert("任务分配成功。");
			    	 self.close();
			    }else{
			    	 alert("任务分配失败，请重新进行任务分配。");
			    }
			 //如果是外包催收
			}else if(group[i].value=="last"){
				var sCTSerialNoList = "<%=sCTSerialNoList%>";
				var operateuserid=sPIds;   //选择器返回的合作方编号
				var taskbatchno=document.getElementById("id3").value;
				var TaskSerialNo=document.getElementById("hid2").value;
			    if (typeof(operateuserid)=="undefined" || operateuserid.length==0){
			        alert('请选择一个外包合作商！');
			        return;
				}
			    if (typeof(taskbatchno)=="undefined" || taskbatchno.length==0){
			        alert('请选择/输入一个外包任务批次！');
			        return;
				}
				//调用java方法 
			    //var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.urge.ChangeExcuteCompany","execute","CTSerialNoList="+sCTSerialNoList+",operateuserid="+operateuserid+",taskbatchno="+taskbatchno);
			    var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.urge.CollSelectListAction", "outCollSelectAllot", "TaskSerialNo="+TaskSerialNo+",OperateUserId="+operateuserid+",OperateOrgId=,CTSerialNoList="+sCTSerialNoList+",TaskName="+taskbatchno+",UserId=<%=CurUser.getUserID()%>"+",OrgId=<%=CurUser.getOrgID()%>");
				if(sReturn == "true"){
			    	alert('任务分配成功！');
			    	self.close();
			    }else{
			    	alert("任务分配失败，请重新进行任务分配！");
			    }
			}
		}
	}
}
function cancle(){
	//返回上个界面
	//history.back(-1);
	self.close();
}
</script>
<%@ include file="/IncludeEnd.jsp"%>