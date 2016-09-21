<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	//获得页面参数
	String showText =  CurPage.getParameter("ShowText");
	String flag =  CurPage.getParameter("Flag");
	if(showText==null) showText="";
	if(flag==null) flag="";

	String sButtons[][] = {
		{(flag.equals("1"))?"true":"false","","Button","调用RunMethod示例","调用RunMethod示例","run1()","","","","btn_icon_up"},
		{(flag.equals("2"))?"true":"false","","Button","调用RunJavaMethod示例","调用RunJavaMethod示例","run2()","","","", "btn_icon_down"},
		{(flag.equals("3"))?"true":"false","","Button","调用RunJavaMethodSqlca示例","调用RunJavaMethodSqlca示例","run3()","","","","btn_icon_left"},	
		{(flag.equals("4"))?"true":"false","","Button","调用RunJavaMethodTrans示例","调用RunJavaMethodTrans示例","run4()","","","","btn_icon_right"},
		{(flag.equals("5"))?"true":"false","","Button","Transaction串行调用","串行调用","run5()","","","","btn_icon_right"},
		{(flag.equals("5"))?"true":"false","","Button","Transaction层次调用","层次调用","run6()","","","","btn_icon_right"},
	};
%>
<script type="text/javascript">
	function run1(){
		var sExampleId = document.getElementById("ExampleId").value;
		if(!sExampleId){
			alert("请输入ExampleId");
			return;
		}
		var sReturn = RunMethod("示例","GetExmapleName",sExampleId);
		alert(sExampleId+"的名称是"+sReturn);
	}
	function run2(){
		var sExampleId = document.getElementById("ExampleId").value;
		if(!sExampleId){
			alert("请输入ExampleId");
			return;
		}
		var sReturn = AsControl.RunJavaMethod("com.amarsoft.app.awe.framecase.Example4RJM","getExampleName","ExampleId="+sExampleId);
		alert(sExampleId+"的名称是"+sReturn);
	}
	function run3(){
		var sExampleId = document.getElementById("ExampleId").value;
		if(!sExampleId){
			alert("请输入ExampleId");
			return;
		}
		var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.awe.framecase.Example4RJM","deleteExample","ExampleId="+sExampleId);
		alert(sExampleId+"及其父示例被删除"+sReturn);
	}
	function run4(){
		var sExampleId = document.getElementById("ExampleId").value;
		var sApplySum = document.getElementById("ApplySum").value;
		if(!sExampleId || !sApplySum){
			alert("请输入ExampleId及ApplySum");
			return;
		}
		var sReturn = AsControl.RunJavaMethodTrans("com.amarsoft.app.awe.framecase.Example4RJM","changeExample","ExampleId="+sExampleId+",applySum="+sApplySum);
		alert(sExampleId+"的申请金额applySum被更新为"+sApplySum+" "+sReturn);
	}
	function run5(){
		var sExampleId = document.getElementById("ExampleId").value;
		if(!sExampleId){
			alert("请输入ExampleId");
			return;
		}
		var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.awe.framecase.Example4RJM","getExampleName","ExampleId="+sExampleId);
		alert(sReturn);
	}
	function run6(){
		var sExampleId = document.getElementById("ExampleId").value;
		if(!sExampleId){
			alert("请输入ExampleId");
			return;
		}
		var sReturn = AsControl.RunJavaMethodTrans("com.amarsoft.app.awe.framecase.Example4RJM","getExampleName","ExampleId="+sExampleId);
		alert(sReturn);
	}
</script>
<div align="left" style="text-align: left;">
    <pre>
<%if("1".equals(flag)){ %>
		AsControl.RunMethod(ClassName,MethodName,Args)：
		 只能调用已经定义的"类方法"(SQL,Bizlet,AmarScript).
		
		ClassName：方法集名，对应CLASS_CATALOG中的ClassName
		MethodName: 方法名称，对应CLASS_METHOD中的MethodName
		Args：参数形式  "参数值1,参数值2,参数值3..."
				
		var sReturn = AsControl.RunMethod("示例","GetExmapleName",sExampleId);
<%}else if("2".equals(flag)){%>
		AsControl.RunJavaMethod(ClassName,MethodName,Args)：
		调用普通JAVA类.
		
		ClassName：普通JAVA类的全类名
		MethodName: 方法名称
		Args：对应类的成员变量，参数形式 "参数名1=参数值1,参数名2=参数值2,...".
		
		AsControl.RunJavaMethod("com.amarsoft.app.awe.framecase.Example4RJM","getExampleName","ExampleId="+sExampleId);
<%}else if("3".equals(flag)){%>
		AsControl.RunJavaMethodSqlca(ClassName,MethodName,Args)：
		调用普通JAVA类，需要进行Sqlca事务处理采用此function.
		
		ClassName：普通JAVA类的全类名
		MethodName: 方法名称
		Args：对应类的成员变量，参数形式  "参数名1=参数值1,参数名2=参数值2,...".
		
		AsControl.RunJavaMethodSqlca("com.amarsoft.app.awe.framecase.Example4RJM","deleteExample","ExampleId="+sExampleId);
<%}else if("4".equals(flag)){%>
		AsControl.RunJavaMethodTrans(ClassName,MethodName,Args)：
		调用普通JAVA类，需要进行JBOTransation事务处理采用此function.
		
		ClassName：普通JAVA类的全类名
		MethodName: 方法名称
		Args：对应类的成员变量，参数形式  "参数名1=参数值1,参数名2=参数值2,...".
		
		AsControl.RunJavaMethodTrans("com.amarsoft.app.awe.framecase.Example4RJM","changeExample","ExampleId="+sExampleId+",applySum="+sApplySum);
<%} %>
    </pre>
</div>
<%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%>
<table style="text-align: left;">
	<td>请输入ExampleId:</td><td><input id="ExampleId" type="text" /></td>
	</tr>
	<tr>
	<td>请输入ApplySum:</td><td><input id="ApplySum" type="text" /></td>
	</tr>
</table>
<%@ include file="/IncludeEnd.jsp"%>