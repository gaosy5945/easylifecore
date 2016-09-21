<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ include file="/Accounting/include_accounting.jspf"%>

<%
	/*
		Content: 选择树型对话框页面
		Input Param:
			SelName：查询名称
			ParaString：参数字符串
	 */
	//获取参数：查询名称和参数
	String sParaString = CurPage.getParameter("ParaString");
	sParaString = (sParaString == null)?"":java.net.URLDecoder.decode(sParaString, "UTF-8");
	//将空值转化为空字符串
	if(sParaString == null) sParaString = "";
%>
<html>
<head> 
<title>选择信息</title>
<script type="text/javascript">
	function TreeViewOnClick(){
		var sType = getCurTVItem().type;
		if(sType != "page" && sType!='folder'){
			alert("页节点信息不能选择，请重新选择！");
		}
	}
	
	function returnValue(){
			var node = getCurTVItem();
			if(!node || node.id == "1")  return;
			var sType = node.type;
			if(sType != "page" && sType!='folder'){
				alert("页节点信息不能选择，请重新选择！");
				return;
			}
			parent.sObjectInfo = node.value+"@"+node.name;
	}
	
	//新增树图双击事件响应函数 add by hwang 20090601
	function TreeViewOnDBLClick(){
		parent.returnSelection();
	}	
	
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,"交易选择列表","right");
		tviTemp.TriggerClickEvent=true;
		
		String[] codes; 
		if("All".equalsIgnoreCase(sParaString))
		{
			codes = TransactionConfig.getTransactionCodes();
		}else
		{
			codes = sParaString.split(",");
		}
		String sFolder1=tviTemp.insertFolder("root","交易信息","",1);
		
		for(int i=0;i<codes.length;i++){
			try{
				String TransName = TransactionConfig.getTransactionConfig(codes[i],"TransactionName");
				tviTemp.insertPage(sFolder1,TransName,codes[i],"",i);
			}catch(Exception e){
				
			}
		}
		out.println(tviTemp.generateHTMLTreeView());
	%>

		selectItemByName("交易信息");
	}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>
<body class="pagebackground"><iframe name="left" width=100% height=100% frameborder=0 ></iframe></body>
<script>
	startMenu();	
</script>
</html>
<%@ include file="/IncludeEnd.jsp"%>