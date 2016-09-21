<!DOCTYPE html>
<%@page import="java.net.InetAddress"%>
<%-- <%@page import="com.amarsoft.app.als.image.ImageAuthManage"%> --%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<script type="text/javascript" src="<%=request.getContextPath()%>/ImageTrans/jquery-1.7.2.min.js"></script>
<%
	//获得组件参数	,影像对象号（客户号或申请号）、影像类型号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	if( sObjectType == null ) sObjectType = "";
	if( sObjectNo == null ) sObjectNo = "";
	if( sTypeNo == null ) sTypeNo = "";
	if( sRightType == null ) sRightType = "";
	
	System.out.println("****************"+sObjectType +"  " + sObjectNo+" "+sTypeNo);
	
	//获取权限
	String sAuthCode = "";
	/* if( sRightType.equals( "ReadOnly" ) ) sAuthCode = "100";	//如果页面只读，则只有查看权
	else sAuthCode = ImageAuthManage.getAuthCode( sObjectType, sObjectNo, CurUser.getUserID() ); */
	sAuthCode = "111";
	
	
	//插件要访问的servlet地址
	String ip = request.getLocalAddr();
	if(ip==null || ip.length()==0){
		ip = InetAddress.getByName(request.getServerName()).getHostAddress();
	} else if("0.0.0.0".equals(ip)){
		ip = "127.0.0.1";
	}
	//ip = "10.10.10.50";
	//ip = "10.10.1.51";
	String sServletPath = CurConfig.getConfigure("ServletPaht");
	
	//本地环境
	String servletPath = "http://"+ip+":"+request.getLocalPort()+application.getContextPath()+"/servlet/ActiveX";
	//服务器环境独立影像系统
	//String servletPath = "http://"+sServletPath+"/servlet/ActiveX";
	
	System.out.println(sServletPath+"---"+servletPath);
	
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>影像资料</title>
<script type="text/javascript">
function updatetype(){
	var str = "";
	var styp = "";
	var chk = document.getElementsByName("image");
	var type = document.getElementsByName("imagetype");
	for(var i = 0;i < chk.length;i++){
		if(chk[i].checked){
			str += chk[i].value+"|";
		}
	}
	for(var i = 0;i < type.length;i++){
		if(type[i].checked){
			styp = type[i].value;
		}
	}
	
	if(typeof(str)=="undefined" || str.length==0) {
		alert("请选择要修改的影像文件！");
        return ;
	}
	if(typeof(styp)=="undefined" || styp.length==0) {
		alert("请选择修改的影像类型！");
        return ;
	}
	sReturn=RunMethod("ImageManage","UpdateType",str+","+styp);
	if(sReturn == "Sesses"){
		alert("修改成功！");
		parent.reloadSelf();
	}
}

function deleImage(){
	var str = "";
	var styp = "";
	var chk = document.getElementsByName("image");
	for(var i = 0;i < chk.length;i++){
		if(chk[i].checked){
			str += chk[i].value+"|";
		}
	}
	if(typeof(str)=="undefined" || str.length==0) {
		alert("请选择要删除的影像文件！");
        return ;
	}
	sReturn=RunMethod("ImageManage","DeleteImage",str+","+styp);
	if(sReturn == "Sesses"){
		alert("删除成功！");
		parent.reloadSelf();
	}
}

/*~~全选复选框~~*/
function checkallbox() { 
	var boxarray = document.getElementsByName("image"); 
	for(var i = 0; i < boxarray.length; i++) { 
		boxarray[i].checked = true; 
	} 
}  

/*~~取消选中全部复选框~~*/
function discheckallbox() { 
	var boxarray = document.getElementsByName("image"); 
	for(var i = 0; i < boxarray.length; i++) { 
		boxarray[i].checked = false; 
	} 
} 
/*~~排序号更新~~*/
function upSortNo(sSerialNo,sSortNo){
	sReturn=RunMethod("ImageManage","upSortNo",sSerialNo+","+sSortNo);
	reloadSelf();
}

</script>
<script >
function createIframe(){ 
	//mask遮罩层 
	var newMask=document.createElement("div"); 
	newMask.id="mDiv"; 
	newMask.style.position="absolute"; 
	newMask.style.zIndex="1"; 
	_scrollWidth=Math.max(document.body.scrollWidth,document.documentElement.scrollWidth); 
	_scrollHeight=Math.max(document.body.scrollHeight,document.documentElement.scrollHeight); 
	// _scrollHeight = Math.max(document.body.offsetHeight,document.documentElement.scrollHeight); 
	newMask.style.width=_scrollWidth+"px"; 
	newMask.style.height=_scrollHeight+"px"; 
	newMask.style.top="0px"; 
	newMask.style.left="0px"; 
	newMask.style.background="#33393C"; 
	//newMask.style.background = "#FFFFFF"; 
	newMask.style.filter="alpha(opacity=40)"; 
	newMask.style.opacity="0.40"; 
	newMask.style.display='none'; 
	var objDiv=document.createElement("DIV"); 
	objDiv.id="div1"; 
	objDiv.name="div1"; 
	objDiv.style.width="80%"; 
	objDiv.style.height="75%"; 
	//objDiv.style.left=(_scrollWidth-900)/2+"px"; 
	//objDiv.style.top=(_scrollHeight-400)/2+"px";
	objDiv.style.left="10%";
	objDiv.style.top="10%";
	objDiv.style.position="absolute"; 
	objDiv.style.zIndex="2"; //加了这个语句让objDiv浮在newMask之上 
	objDiv.style.display="none"; //让objDiv预先隐藏 
	objDiv.innerHTML=' <div id="drag" style="position:absolute;height:20px;width:100%;z-index:10001;top:0; background-color:#0033FF;cursor:move ;" align="right"> <input type=button value="X" onclick="HideIframe(document.getElementById(\'mDiv\'),document.getElementById(\'div1\'));"/> </div>'; 
	//更改了X按钮为触发关闭事件。 
	objDiv.style.border="solid #0033FF 3px;"; 
	var frm=document.createElement("iframe"); 
	frm.id="ifrm"; 
	frm.name="ifrm"; 
	frm.style.position="absolute"; 
	frm.style.width="100%"; 
	frm.style.height="100%"; 
	frm.style.top=20; 
	frm.style.display=''; 
	frm.frameborder=0; 
	objDiv.appendChild(frm); 
	// newMask.appendChild(objDiv); //问题出在这里：你把frame所在的div变成了 newMask的子元素，当newMask透明度更改时，当然会影响到frame 
	document.body.appendChild(newMask); 
	document.body.appendChild(objDiv); 
	var objDrag=document.getElementById("drag"); 
	var drag=false; 
	var dragX=0; 
	var dragY=0; 
	objDrag.attachEvent("onmousedown",startDrag); 
	function startDrag(){ 
	if(event.button==1&&event.srcElement.tagName.toUpperCase()=="DIV"){ 
	objDrag.setCapture(); 
	objDrag.style.background="#0000CC"; 
	drag=true; 
	dragX=event.clientX; 
	dragY=event.clientY; 
	} 
	}; 
	objDrag.attachEvent("onmousemove",Drag); 
	function Drag(){ 
	if(drag){ 
	var oldwin=objDrag.parentNode; 
	oldwin.style.left=oldwin.offsetLeft+event.clientX-dragX; 
	oldwin.style.top=oldwin.offsetTop+event.clientY-dragY; 
	oldwin.style.left=event.clientX-100; 
	oldwin.style.top=event.clientY-10; 
	dragX=event.clientX; 
	dragY=event.clientY; 
	} 
	}; 
	objDrag.attachEvent("onmouseup",stopDrag); 
	function stopDrag(){ 
	objDrag.style.background="#0033FF"; 
	objDrag.releaseCapture(); 
	drag=false; 
	}; 
	}
	
	function htmlEditor(sPath){ 
	var frm=document.getElementById("ifrm"); 
	var objDiv=document.getElementById("div1"); 
	var mDiv=document.getElementById("mDiv"); 
	mDiv.style.display=''; 
	var iframeTextContent=''; 
	iframeTextContent+=' <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">'; 
	iframeTextContent+=' <html xmlns="http://www.w3.org/1999/xhtml">'; 
	iframeTextContent+=' <head>'; 
	iframeTextContent+=' <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />'; 
	iframeTextContent+=' </head>'; 
	iframeTextContent+=' <body>'; 
	iframeTextContent+=' <img name="small" border="0" src="'+sPath+'" width="100%"  />'; 
	iframeTextContent+=' </body>'; 
	iframeTextContent+=' </html>'; 
	frm.contentWindow.document.designMode='off'; 
	frm.contentWindow.document.open(); 
	frm.contentWindow.document.write(iframeTextContent); 
	frm.contentWindow.document.close(); 
	objDiv.style.display = ""; //显示浮动的div 
	var objGo=frm.contentWindow.document.getElementById("btGo"); 
	objGo.attachEvent("onclick",function (){ 
	HideIframe(mDiv,objDiv); 
	}); 
	} 
	
	function HideIframe(mDiv,objDiv){ 
	mDiv.style.display='none'; 
	objDiv.style.display = "none"; //隐藏浮动的div 
	} 
</script>
</head>

<body onLoad="createIframe()">
	<object id="amarsoftECMObject" classid="clsid:FED91F2B-DDF8-42E7-9CBF-6FA56B80EDF4" codebase="AmarECM_ActiveXSetup.CAB#version=1,0,0" width="100%" border="0" style="margin:0px;border-width: 0;padding-top: 0px;"></object>
	<script type="text/javascript" >
           function initActiveX() {
               var obj = document.getElementById("amarsoftECMObject");
               obj.height = 30;
             	/* 参数：对象类型，对象编号，影像类型，权限控制代码，各个图片文件的路径(多张图片时以|为分割)，操作人，操作机构，处理影像的servlet地址 */
               obj.initFull( "<%=CurUser.UserID%>", "<%=CurUser.OrgID%>","<%=servletPath%>","<%=sObjectNo%>","<%=sObjectType%>","<%=sTypeNo%>" );
           }
           
       	$(document).ready(function(){
       		initActiveX();
    	});
      </script>
      <input type="button" value="修改影像类型" onclick="updatetype()"/>&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="删除影像" onclick="deleImage()"/>&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="全&nbsp;选" onclick="checkallbox()"/>&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="取消全选" onclick="discheckallbox()"/>
      <br>
      <table style="width:100%;height:100%;">
	      <tr>
		      <td style="width:230px;height:100%;">
		      	<div style="height:500px; overflow:auto; border:1px solid #cceff5;background:#fafcfd;">
		      		<%
		      			String sTypeNo1 = "";
		      			String sTypeName = "";
		      			String sSql1 = "select TypeNo,TypeName from ecm_image_type where isinuse = '1' and typeno <> '50' order by typeno";
		      			ASResultSet rs1 = Sqlca.getASResultSet(sSql1);
		      			while(rs1.next()){
		      				sTypeNo1 = rs1.getString("TypeNo");
		      				sTypeName = rs1.getString("TypeName");
		      				if(sTypeNo1.length() == 2){
		      					%>
		      					<div style="overflow:auto; border:1px solid #cceff5;background:#fafcfd;">
		      					<%=sTypeName%>
		      					</div>
		      					<%
		      				}else{
		      					%>
	      							&nbsp;&nbsp;&nbsp;&nbsp;<input name="imagetype" type="radio" value="<%=sTypeNo1%>" /><%=sTypeName%><br>
		      					<%
		      				}
		      			}
		      			rs1.getStatement().close();
		      		%>
		      	</div>
		      </td>
		      <td>
		      	<div style="height:500px; overflow:auto; border:1px solid #cceff5;background:#fafcfd;">
			      <%
			      String sPath = "",sSerialNo = "",sSortNo = "";
			      String sSql = "select SerialNo,DocumentID,SortNo from ECM_PAGE where ECM_PAGE.objectNo='"+sObjectNo+"' and  ECM_PAGE.documentId is not null and typeNo = '"+sTypeNo+"' order by to_number(SortNo),SerialNo";
			      ASResultSet rs = Sqlca.getASResultSet(sSql);
			      while(rs.next()){
			    	  sPath = rs.getString("DocumentID");
			    	  sSerialNo = rs.getString("SerialNo");
			    	  sSortNo = rs.getString("SortNo");
			    	  //测试环境使用
			    	  String src = "/servlet/ContentServlet?Id="+sPath;
			    	  //生产环境使用
			    	  //String src = "http://"+sServletPath+"/servlet/ContentServlet?Id="+sPath;
			    	  //System.out.println(src);
			    	  //测试环境使用
			    	  String sNewPath = sWebRootPath+src;
			    	  //生产环境使用
			    	  //String sNewPath = src;
			    	  
					%>
			  	  		<div style="border:1px solid #ffcc00;background:#fffff7;width:200px;height:150px;float:left;">
			  	  		<input name="image" type="checkbox" value="<%=sSerialNo%>" />排序号：<input name="<%=sSerialNo%>" id="<%=sSerialNo%>" style='width:50px;height:15px' type="text" onkeyup="if(!/^\d+$/.test(this.value)) {this.value=this.value.replace(/[^\d]+/g,'');}" value="<%=sSortNo%>"  onBlur="{var sSortNo = this.value;upSortNo('<%=sSerialNo%>',sSortNo)}" />
			  	  		<!-- <input type="button" value="保&nbsp;存" onclick="upSortNo('<%=sSerialNo%>')"/> -->
			  	  		<img style='width:200px;height:150px' src= "<%=sNewPath%>" onClick="htmlEditor('<%=sNewPath%>')"/>
			  	  		</div>
			  	  	
			  	  	<%
			      }
			     
			      rs.getStatement().close();
			      %>
			      <div>
		      </td>
	      </tr>
      </table>
</body>
</html>



<%@ include file="/IncludeEnd.jsp"%>