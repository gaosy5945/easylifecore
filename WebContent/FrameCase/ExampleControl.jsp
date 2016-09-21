<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	//获得页面参数	
	String showText =  CurPage.getParameter("ShowText");
    if ("AsControl.OpenView".equals(showText)) {
    	showText = "AsControl.OpenView(sURL,sPara,sTargetWindow,sStyle)";
    }
    else if  ("AsControl.OpenPage".equals(showText)) {
    	showText = "AsControl.OpenPage(sURL,sPara,sTargetWindow,sStyle)";
    }
    else if  ("AsControl.PopView".equals(showText)) {
    	showText = "AsControl.PopView(sURL,sPara,sStyle)";
    }
    else if  ("OpenPage".equals(showText)) {
    	showText = "OpenPage(sURL,sTargetWindow,sStyle)";
    }
    else if  ("PopPage".equals(showText)) {
    	showText = "PopPage(sURL,sTargetWindow,sStyle),";
    }
    else if  ("PopPageAjax".equals(showText)) {
    	showText = "PopPageAjax(sURL,sTargetWindow,sStyle), 建议使用RunJavaMethod代替";
    }
    String flag =  CurPage.getParameter("Flag");
	if(showText==null) showText="";
	if(flag==null) flag="";
    if(flag.equals("1")){
    	out.write("<table id=\"table0\" border=\"1\" align=\"center\" ><tr><td id=\"text1\" >value1</td><td id=\"text2\" >value2</td></tr>");
    	out.write("<tr><input type=\"button\" value=\"点击调用 PopPageAjax 打开ajax页面获取数据\" onclick=\"run()\" /></tr></table>");
    }
%>
<div>
   	<pre>
   		<%=showText %>
   	</pre>
</div>
<script type="text/javascript">
    	function run(){
    	    var sReturn = PopPageAjax("/FrameCase/ExampleAjax.jsp");
    	    var msg = sReturn.split("@");
    	    document.getElementById("text1").innerHTML = msg[0];
    	    document.getElementById("text2").innerHTML = msg[1];
       	}
</script>
<%@ include file="/IncludeEnd.jsp"%>