<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ�������б�ҳ��
	 */
	String PG_TITLE = "ʾ�������б�ҳ��";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("ExampleList",Sqlca);
	//������Щ�ֶν���С�Ǻϼ�
	doTemp.setColumnType("ApplySum","2");//Ҳ���Կ�����DWģ��������
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);
	dwTemp.ShowSummary = "1";//���û���
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			{"true","","Button","����","����һ����¼","newRecord()","","","",""},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()","","","",""},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","",""},
			{"true","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()","","","",""},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/FrameCase/widget/dw/ExampleInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sExampleId=getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			var sReturn = AsControl.RunJavaMethodSqlca("demo.Example4RJM","deleteExample","ExampleId="+sExampleId);
			if(sReturn=="SUCCESS"){
				alert("ɾ���ɹ�!");
				reloadSelf();
			}			
		}
	}
	
	function viewAndEdit(){
		var sExampleId=getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/FrameCase/widget/dw/ExampleInfo.jsp","ExampleId="+sExampleId,"_self","");
	}
	
	<%/*~[Describe=ʹ��ObjectViewer��;]~*/%>
	function openWithObjectViewer(){
		var sExampleId=getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//ʹ��ObjectViewer����ͼ001��Example��
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init_show();
		my_load_show(2,0,'myiframe0');
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>