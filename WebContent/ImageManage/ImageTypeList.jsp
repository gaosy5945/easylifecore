<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="java.util.Date"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  ljzhong 2014/09/25
		Tester:
		Describe:�ſ�ȷ���б�ҳ��
		Input Param:
				
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ſ�ȷ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	//�������������������͡�������

	//����ֵת��Ϊ���ַ���
	String sStartWithId = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("StartWithId",2)));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//��sSql�������ݴ������
	String sTempletNo = "ImageFileTypeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.UpdateTable = "ECM_IMAGE_TYPE";
	doTemp.setKey("TypeNo",true);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "0"; //����Ϊֻ��
	dwTemp.setPageSize(20);
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sStartWithId);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��

	String sButtons[][] = {
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�����¼","saveRecord()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
			{"true","","Button","��ӡ������","��ӡ������","printBarCode()",sResourcesPath},
		};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		as_add( "myiframe0" );
		var param = "<%=sStartWithId%>";
		var sNewExampleTypeNo = RunMethod("CBBusinessManage","ImageUtil",param);
		setItemValue( 0, getRow(), "TypeNo", sNewExampleTypeNo );
	}
	
	/*~[Describe=�����¼;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(){
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");
		var sTypeName = getItemValue(0,getRow(),"TypeName");
		if( (typeof sTypeNo !="undefined") && (sTypeNo == "" || sTypeName == "") ){
			alert( "���ͱ�š��������Ʋ�����Ϊ��" );
			return;
		}else{
			as_save("myiframe0");
			parent.frames["frameleft"].reloadSelf();
		}
			
	}
	
	/*~[Describe=ɾ����ѡ�еļ�¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			RunMethod( "CBBusinessManage", "delRelationByImageTypeNo", sTypeNo );
			parent.frames["frameleft"].reloadSelf();
		}
	}
	
	/*~[Describe=��ӡ������;InputParam=��;OutPutParam=��;]~*/
	function printBarCode(){
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");
		var sTypeName = getItemValueArray(0,getRow(),"TypeName");
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}

		//alert(sTypeNo);
		//alert(sTypeName);

		var typeNoString = sTypeNo.toString();
		var typeNameString = sTypeName.toString();
		var re =/,/g; 
		typeNoString = typeNoString.replace(re,"@");	
		typeNameString = typeNameString.replace(re,"@");	
		var param = "TypeNo="+typeNoString+"&TypeName="+typeNameString;
		OpenComp("PrintBarCode","/ImageManage/PrintBarCode.jsp",param,"");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;
	my_load(2,0,'myiframe0');
	<%if(!doTemp.haveReceivedFilterCriteria())
	{
	%>
		showFilterArea();
	<%
	}
	%>
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>