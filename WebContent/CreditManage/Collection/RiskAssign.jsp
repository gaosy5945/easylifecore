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
<title>�������</title>
</head>

<body>
<table border="1" cellspacing="0" cellpadding="0" width="420" align="center">
  <tr>
    <td width="120" valign="top"><p align="left"> <input  type="radio" name="typeRadioGroup" onClick="buttionChange()"  value="first" checked/></strong>������ҵ </p></td>
    <td width="300" valign="top"><p align="left">&nbsp;ִ����Ա��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="id" name="" type="text"  readonly="true" />
         <input id="choose1" name="choose1" value=".." type="button" onClick="SelectGridValue()" />
    </p></td>
	
  </tr>
  <tr>
    <td width="120" valign="top"><p align="left"><strong>   <input  type="radio" name="typeRadioGroup" onClick="buttionChange()"  value="last" /></strong>������� </p></td>
    <td width="300" valign="top"><p align="left">&nbsp;������ѡ��&nbsp;&nbsp;&nbsp;&nbsp;<input id="id2" name="" type="text" readonly="true" disabled/> 
    	<input id="hid1" type="hidden"> 
		<input id="choose2" name="choose2" value=".." type="button" onClick="Customer_Partner()" disabled/>
 <br />
      &nbsp;�Զ����������Σ�<input  id="id3" name="" type="text" disabled/>
      <input id="hid2" type="hidden"> 
      <input id="choose3" name="choose3" value=".." type="button" onClick="Customer_Task()" disabled/></p></td>
  </tr>
</table>
	<div align="center">
 &nbsp; &nbsp; &nbsp; &nbsp;<%=new Button("ȷ��","ȷ��","change()","","btn_icon_submit").getHtmlText()%>
 &nbsp; &nbsp; &nbsp; &nbsp;<%=new Button("ȡ��","ȡ��","cancle()","","btn_icon_close").getHtmlText()%>

	</div>
</body>
<!-- </html> -->
<script type="text/javascript">
<%/* DataWindowѡ����ѡ�� */%>
//��ѡ��ť�����¼�,��ִ����Աѡ��ͺ�����ѡ��ť����Ϊ���⣬�����ѡ��ťѡ��ִ����Ա���������ѡ��ť�����ã������ѡ��ťѡ�� ������ ����ִ����Ա��ť������
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
var sIds = "";//ִ����Ա��userid��ȫ�ֱ���,ȷ����ť���õ��ñ���
var sOrgId = "";//ִ����Ա������������ţ�ȫ�ֱ���,ȷ����ť���õ��ñ���
//ѡ��ִ����Ա
function SelectGridValue(){
    //ģ��ΪExcute_USER_INFO��ѡ����������USERID@USERNAME
    //ȡ�õ�ǰ�ľ������
	var sReturn = AsDialog.SelectGridValue("Excute_USER_INFO", "<%=CurUser.getOrgID()%>", "USERID@USERNAME@BELONGORG@ORGNAME", "", false);
	if(!sReturn) return;
	var sNames = "";//ִ����Ա����
	//��ò���ȡ����ֵ
	if(sReturn != "_CLEAR_"){
		var aIdName = sReturn.split("@");
		sIds = aIdName[0];
		sNames = aIdName[1];
		sOrgId = aIdName[2];
	}
	//��ִ����Ա�Ǹ�text��ʾ���ص�ִ����Ա����
	document.getElementById("id").value=sNames;
}
var sPIds = "";//��������ţ�ȫ�ֱ���,ȷ����ť���õ��ñ���
//ѡ�����������
function Customer_Partner(){
	//ģ��ΪExcute_USER_INFO��ѡ����������CUSTOMERID@CUSTOMERNAME
	var sReturn = AsDialog.SelectGridValue("CHOISE_PARTNER", "", "CUSTOMERID@CUSTOMERNAME", "", false);
	if(!sReturn) return;
   
    var sPNames = "";//����������
	if(sReturn != "_CLEAR_"){
		var aIdName = sReturn.split("@");
		sPIds =aIdName[0];
		sPNames = aIdName[1];
	}
	//�ں�����ѡ���Ǹ�text��ʾ���صĺ���������
	document.getElementById("id2").value=sPNames;
	document.getElementById("hid1").value=sPIds;
}
//ѡ������������Ϣ
function Customer_Task(){
	//ģ��ΪCHOISE_PARTNER��ѡ����������CUSTOMERID@CUSTOMERNAME
	var CustomerID=document.getElementById("hid1").value;
	if(typeof(CustomerID)=="undefined"||CustomerID.length==0||CustomerID==''){
		alert("����ѡ��һ��������");
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
	//�����ĸ���ѡ��ť��ѡ���ж��Ǵ�����ҵ�����������
	var group=document.getElementsByName("typeRadioGroup");
	for(var i=0;i<group.length;i++){
		if(group[i].checked==true){
			//����Ǵ�����ҵ(���д���)
			if(group[i].value=="first"){
				var sCTSerialNoList = "<%=sCTSerialNoList%>";
				var operateuserid=sIds;//ѡ�������ص�ִ����Ա��userid
				var sOperateOrgId = sOrgId;
				//�ж�ִ����Ա�Ƿ�Ϊ��
			    if (typeof(operateuserid)=="undefined" || operateuserid.length==0){
			        alert('��ѡ��һλִ����Ա');
			        return;
				}
				//����java���� 
			   // var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.urge.ChangeExcutePerson","execute","CTSerialNoList="+sCTSerialNoList+",operateuserid="+operateuserid);
			    var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.urge.CollSelectListAction", "collSelectAllot", "OperateUserId="+operateuserid+",OperateOrgId="+sOperateOrgId+",CTSerialNoList="+sCTSerialNoList+",TaskName= "+",UserId=<%=CurUser.getUserID()%>"+",OrgId=<%=CurUser.getOrgID()%>");
				if(sReturn == "true"){
			    	 alert("�������ɹ���");
			    	 self.close();
			    }else{
			    	 alert("�������ʧ�ܣ������½���������䡣");
			    }
			 //������������
			}else if(group[i].value=="last"){
				var sCTSerialNoList = "<%=sCTSerialNoList%>";
				var operateuserid=sPIds;   //ѡ�������صĺ��������
				var taskbatchno=document.getElementById("id3").value;
				var TaskSerialNo=document.getElementById("hid2").value;
			    if (typeof(operateuserid)=="undefined" || operateuserid.length==0){
			        alert('��ѡ��һ����������̣�');
			        return;
				}
			    if (typeof(taskbatchno)=="undefined" || taskbatchno.length==0){
			        alert('��ѡ��/����һ������������Σ�');
			        return;
				}
				//����java���� 
			    //var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.urge.ChangeExcuteCompany","execute","CTSerialNoList="+sCTSerialNoList+",operateuserid="+operateuserid+",taskbatchno="+taskbatchno);
			    var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.urge.CollSelectListAction", "outCollSelectAllot", "TaskSerialNo="+TaskSerialNo+",OperateUserId="+operateuserid+",OperateOrgId=,CTSerialNoList="+sCTSerialNoList+",TaskName="+taskbatchno+",UserId=<%=CurUser.getUserID()%>"+",OrgId=<%=CurUser.getOrgID()%>");
				if(sReturn == "true"){
			    	alert('�������ɹ���');
			    	self.close();
			    }else{
			    	alert("�������ʧ�ܣ������½���������䣡");
			    }
			}
		}
	}
}
function cancle(){
	//�����ϸ�����
	//history.back(-1);
	self.close();
}
</script>
<%@ include file="/IncludeEnd.jsp"%>