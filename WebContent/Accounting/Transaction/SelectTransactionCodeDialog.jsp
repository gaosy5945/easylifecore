<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ include file="/Accounting/include_accounting.jspf"%>

<%
	/*
		Content: ѡ�����ͶԻ���ҳ��
		Input Param:
			SelName����ѯ����
			ParaString�������ַ���
	 */
	//��ȡ��������ѯ���ƺͲ���
	String sParaString = CurPage.getParameter("ParaString");
	sParaString = (sParaString == null)?"":java.net.URLDecoder.decode(sParaString, "UTF-8");
	//����ֵת��Ϊ���ַ���
	if(sParaString == null) sParaString = "";
%>
<html>
<head> 
<title>ѡ����Ϣ</title>
<script type="text/javascript">
	function TreeViewOnClick(){
		var sType = getCurTVItem().type;
		if(sType != "page" && sType!='folder'){
			alert("ҳ�ڵ���Ϣ����ѡ��������ѡ��");
		}
	}
	
	function returnValue(){
			var node = getCurTVItem();
			if(!node || node.id == "1")  return;
			var sType = node.type;
			if(sType != "page" && sType!='folder'){
				alert("ҳ�ڵ���Ϣ����ѡ��������ѡ��");
				return;
			}
			parent.sObjectInfo = node.value+"@"+node.name;
	}
	
	//������ͼ˫���¼���Ӧ���� add by hwang 20090601
	function TreeViewOnDBLClick(){
		parent.returnSelection();
	}	
	
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,"����ѡ���б�","right");
		tviTemp.TriggerClickEvent=true;
		
		String[] codes; 
		if("All".equalsIgnoreCase(sParaString))
		{
			codes = TransactionConfig.getTransactionCodes();
		}else
		{
			codes = sParaString.split(",");
		}
		String sFolder1=tviTemp.insertFolder("root","������Ϣ","",1);
		
		for(int i=0;i<codes.length;i++){
			try{
				String TransName = TransactionConfig.getTransactionConfig(codes[i],"TransactionName");
				tviTemp.insertPage(sFolder1,TransName,codes[i],"",i);
			}catch(Exception e){
				
			}
		}
		out.println(tviTemp.generateHTMLTreeView());
	%>

		selectItemByName("������Ϣ");
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