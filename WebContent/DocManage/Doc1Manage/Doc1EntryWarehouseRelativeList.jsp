<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("Doc1EntryWarehouseRelativeList");
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	//׷�Ӳ�ѯ������ֻ��ѯ��ʾ��������Ϊ"������Ϣ"��ѺƷ״̬Ϊ"δ��Ѻ"��ѺƷ�б�
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.MultiSelect = true; //�����ѡ
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	
	dwTemp.setPageSize(20);
	dwTemp.setParameter("OrgId", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","ȷ�����ѺƷ","����","add()","","","","btn_icon_add",""},
			{"true","","Button","ѺƷ����","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ȡ��������","ɾ��","cancelBack()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	//������Ч��ѺƷ��Ϣ
	function add(){
		var sDFIInfoList = "";
		var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("��û�й�ѡ�κ��У�");
		 }else{
			 for(var i=0;i<arr.length;i++){
				 var sObjectNo =  getItemValue(0,arr[i],'SERIALNO');//������ͬ������ˮ��
				 var sObjectType =  "jbo.guaranty.GUARANTY_RELATIVE";//������������
				 var sAssetSerialNo =  getItemValue(0,arr[i],'ASSETSERIALNO');//ѺƷ���
				//�жϵ�ǰѺƷ�����ĵ�����ͬ�Ƿ���������
				 var sSql = "select count(*) from doc_file_package where objectNo ='"+sObjectNo+"'";
				 var sReturnCount =  RunMethod("PublicMethod","RunSql",sSql);
				 if(sReturnCount>0){
					 alert("ѺƷ��� ["+sAssetSerialNo+"] �������������");
					 return;
				 }else{
					 sDFIInfoList = "ObjectType="+sObjectType +",ObjectNo="+sObjectNo;
					 var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc1EntryWarehouseAdd", "insertDocFilePackage", sDFIInfoList+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
				 }  
			}
			 if(sReturn == "true"){
				alert("��ӳɹ���");
				self.close();
			 }else {
				alert("���ʧ��!");
				return;
			}
		}
		 //var sUrl = "";
		 //AsControl.OpenPage(sUrl,'_self','');
	}
	
	function edit(){//����ѺƷ
		 var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("��û�й�ѡ�κ��У�");
			 return;
		 }else if(arr.length > 1){
			 alert("��ѡ��һ�����ݣ�");
			 return;
		 }else{
			var serialNo=getItemValue(0,getRow(),"ASSETSERIALNO");		 
			var assetType=getItemValue(0,getRow(),"AssetType");	
			var templateNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CollateralTemplate", "getTemplate", "ItemNo="+assetType);
			templateNo = templateNo.split("@");
			if(templateNo[0]=="false"){
				alert("δ����"+returnValue[1]+"��ģ�壡");
				return;
			}
			var assetSerialNo=getItemValue(0,getRow(),"AssetSerialNo");
			AsCredit.openFunction("CollateralRegisterHandle", "SerialNo="+serialNo+"&AssetSerialNo="+serialNo+"&TemplateNo="+templateNo[1]+"&Mode=1&DocFlag=DocType");
		}
	}
	function deleteRecord(){
		var sUrl = "/DocManage/Doc1Manage/Doc1EntryWarehouseList.jsp";
	}
	function cancelBack(){
		//if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))');
		self.close();
		//var sUrl = "/DocManage/Doc1Manage/Doc1EntryWarehouseList.jsp";
		//AsControl.OpenPage(sUrl,'' ,'_self','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
