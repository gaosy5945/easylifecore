<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <script type="text/javascript" src="<%=request.getContextPath()%>/ImageTrans/jquery-1.7.2.min.js"></script>
 <%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "Ӱ�����������б�";
	//���ҳ�����
	String sStartWithId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("StartWithId"));
	if (sStartWithId == null) sStartWithId = "";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ImageFileTypeList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//doTemp.generateFilters(Sqlca);
	//doTemp.parseFilterData(request,iPostChange);
	//CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.multiSelectionEnabled=true;//���ÿɶ�ѡ
	System.out.println("-----------"+doTemp.SelectClause);
	doTemp.WhereClause = "Where TypeNo Like '"+sStartWithId+"%'";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(50);//����ÿҳ��ʾ��¼����

	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow( "" );
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","ȫѡ","ȫѡ","SelectedAll()",sResourcesPath},
		{"true","","Button","��ѡ","��ѡ","SelectedBack()",sResourcesPath},
		{"true","","Button","ȡ��ȫѡ","ȡ��ȫѡ","SelectedCancel()",sResourcesPath}, 
		{"true","","Button","ȷ��","��ӡ������","printBarCode()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		as_add( "myiframe0" );
		var param = "StartWithId=<%=sStartWithId%>";
		var sNewExampleTypeNo = RunJavaMethodSqlca( "com.amarsoft.app.als.image.ImageUtil", "GetNewTypeNo", param );
		setItemValue( 0, getRow(), "TypeNo", sNewExampleTypeNo );
	}
	
	function saveRecord(){
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");
		var sTypeName = getItemValue(0,getRow(),"TypeName");
		if( (typeof sTypeNo !="undefined") && (sTypeNo == "" || sTypeName == "") ){
			alert( "���ͱ�š��������Ʋ�����Ϊ��" );
			return;
		}else{
			as_save("myiframe0")
			parent.frames["frameleft"].reloadSelf();
		}
			
	}
	
	function deleteRecord(){
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			param = "imageTypeNo="+sTypeNo;
			RunJavaMethodSqlca( "com.amarsoft.app.als.image.ManagePRDImageRela", "delRelationByImageTypeNo", param );
		}
	}
	/* ��ӡ������ */
	function printBarCode(){
		var sTypeNo = getItemValueArray(0,"TypeNo");
		var sTypeName = getItemValueArray(0,"TypeName");
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}

		//alert(sTypeNo);
		//alert(sTypeName);

		var typeNoString = sTypeNo.toString();
		var typeNameString = sTypeName.toString();
		
		var typeNoArray = typeNoString.split(",");//�Զ��ŷָ�,��������
		//alert(typeNoArray.length);
		if(typeNoArray.length > 15){//ÿ��ѡ������ϲ��ܳ���15.
			alert("һ�����ֻ��ѡ��15������!");
		    return ;
		}
		//var typeNameArray = typeNameString.split(",");//�Զ��ŷָ�,��������
		
		//alert(typeNoArray);
		//alert(typeNameArray);
		
		var re =/,/g; //����
		typeNoString = typeNoString.replace(re,"@");	
		typeNameString = typeNameString.replace(re,"@");	
		//alert(typeNoString);
		//alert(typeNameString);
		//self.returnValue=typeNoArray;//��������
		self.returnValue=typeNoString;
		self.close();
		
		//var param = "TypeNo="+typeNoString+"&TypeName="+typeNameString;
		//popComp("PrintBarCode","/ImageManage/PrintBarCode.jsp",param,"");
	}
	
	/*~[Describe=ȫѡObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function SelectedAll(){//ȫѡ
		
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != "��"){
				     setItemValue(0,iMSR,"MultiSelectionFlag","��");
			}
		}
	}
	
	/*~[Describe=��ѡObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function SelectedBack(){//��ѡ
		
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != "��"){
				    setItemValue(0,iMSR,"MultiSelectionFlag","��");
			}else{
				setItemValue(0,iMSR,"MultiSelectionFlag","");
			}
		}
	}
	
	/*~[Describe=ȡ��ȫѡObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function SelectedCancel(){//ȡ��ȫѡ
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != ""){
				setItemValue(0,iMSR,"MultiSelectionFlag","");
			}
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
