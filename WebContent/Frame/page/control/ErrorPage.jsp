<%@ page contentType="text/html; charset=GBK"%><%@
 page import="com.amarsoft.awe.AWEException" isErrorPage="true" session="true"%><%@
 page import="com.amarsoft.awe.RuntimeContext"%><%@
 page import="com.amarsoft.awe.Configure"%><%@
 page import="com.amarsoft.awe.control.PageConstants"%><%@
 page import="com.amarsoft.awe.res.AppManager"%><%
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	
    String sWebRootPath = request.getContextPath();
    RuntimeContext CurARC = (RuntimeContext)session.getAttribute("CurARC");
    
	String sMessageText = exception.getMessage();
	if (CurARC==null && (sMessageText!=null && sMessageText.equals("------Timeout------"))) {
		response.sendRedirect(request.getContextPath() + PageConstants.SESSION_EXPIRE_PAGE);
		return;
	}
    AWEException awee = new AWEException(exception);
    boolean bShowDetail = false;	
    Configure CurConfig = Configure.getInstance(application);
	if(CurConfig !=null && "Development".equals(CurConfig.getConfigure("RunMode")))  bShowDetail=true;
%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/syspage.css"/>
</head>
<body >
	<div id="normarr" class="nor_doc">
      <div class="nor_show">
            <div class="nor_tit">Ò³Ãæ´íÎó</div>
            <div class="nor_tit"><%=awee.getMesssageNo()%></div>
            <% if (bShowDetail) { %>
        	<div class="nor_info"><%=bShowDetail?awee.getMessage():"´íÎó"%></div>
            <div class="nor_line"></div>
            <div class="nor_img"  onDblClick="if (document.getElementById('detailerr').style.display=='none'){document.getElementById('detailerr').style.display='block';document.getElementById('normarr').style.display='none';document.getElementById('miniarr').style.display='block';}else{document.getElementById('detailerr').style.display='none'}"></div>
            <% } %>
      </div>
      <div class="nor_btnzone" style="width:100%; height:60px; float:left;">
      	<div onClick="window.open('<%=sWebRootPath%>/<%=PageConstants.LOGIN_PAGE%>','_top');" class="nor_btn" id="logout"></div>
      	<div onClick="window.open('<%=sWebRootPath%>/Redirector?ComponentURL=<%=AppManager.getMainUrl()%>&AppID=<%=AppManager.getMainAppID()%>','_top');" class="nor_btn_home" id="backhome"></div>
      </div>
    </div>
     <% if (bShowDetail) { 
			exception.printStackTrace();
			exception.fillInStackTrace();
     %>
    <div id="miniarr" class="mini_img" onDblClick="if (document.getElementById('detailerr').style.display=='block'){document.getElementById('detailerr').style.display='none';document.getElementById('normarr').style.display='block';document.getElementById('miniarr').style.display='none';}else{document.getElementById('detailerr').style.display='block'}"></div>
	<div id="detailerr" style="display:none">
		<blockquote><pre>
			<%
				exception.printStackTrace(new java.io.PrintWriter(out));
			%>
		</pre></blockquote>                 
	</div>
   <% } %>
</body>
</html>