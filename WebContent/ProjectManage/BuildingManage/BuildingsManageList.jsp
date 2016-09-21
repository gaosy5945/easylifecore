<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("BuildingsManageList");
	//doTemp.setJboWhereWhenNoFilter(" and 1=2 ");
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	dwTemp.setParameter("InputUserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����¥��","����¥��","newBuilding()","","","","",""},
			{"true","","Button","¥������","¥������","viewBuilding()","","","","",""},
			{"true","","Button","��������","��������","importBuilding()","","","","",""},
			{"true","","Button","������Ŀ��ѯ","������Ŀ��ѯ","selectRelativeProject()","","","","",""},
			{"true","All","Button","ɾ��","ɾ��","deleteBuilding()","","","","",""},
			{"false","","Button","����ҵ���ѯ","����ҵ���ѯ","selectRelativeBusiness()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	//¥�̿����-����¥��(Developer:xtliu)
	function newBuilding(){
		var result = AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageNew.jsp","DialogTitle=�½�¥��","resizable=yes;dialogWidth=500px;dialogHeight=180px;center:yes;status:no;statusbar:no");
		if(typeof(result) == "undefined" || result.length == 0){
			return;
		}else{
			result = result.split("@");
			var k=result.length;
			var j=result.length;
			if(result[0] == "true"){
				var serialNos = "";
				for(var i=1; i<result.length-5;i++){
					serialNos +=result[i]+",";
				}
				var buildingName = result[k-5];
				var areaCode = result[k-4];
				var locationC1 = result[k-3];
				var inputOrgID = result[k-2];	
				var inputUserID = result[k-1];
				AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageCheckList.jsp","SerialNo="+serialNos+"&buildingName="+buildingName+"&areaCode="+areaCode+"&locationC1="+locationC1+"&inputUserID="+inputUserID+"&inputOrgID="+inputOrgID,"resizable=yes;dialogWidth=650px;dialogHeight=500px;center:yes;status:no;statusbar:no");
			}else if(result[0] == "listResultNull"){
				var buildingName = result[j-5];
				var areaCode = result[j-4];
				var locationC1 = result[j-3];
				var inputOrgID = result[j-2];
				var inputUserID = result[j-1];
				if(confirm("������¥�̣��Ƿ��������¥�̣�")){
					var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.CreateBuilding", "createBuilding", "buildingName="+buildingName+",areaCode="+areaCode+",locationC1="+locationC1+",inputOrgID="+inputOrgID+",inputUserID="+inputUserID);
					result = result.split("@");
					if(result[0]=="true"){
						alert("¥���½��ɹ���");
						AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageInfo.jsp", "SerialNo="+result[1], "");
					}else{
						alert("¥���½�ʧ�ܣ�");
						return;
					}
				}
			}else if(result[0] == "false"){
				alert("��¥���Ѵ���");
				return;
			}else{
				return;
			}
		}
	}
	//¥�̿����-¥������(Developer:xtliu)
	function viewBuilding(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageInfo.jsp", "SerialNo="+serialNo, "");
		reloadSelf();
	}
	//¥�̿����-��������(Developer:xtliu)
	function importBuilding(){
	    var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
	    var parameter = "clazz=jbo.import.excel.BUILDING_IMPORT";
	    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
	    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
	}
	//¥�̿����-������Ŀ��ѯ(Developer:xtliu)
	function selectRelativeProject(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		AsControl.PopPage("/ProjectManage/BuildingManage/RelativeProjectList.jsp", "SerialNo="+serialNo, "resizable=yes;dialogWidth=800px;dialogHeight=460px;center:yes;status:no;statusbar:no");
	}
	//¥�̿����-ɾ��(Developer:xtliu)
	function deleteBuilding(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		if(confirm('ȷʵҪɾ����?')){
			var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectBuildingIsDelete", "selectBuildingIsDelete","BuildingSerialNo="+serialNo);
			if(sReturn == "ProjectSerialNoFull"){
				alert("��¥�̴��ڹ����ĺ�����Ŀ��������ɾ����");
				return;
			}else{
				sResult = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.DeleteBuilding", "deleteBuilding", "BuildingSerialNo="+serialNo);
				if(sResult == "SUCCEED"){
					alert("ɾ���ɹ���");
				}
				reloadSelf();
			}
		}
	}
	//¥�̿����-����ҵ���ѯ(Developer:xtliu)
	function selectRelativeBusiness(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		AsControl.PopPage("/ProjectManage/BuildingManage/RelativeBusinessInfo.jsp", "SerialNo="+serialNo, "");
	
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>