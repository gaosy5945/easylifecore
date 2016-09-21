<%@page import="com.amarsoft.dict.als.object.Item"%>
<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  
		Tester:
		Content: �ҵĹ���̨
		Input Param:
			          
		Output param:
			      
		History Log: syang 2009/09/28 ҳ����������ȥ���������õ�HTML
								 syang 2009/10/20ҳ�����������ʾ��������Щҳ�������
								 				��ο��������룺PlantformTask�����������
								 												����һ��δ��ɹ�����ʾ��ֻ��Ҫ���ú���Ӧҳ��URL��ַ���ɣ�����Ҫ�����޸Ĵ�ҳ��
								 syang 2009/12/10 ����̨style��ʽ�ļ�������������ƿ⣬����ʹ��HTML�����Ч��
		ע�⣺����������ʾ���벻Ҫ�޸Ĵ�ҳ�棬��ο�����[PlantformTask]�����ã�ֻ��Ҫ�ڸô��������ú���Ӧҳ�漴��
	 */
	%>
<%/*~END~*/%>
<html>
<head>
	<title>�ճ�������ʾ</title>
	<link rel="stylesheet" href="<%=sWebRootPath%>/AppMain/resources/css/worktips.css">
	<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%><%=sSkinPath%>/css/worktips.css">
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" id="mybody" style="background:transparent;">
	<div id="WindowDiv">
		<!-- ע�⣺����������ʾ���벻Ҫ�޸Ĵ�ҳ�棬��ο�����[PlantformTask]�����ã�ֻ��Ҫ�ڸô��������ú���Ӧҳ�漴�� -->
		<!-- �������� -->
		<div id="WorkPlanDiv">
			<table align='left' border="0" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" width="100%" >
	        <%
	        String sAllItemNo = "";
	    	//ȡ���������
	    	Item[] codeDef = CodeManager.getItems("PlantformTask");
	    	if(codeDef!=null&&codeDef.length>0){
	        	for(int i=0;i<codeDef.length;i++){
	        		Item vpItem = codeDef[i];
	    			String sItemNo = (String)vpItem.getItemNo();
	    			String sItemName = (String)vpItem.getItemName();
	    			String sRoleID = (String)vpItem.getRelativeCode();//���õĽ�ɫ
	    			String sAttribute = (String)vpItem.getAttribute1();
	    			boolean bPass = false;
	    			
	    			//��鵱ǰ�û��Ƿ��в鿴�Ľ�ɫ
	    			if(sRoleID == null || sRoleID.length() == 0){	//���û�����ý�ɫ���ƣ���Ĭ��ȫ���ɼ�
	    				sRoleID = "";
	    				bPass = true;
	    			}
	    			if(bPass == false){
	    				String[] roleIDArray = sRoleID.split(",");
	    				for(int j=0;j<roleIDArray.length;j++){	//��ɫ���
	    					if(CurUser.hasRole(roleIDArray[j])){
	    						bPass = true;
	    						break;
	    					}
	    				}
	    			}
	    					
	    			//�����ɫ���δͨ��������ʾ��ǰ����������
	    			if(bPass == false){
	    				continue;
	    			}
	    			sAllItemNo += (","+sItemNo);
					%> 
					<tr>
						<td align="left" colspan="2"  background="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/workTipLine.gif" >
							<table border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<span style="display:inline-block;" id="Plus<%=sItemNo%>" >&nbsp;</span><!-- class="FilterIcon"  -->
										<span class="FilterIcon2" style="display:none" id="Minus<%=sItemNo%>" >&nbsp;</span>
									</td>
									<td>
										<b><a href="javascript:void(0);" ><%=sItemName%>&nbsp;<span id="CountSpan<%=sItemNo%>"></span>&nbsp;����������пɰ�&nbsp;<span id="CountSpan1<%=sItemNo%>"></span>&nbsp;��</a></b>
									</td>
								</tr>
							</table>
	           </td>
					</tr>
   	     <!-- �������� -->
					<tr>
						<td align="left" colspan="2" class="DataList" id="DataList<%=sItemNo%>"></td>
					</tr>
         <%
         		}
	    	}
	        if(sAllItemNo != null && sAllItemNo.length() > 0){
	        	sAllItemNo = sAllItemNo.substring(1,sAllItemNo.length());
	        }
         %>       		
				</table>
		</div>
	</div>
</body>
</html>



<script type="text/javascript">
   var num=0;
	$(document).ready(function(){
		sAllItemNo = "<%=sAllItemNo%>";
		CountPlantformRecur(sAllItemNo, 0); //�첽�ȴ��ݹ麯��
	});
	//--------------------------
</script>
<script type="text/javascript">
	function openFile(sDocNo){
	    AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo+"&RightType=ReadOnly", "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	//�鿴ȫ�������ʼ�
	function viewWorkRecord(){
		PopComp("WorkRecordList","/DeskTop/WorkRecordList.jsp","NoteType=All","","");
	}
	
	/**
	 *ͳ�ƴ������ҵ������ �ݹ麯�� yzheng
	 *@allItemNo ���еı�� String
	 *@index ��ǰ��������
 	 */
	function CountPlantformRecur(allItemNo, index)
	{
		//alert("tips");
		if(allItemNo == null || allItemNo.length == 0) return;
		var itemNoArray = allItemNo.split(",");
		
		if(index >= itemNoArray.length  || index < 0) return "done";  //�ݹ���ֹ����
		
		var ItemNo = itemNoArray[index];  //��ȡ��ǰ����ָ���Ԫ��
		//alert(index + " : " + ItemNo);
		var xmlHttp = getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/InvokerAjax.jsp";
		url=url+"?CompClientID=<%=SpecialTools.amarsoft2Real(sCompClientID)%>&ItemNo="+ItemNo+"&Type=0&CodeNo=PlantformTask";

		xmlHttp.onreadystatechange = function(){
			var message = "";
			var message1 = "";
			if (xmlHttp.readyState == 4  && xmlHttp.status == 200) {
				message = xmlHttp.responseText;
				message1 = xmlHttp.responseText;
				message=parseInt(message.split("@")[0]);
				message1 = parseInt(message1.split("@")[1]);
		 		//totalNum(message);
		 		//totalNum(message1);
				message="<font color=red>"+message+"</font>";
				message1="<font color=red>"+message1+"</font>";
				
				var rs = CountPlantformRecur(allItemNo, ++index);  //�ݹ���ã�ǰһ��������ɺ���ִ����һ����ʵ���첽�ȴ�
				
				if(rs == "done");// parent.clickPrompt();
			}
			else{
				message = "<img border=0 src='<%=sWebRootPath%>/Frame/page/resources/images/main/icons/35.gif'>";
			}
			$("#CountSpan"+ItemNo).html(message);
			$("#CountSpan1"+ItemNo).html(message1);
		};
		
		xmlHttp.open("GET", url, true);
		xmlHttp.send(null);
		return;
	}
	
	function totalNum(message){
		 num+=message;
		 parent.aem[self.name].text(num);
		 //parent.window.setNum("TaskNum",num); 
	}
	
	/**
	 *�����Ӧ��Tripʱ��չʾ��Ӧ������
	 *@ItemNo ���
	 */
	 <%--function touchPlantform(ItemNo){
		 var xmlHttp = getXmlHttpObject();
		if (xmlHttp==null){
		  alert ("Your browser does not support AJAX!");
		  return;
		}
		if(eid("DataList"+ItemNo).innerHTML == ""){
			var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/InvokerAjax.jsp";
			url=url+"?CompClientID=<%=SpecialTools.amarsoft2Real(sCompClientID)%>&ItemNo="+ItemNo+"&Type=1&CodeNo=PlantformTask";
			xmlHttp.onreadystatechange = function(){
				var message = "";
				if (xmlHttp.readyState == 4) {
					//message = genDataList(xmlHttp.responseText);
					message = xmlHttp.responseText;
				}else{
					message = "<img border=0 bordercolordark='#CCCCCC' src='<%=sWebRootPath%>/Frame/page/resources/images/main/icons/33.gif'>";
				}
				eid("DataList"+ItemNo).innerHTML=message;
			};
			xmlHttp.open("GET", url, true);
			xmlHttp.send(null);
			eid("Plus"+ItemNo).style.display = "none";
			eid("Minus"+ItemNo).style.display = "block";
		}else{
			eid("DataList"+ItemNo).innerHTML = "";
			eid("Plus"+ItemNo).style.display = "block";
			eid("Minus"+ItemNo).style.display = "none";
		} 
	}--%>
	function eid(id){
		return document.getElementById(id);
	}

	function getXmlHttpObject() {
		var xmlHttp=null;
		try{
			  // Firefox, Opera 8.0+, Safari
			  xmlHttp=new XMLHttpRequest();
		  }catch (e) {
			  // Internet Explorer
			  try{
			    xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
			  }catch (e){
			    xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
			  }
	  	}
		return xmlHttp;
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>