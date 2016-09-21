<%@page import="com.amarsoft.awe.ui.layout.grouppage.GroupModelManager"%>
<%@ page import="com.amarsoft.are.jbo.*" %>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%><%
	String sGroupID = CurPage.getParameter("GroupID");
	List<BizObject> items = new GroupModelManager().getItemsByGroupID(sGroupID);
%>
<body>
<textarea cols="90" rows="27" id="code">
&lt;%@page import="com.amarsoft.awe.ui.layout.grouppage.GroupModelManager"%&gt;
&lt;%@ page contentType="text/html; charset=GBK"%&gt;&lt;%@
 include file="/Frame/resources/include/include_begin.jspf"%&gt;&lt;%
    //获得组合页面管理器实例
    GroupModelManager m = new GroupModelManager("<%=sGroupID %>",CurUser);
    //设置全局参数
    m.setParameter("key=value");

    //设置参数，以ItemNo为键，参数为值
  <%
  for(int i=0;i<items.size();i++){
	String pre = "    ";
	if(i==0)pre = "  ";
  	out.println(pre+"m.setParameter(\""+items.get(i).getAttribute("ItemNo").getString()+"\",\"key=value\");");
  }
  %>
    //输出
    out.println(m.getHtmlText());
%&gt;&lt;%@ include file="/Frame/resources/include/include_end.jspf"%&gt;
</textarea>
	<div style="margin-top: 6px;" align="center">
		<table>
			<tr>
				<td><%=new Button("复制到粘贴板","复制到粘贴板","copyToClipboard()").getHtmlText()%></td>
				<td><%=new Button("另存为文件","另存为文件","saveAS()").getHtmlText()%></td>
			</tr>
		</table>
	</div>
	<iframe name="SaveAS" style="display: none"></iframe>
</body>
<script type="text/javascript">
	var txt = document.getElementById("code").innerHTML;
	txt = txt.replace(/&lt;/g,"<");
	txt = txt.replace(/&gt;/g,">");
	
	function saveAS(){
		var fileName="<%=sGroupID %>";
		var winaa = window.open("","SaveAS","");
		winaa.document.open("text/html","replace");
		winaa.document.charset="GBK";
		winaa.document.write(txt);
		winaa.document.execCommand("SAVEAS",false,fileName);
		winaa.close();		
	}

	function copyToClipboard() {
	    if(window.clipboardData) {   
            window.clipboardData.clearData();   
            var sReturn = window.clipboardData.setData("Text", txt);
	        if(sReturn)alert("复制成功");
	        else {
	        	alert("复制失败");
	        	return;
	        }
	    } else if(navigator.userAgent.indexOf("Opera") != -1) {   
	         window.location = txt;   
	    } else if (window.netscape) {   
	         try {   
	              netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");   
	         } catch (e) {   
	              alert("如果您正在使用FireFox！\n请在浏览器地址栏输入'about:config'并回车\n然后将'signed.applets.codebase_principal_support'设置为'true'");   
	         }   
	         var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard);   
	         if (!clip)   
	              return;   
	         var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable);   
	         if (!trans)   
	              return;   
	         trans.addDataFlavor('text/unicode');   
	         var str = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);   
	         var copytext = txt;
	         str.data = copytext;   
	         trans.setTransferData("text/unicode",str,copytext.length*2);   
	         var clipid = Components.interfaces.nsIClipboard;   
	         if (!clip)   
	              return false;   
	         clip.setData(trans,null,clipid.kGlobalClipboard);   
	         alert("复制成功！");
	    }   
	} 
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>