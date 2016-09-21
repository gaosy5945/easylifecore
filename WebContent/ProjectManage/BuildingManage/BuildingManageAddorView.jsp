<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	
    ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("BuildingsManageList",BusinessObject.createBusinessObject(),CurPage);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("InputUserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����¥��","����¥��","newBuilding()","","","","btn_icon_add",""},
			{"true","","Button","¥������","¥������","viewBuilding()","","","","btn_icon_detail",""},
			{"true","All","Button","ȷ��","ȷ��","OK()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<HEAD>
<title>��ѯ¥����Ϣ</title>
</HEAD>
<script type="text/javascript">
	function newBuilding(){
		var result = AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageNew.jsp","DialogTitle=�½�¥��","resizable=yes;dialogWidth=500px;dialogHeight=180px;center:yes;status:no;statusbar:no");
		if(typeof(result) == "undefined" || result.length == 0){
			return;
		}
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
			reloadSelf();
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
			reloadSelf();
		}else if(result[0] == "false"){
			alert("��¥���Ѵ���");
			return;
		}else{
			reloadSelf();
		}
	}
	
	function viewBuilding(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageInfo.jsp", "SerialNo="+serialNo, "");
		reloadSelf();
	}

	function OK(){
		var REALESTATEID = getItemValue(0,getRow(),"SERIALNO");//¥�̱��
		var BUILDINGNAME = getItemValue(0,getRow(),"BUILDINGNAME");//¥������
		top.returnValue = REALESTATEID+"@"+BUILDINGNAME;
 		top.close();

	}


</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
