<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:UI���������ҳ��
	 */
	String PG_TITLE = "UI�������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;UI�������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"UI�������","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����
 
	String sFolder9 = tviTemp.insertFolder("root","Ӧ�ð���","",1);
	tviTemp.insertPage(sFolder9,"������","",1);
	tviTemp.insertPage(sFolder9,"ͨ��ģ�����INFO","",2);
	tviTemp.insertPage(sFolder9,"��Ϣ����","",4);
	tviTemp.insertPage(sFolder9,"TreeTable","",5);
	tviTemp.insertPage(sFolder9,"��ȷ�����ͼ","",6);
	tviTemp.insertPage(sFolder9,"�෽��������","",7);
	tviTemp.insertPage(sFolder9,"DWTable","",8);
	tviTemp.insertPage(sFolder9,"�����û�","",8);
	tviTemp.insertPage(sFolder9,"���빦����ͼ","",9);
	
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	<%/*treeview����ѡ���¼�;���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������*/%>
	function TreeViewOnClick(){
		var sCurItemname = getCurTVItem().name;
		 if(sCurItemname=='������'){
			AsControl.OpenView("/FrameCase/AppCase/WizCase.jsp","","right");
		}else  if(sCurItemname=='ͨ��ģ�����INFO'){
			AsControl.OpenView("/FrameCase/AppCase/JsonInfo.jsp","","right");
		}else  if(sCurItemname=='���'){
			AsControl.OpenView("/FrameCase/AppCase/JsonInfo.jsp","","right");
		}else  if(sCurItemname=='��Ϣ����'){
			AsControl.OpenView("/FrameCase/AppCase/PushMessage.jsp","","right");
		}else  if(sCurItemname=='TreeTable'){
			AsControl.OpenView("/FrameCase/AppCase/TreeTableDemo.jsp","","right");
		}else  if(sCurItemname=='��ȷ�����ͼ'){
			AsControl.OpenView("/FrameCase/AppCase/TreeTableDemo2.jsp","","right");
		}else  if(sCurItemname=='�෽��������'){
			AsControl.OpenView("/FrameCase/AppCase/TreeTableDemo3.jsp","","right");
		}else  if(sCurItemname=='DWTable'){
			AsControl.OpenView("/FrameCase/AppCase/DWTable.jsp","","right");
		}else  if(sCurItemname=='�����û�'){
			AsControl.OpenView("/Frame/page/sys/UserOnLineList.jsp","","right");
		}else  if(sCurItemname=='���빦����ͼ'){
			AsControl.OpenView("/AppMain/resources/widget/TreeTab.jsp","CodeNo=TreeTab","right");
		}else  if(sCurItemname=='���ܵ���ͼ'){
			AsControl.OpenView("/AppMain/resources/widget/FunctionView.jsp","FunctionID=CustomerDetail&CustomerID=2014041800000001","right");
		}
		else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/%>
	function initTreeVeiw(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		//selectItemByName("Border");
		//selectItemByName("����List");
		selectItemByName("����Info");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��
		myleft.width = 250;
	}

	initTreeVeiw();
</script>
<%@ include file="/IncludeEnd.jsp"%>