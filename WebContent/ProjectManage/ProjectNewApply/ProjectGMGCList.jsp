<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String prjSerialNo = CurPage.getParameter("SerialNo");
	if(prjSerialNo == null) prjSerialNo = "";

	ASObjectModel doTemp = new ASObjectModel("ProjectGMGCList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ProjectSerialNo", prjSerialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","����","����","viewAndEdit()","","","","btn_icon_detail",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	<%/*��¼��ѡ��ʱ�����¼�*/%>
	function mySelectRow(){
		var ObjectType = getItemValue(0,getRow(),"ObjectType");
		var clSerialNo = getItemValue(0,getRow(),"SerialNo");
		var divideType = getItemValue(0,getRow(),"divideType");
		if(!ObjectType) return;
		parent.OpenInfo(ObjectType,divideType,clSerialNo);
	}
	function viewAndEdit(){
		var prjSerialNo = "<%=prjSerialNo%>";
		var CLType = getItemValue(0,getRow(),"PROJECTCREDITTYPE");
		var templetNo = "";
		if(CLType == "��ģ���"){
			templetNo="GMCLView";
		}else if(CLType == "�������"){
			templetNo="DBCLView";
		}
		if(templetNo == ""){
			alert("��ѡ��һ�������Ϣ��");
			return;
		}
		AsControl.PopView("/ProjectManage/ProjectNewApply/GMCLView.jsp", "templetNo="+templetNo+"&ProjectSerialNo="+prjSerialNo, "resizable=yes;dialogWidth=500px;dialogHeight=300px;center:yes;status:no;statusbar:no");
	}
	$(document).ready(function(){
		mySelectRow();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
